import 'package:anant_client/anant_client.dart';
import 'package:anant_client/src/protocol/user/user_role.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/main.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BulkImportUsersPage extends StatefulWidget {
  const BulkImportUsersPage({super.key});

  @override
  State<BulkImportUsersPage> createState() => _BulkImportUsersPageState();
}

class _BulkImportUsersPageState extends State<BulkImportUsersPage> {
  bool _isLoading = false;
  String? _statusMessage;
  List<Map<String, dynamic>>? _createdUsers; // Stores result for PDF
  List<String> _logs = [];

  void _addLog(String message) {
    setState(() {
      _logs.add(message);
    });
  }

  Future<void> _pickAndUploadExcel() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Picking file...';
      _logs.clear();
      _createdUsers = null;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (result != null) {
        final bytes = result.files.single.bytes;
        if (bytes == null) {
          throw Exception("Could not read file data.");
        }

        _addLog('File selected: ${result.files.single.name}');
        _addLog('Parsing Excel...');

        var excel = Excel.decodeBytes(bytes);
        List<User> usersToCreate = [];

        // Assuming data is in the first sheet
        final sheetName = excel.tables.keys.first;
        final table = excel.tables[sheetName];

        if (table == null) throw Exception("Sheet is empty");

        // Iterate rows, skipping header
        bool isHeader = true;
        for (var row in table.rows) {
          if (isHeader) {
            isHeader = false;
            // Ideally check headers here
            continue;
          }

          if (row.isEmpty) continue;
          
          // Safe cell value extraction
          String getValue(int index) {
            if (index >= row.length) return '';
            return row[index]?.value?.toString() ?? '';
          }

          // Extended Columns for comprehensive student/user data:
          // 0: Full Name (Required)
          // 1: Role (Required)
          // 2: Mobile Number (Required)
          // 3: Organization Name (Required)
          // 4: Class (Required for Student)
          // 5: Section (Required for Student)
          // 6: Admission Number (Unique ID Base - Required for Student/Teacher)
          // 7: Roll Number 
          // 8: Date of Birth (YYYY-MM-DD)
          // 9: Gender
          // 10: Parent Mobile Number
          // 11: Blood Group
          // 12: Address
          // 13: Aadhar Number

          final fullName = getValue(0);
          final roleStr = getValue(1).toLowerCase().trim();
          final mobile = getValue(2);
          final orgName = getValue(3);
          final className = getValue(4);
          final sectionName = getValue(5);
          final admissionNumber = getValue(6);
          final rollNumber = getValue(7);
          final dob = getValue(8);
          final gender = getValue(9);
          final parentMobile = getValue(10);
          final bloodGroup = getValue(11);
          final address = getValue(12);
          final aadhar = getValue(13);

          if (fullName.isEmpty || roleStr.isEmpty || orgName.isEmpty) {
            _addLog('Skipping invalid row: $fullName (Missing Name/Role/Org)');
            continue;
          }

          UserRole role;
          try {
            role = UserRole.fromJson(roleStr);
          } catch (e) {
             _addLog('Skipping row: $fullName (Invalid role: $roleStr)');
             continue;
          }

          // Validation for Students
          if (role == UserRole.student) {
            if (className.isEmpty || sectionName.isEmpty || admissionNumber.isEmpty) {
               _addLog('Skipping Student $fullName: Missing Class, Section, or Admission Number');
               continue;
            }
          }

          final user = User(
            fullName: fullName,
            role: role,
            mobileNumber: mobile,
            organizationName: orgName,
            className: className.isEmpty ? null : className,
            sectionName: sectionName.isEmpty ? null : sectionName,
            admissionNumber: admissionNumber.isEmpty ? null : admissionNumber,
            rollNumber: rollNumber.isEmpty ? null : rollNumber,
            dob: dob.isEmpty ? null : dob,
            gender: gender.isEmpty ? null : gender,
            parentMobileNumber: parentMobile.isEmpty ? null : parentMobile,
            bloodGroup: bloodGroup.isEmpty ? null : bloodGroup,
            address: address.isEmpty ? null : address,
            aadharNumber: aadhar.isEmpty ? null : aadhar,
            // Defaults
            country: 'India',
            isActive: true,
            isPasswordCreated: false,
            isPremiumUser: false,
          );
          usersToCreate.add(user);
        }

        if (usersToCreate.isEmpty) {
          throw Exception("No valid users found to import.");
        }

        _addLog('Found ${usersToCreate.length} valid users to create.');
        setState(() {
          _statusMessage = 'Creating users on server...';
        });

        // Call Bulk API
        final results = await client.auth.bulkSignUp(usersToCreate);

        setState(() {
          _createdUsers = results;
          _statusMessage = 'Successfully created ${results.length} users!';
          _addLog('Import complete. Ready to download PDF.');
        });

      } else {
        _addLog('File selection cancelled.');
      }
    } catch (e) {
      _addLog('Error: $e');
      setState(() {
        _statusMessage = 'Error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateAndDownloadPdf() async {
    if (_createdUsers == null || _createdUsers!.isEmpty) return;
    
    _addLog('Generating PDF...');
    
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                   pw.Text('New User Credentials', textScaleFactor: 2, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                   pw.Text(DateTime.now().toString().split(' ')[0]),
                ]
              )
            ),
            pw.Paragraph(text: 'The following users have been successfully registered. Please distribute these credentials safely.'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              headers: ['Full Name', 'Role', 'Anant ID', 'Password'],
              data: _createdUsers!.map((u) => [
                u['fullName'] ?? 'N/A',
                u['role'] ?? 'N/A',
                u['anantId'] ?? 'N/A',
                u['password'] ?? '******', // Assuming password checks
              ]).toList(),
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300))),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'new_users_credentials.pdf'
    );
    _addLog('PDF Print/Save dialog opened.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Bulk Import Users'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions Card
              Card(
                elevation: 0,
                color: Colors.blue.withOpacity(0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blue.withOpacity(0.2))),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(PhosphorIcons.info(), color: Colors.blue),
                          const SizedBox(width: 12),
                          const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Upload an Excel (.xlsx) file with the following columns (in order):'),
                      const SizedBox(height: 8),
                      _buildCodeBlock('Full Name | Role | Mobile | Org Name | Class | Section | Admission No. | Roll No. | DOB | Gender | Parent Mobile | Blood Group | Address | Aadhar'),
                      const SizedBox(height: 8),
                      const Text('• "Admission No." is CRITICAL for unique ID generation for Students.\n• "Class", "Section", and "Admission No." are mandatory for Students.\n• Role options: admin, student, teacher, etc.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Action Area
              if (_createdUsers == null)
                Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade50,
                      ),
                      child: InkWell(
                        onTap: _isLoading ? null : _pickAndUploadExcel,
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                PhosphorIcons.cloudArrowUp(), 
                                size: 64, 
                                color: _isLoading ? Colors.grey : Theme.of(context).primaryColor
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _isLoading ? 'Processing...' : 'Click to Upload Excel File',
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: _isLoading ? Colors.grey : Colors.grey.shade700
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Icon(PhosphorIcons.checkCircle(), size: 80, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      'Success! ${_createdUsers!.length} users created.',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _generateAndDownloadPdf,
                        icon: Icon(PhosphorIcons.downloadSimple()),
                        label: const Text('Download Credentials PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _createdUsers = null;
                          _logs.clear();
                          _statusMessage = null;
                        });
                      },
                      child: const Text('Upload Another File'),
                    )
                  ],
                ),

              const SizedBox(height: 32),
              
              // Status & Logs
              if (_statusMessage != null) ...[
                Text(
                  _statusMessage!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                     color: Colors.black.withOpacity(0.05),
                     borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text('• ${_logs[index]}', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBlock(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
    );
  }
}
