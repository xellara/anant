
import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/common/loading_indicator.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/main.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class StudentSelectionPage extends StatefulWidget {
  const StudentSelectionPage({super.key});

  @override
  State<StudentSelectionPage> createState() => _StudentSelectionPageState();
}

class _StudentSelectionPageState extends State<StudentSelectionPage> {
  List<Classes> _classes = [];
  List<User> _allStudents = [];
  List<User> _displayedStudents = [];
  String? _selectedClassName;
  String? _selectedSection;
  List<String> _availableSections = [];
  
  bool _isLoading = true;
  String? _error;
  
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterStudents);
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch classes and students
      final classes = await client.classes.getAllClasseses();
      final allUsers = await client.user.getAllUsers();
      
      // Filter only students
      final students = allUsers.where((u) => u.role == UserRole.student).toList();
      
      setState(() {
        _classes = classes;
        _allStudents = students;
        
        // Set first class as selected
        if (_classes.isNotEmpty) {
          _selectedClassName = _classes.first.name;
          _updateSectionsForClass();
          _updateStudentList();
        }
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _isLoading = false;
      });
      debugPrint('Error loading student selection data: $e');
    }
  }

  void _updateSectionsForClass() {
    if (_selectedClassName == null) return;
    
    // Get unique sections for selected class
    final sections = _allStudents
        .where((s) => s.className == _selectedClassName && s.sectionName != null)
        .map((s) => s.sectionName!)
        .toSet()
        .toList();
    
    sections.sort();
    
    setState(() {
      _availableSections = sections;
      _selectedSection = sections.isNotEmpty ? sections.first : null;
    });
  }

  void _updateStudentList() {
    if (_selectedClassName == null) return;
    
    setState(() {
      _displayedStudents = _allStudents.where((s) {
        bool matchesClass = s.className == _selectedClassName;
        bool matchesSection = _selectedSection == null || s.sectionName == _selectedSection;
        return matchesClass && matchesSection;
      }).toList();
      
      // Sort by roll number
      _displayedStudents.sort((a, b) {
        final aRoll = int.tryParse(a.rollNumber ?? '999') ?? 999;
        final bRoll = int.tryParse(b.rollNumber ?? '999') ?? 999;
        return aRoll.compareTo(bRoll);
      });
    });
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    
    if (query.isEmpty) {
      _updateStudentList();
      return;
    }
    
    setState(() {
      _displayedStudents = _allStudents.where((s) {
        bool matchesClass = s.className == _selectedClassName;
        bool matchesSection = _selectedSection == null || s.sectionName == _selectedSection;
        bool matchesQuery = (s.fullName?.toLowerCase().contains(query) ?? false) ||
                           (s.rollNumber?.contains(query) ?? false) ||
                           (s.anantId?.toLowerCase().contains(query) ?? false);
        return matchesClass && matchesSection && matchesQuery;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Select Student'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_error!, style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ResponsiveLayout(
                  mobileBody: Column(
                    children: [
                      _buildFilters(),
                      if (_displayedStudents.isNotEmpty) _buildStats(),
                      Expanded(child: _buildStudentList()),
                    ],
                  ),
                  desktopBody: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 350,
                          child: SingleChildScrollView(
                            child: _buildFilters(),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_displayedStudents.isNotEmpty) _buildStats(),
                              const SizedBox(height: 16),
                              Expanded(child: _buildStudentGrid()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Class Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedClassName,
                isExpanded: true,
                hint: const Text('Select Class'),
                icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                items: _classes.map((c) => DropdownMenuItem(
                  value: c.name,
                  child: Text(c.name),
                )).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedClassName = val;
                    _searchController.clear();
                    _updateSectionsForClass();
                    _updateStudentList();
                  });
                },
              ),
            ),
          ),
          
          // Section Dropdown
          if (_availableSections.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSection,
                  isExpanded: true,
                  hint: const Text('All Sections'),
                  icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Sections')),
                    ..._availableSections.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text('Section $s'),
                    )),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedSection = val;
                      _searchController.clear();
                      _updateStudentList();
                    });
                  },
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by Name or Roll No',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.person, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '${_displayedStudents.length} student${_displayedStudents.length != 1 ? 's' : ''} found',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
     return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No students found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
  }

  Widget _buildStudentList() {
    return _displayedStudents.isEmpty
        ? _buildEmptyState()
        : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _displayedStudents.length,
              itemBuilder: (context, index) {
                return _buildStudentCard(_displayedStudents[index]);
              },
            ),
          );
  }

  Widget _buildStudentGrid() {
    return _displayedStudents.isEmpty
        ? _buildEmptyState()
        : GridView.builder(
            padding: const EdgeInsets.all(0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: _displayedStudents.length,
            itemBuilder: (context, index) {
              return _buildStudentCard(_displayedStudents[index]);
            },
          );
  }

  Widget _buildStudentCard(User student) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Text(
            student.rollNumber ?? '?',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student.fullName ?? student.anantId ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ID: ${student.anantId ?? 'N/A'}'),
            if (student.sectionName != null)
              Text('Section: ${student.sectionName}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Show Coming Soon dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.access_time, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 12),
                  const Text('Coming Soon'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attendance Marking',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Teacher attendance marking feature is currently under development and will be available soon.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This will allow teachers to mark daily attendance for students',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
