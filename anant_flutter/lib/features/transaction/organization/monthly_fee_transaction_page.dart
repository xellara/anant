import 'dart:io';
import 'dart:typed_data';
import 'package:anant_flutter/common/widgets/custom_appbar.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:anant_flutter/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:path/path.dart' as path;

class MonthlyFeeTransactionPage extends StatefulWidget {
  const MonthlyFeeTransactionPage({Key? key}) : super(key: key);

  @override
  State<MonthlyFeeTransactionPage> createState() =>
      _MonthlyFeeTransactionPageState();
}

class _MonthlyFeeTransactionPageState
    extends State<MonthlyFeeTransactionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<FeeTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      const myAnantId = '25AA001.student@test.anant';
      final serverList = await client.transaction
          .getAllMonthlyFeeTransactionUser(myAnantId);

      _transactions = serverList.map((mft) {
        return FeeTransaction(
          month: mft.month,
          amount: mft.feeAmount,
          isPaid: mft.transactionStatus.toLowerCase() == 'success',
          paidDate: mft.transactionStatus.toLowerCase() == 'success'
              ? mft.transactionDate
              : null,
          feeAmount: mft.feeAmount,
          discount: mft.discount,
          fine: mft.fine,
          transactionDate: mft.transactionDate,
          transactionGateway: mft.transactionGateway,
          transactionRef: mft.transactionRef,
          transactionId: mft.transactionId,
          transactionStatus: mft.transactionStatus,
          transactionType: mft.transactionType,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<FeeTransaction> get _paid =>
      _transactions.where((t) => t.isPaid).toList();
  List<FeeTransaction> get _due =>
      _transactions.where((t) => !t.isPaid).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text(
          'Fee Transactions',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF335762).withOpacity(0.9),
                const Color(0xFF335762).withOpacity(0.7),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              labelColor: const Color(0xFF335762),
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Paid'),
                Tab(text: 'Due'),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EB)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadTransactions,
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 70),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              _SummaryCard(
                                label: 'Total Paid',
                                amount: _paid.fold(0.0, (sum, t) => sum + t.amount),
                                icon: Icons.check_circle_rounded,
                                color: const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 16),
                              _SummaryCard(
                                label: 'Total Due',
                                amount: _due.fold(0.0, (sum, t) => sum + t.amount),
                                icon: Icons.error_rounded,
                                color: const Color(0xFFEF4444),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildList(_transactions),
                              _buildList(_paid),
                              _buildList(_due),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<FeeTransaction> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No records found',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }
    
    return ResponsiveLayout(
      mobileBody: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) => _buildTransactionCard(list[index]),
      ),
      desktopBody: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.5,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) => _buildTransactionCard(list[index]),
      ),
    );
  }

  Widget _buildTransactionCard(FeeTransaction tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: tx.isPaid ? () => _openDetailForm(tx) : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (tx.isPaid ? Colors.green : Colors.red).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    tx.isPaid ? Icons.check_rounded : Icons.priority_high_rounded,
                    color: tx.isPaid ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.month,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tx.isPaid && tx.paidDate != null
                            ? 'Paid on ${_formatDate(tx.paidDate!)}'
                            : 'Payment Pending',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${tx.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF335762),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!tx.isPaid)
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () => _pay(tx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF335762),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            elevation: 0,
                          ),
                          child: const Text('Pay Now', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDetailForm(FeeTransaction tx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FeeDetailFormPage(transaction: tx)),
    );
  }

  void _pay(FeeTransaction tx) {
    // implement payment integration
  }

  String _formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Your transaction model
class FeeTransaction {
  final String month;
  final double amount;
  final bool isPaid;
  final DateTime? paidDate;
  final double feeAmount;
  final double discount;
  final double fine;
  final DateTime transactionDate;
  final String transactionGateway;
  final String transactionRef;
  final String transactionId;
  final String transactionStatus;
  final String transactionType;

  FeeTransaction({
    required this.month,
    required this.amount,
    required this.isPaid,
    this.paidDate,
    this.feeAmount = 0.0,
    this.discount = 0.0,
    this.fine = 0.0,
    DateTime? transactionDate,
    this.transactionGateway = '',
    this.transactionRef = '',
    this.transactionId = '',
    this.transactionStatus = '',
    this.transactionType = '',
  }) : transactionDate = transactionDate ?? DateTime.now();
}


/// Detail form page remains unchanged
class FeeDetailFormPage extends StatelessWidget {
  final FeeTransaction transaction;

  const FeeDetailFormPage({
    required this.transaction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageFormat = PdfPageFormat.a4.copyWith(
      marginTop: 32,
      marginBottom: 32,
      marginLeft: 32,
      marginRight: 32,
    );
    Future<Uint8List> _makePdf() =>
        _generatePdf(pageFormat, transaction);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Fee Receipt ${transaction.month}'),
      body: PdfPreview(
        allowPrinting: false,
        allowSharing: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        initialPageFormat: pageFormat,
        useActions: true,
        maxPageWidth: 700,
        previewPageMargin: const EdgeInsets.all(12),
        actionBarTheme: PdfActionBarTheme(
          backgroundColor: Color(0xFF3c6673),
          iconColor: Colors.white,
          elevation: 2,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download PDF',
            onPressed: () async {
              final bytes = await _makePdf();
              if (context.mounted) {
                await _savePdfToDisk(
                  context,
                  bytes,
                  'Fee Receipt ${transaction.month} Ananta.pdf',
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share PDF',
            onPressed: () async {
              final bytes = await _makePdf();
              await Printing.sharePdf(
                bytes: bytes,
                filename: 'Fee Receipt ${transaction.month} Ananta.pdf',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print_rounded),
            tooltip: 'Print PDF',
            onPressed: () {
              Printing.layoutPdf(
                onLayout: (_) => _makePdf(),
                name: 'Fee Receipt ${transaction.month} Ananta.pdf',
              );
            },
          ),
        ],
        build: (_) => _makePdf(),
      ),
    );
  }

  Future<PermissionStatus> _checkStoragePermission() async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return PermissionStatus.granted;
      }
    } catch (_) {}
    return await Permission.storage.request();
  }

  Future<void> _savePdfToDisk(
    BuildContext context,
    Uint8List bytes,
    String filename,
  ) async {
    final status = await _checkStoragePermission();
    if (!status.isGranted) {
      if (context.mounted) {
        _showPermissionDialog(context);
      }
      return;
    }

    final Directory savedDir = Platform.isAndroid
        ? Directory('/storage/emulated/0/Download')
        : await getApplicationDocumentsDirectory();
    if (!await savedDir.exists()) {
      await savedDir.create(recursive: true);
    }

    final baseName = path.basenameWithoutExtension(filename);
    final ext = path.extension(filename);
    var newName = filename;
    var suffix = 1;
    while (await File('${savedDir.path}/$newName').exists()) {
      newName = '$baseName($suffix)$ext';
      suffix++;
    }

    final file = File('${savedDir.path}/$newName');
    await file.writeAsBytes(bytes);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to ${file.path}'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showPermissionDialog(BuildContext context) {
    final isIOS = Platform.isIOS;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission needed'),
        content: Text(
          isIOS
              ? 'Photos access needed to save PDF. Open Settings → Photos → Full Access.'
              : 'Storage access needed to save PDF. Open Settings → App Permissions → Allow storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('DISMISS'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(ctx);
            },
            child: const Text('OPEN SETTINGS'),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generatePdf(
    PdfPageFormat format,
    FeeTransaction tx,
  ) async {
    final doc = pw.Document();
    final paidOn = tx.paidDate != null
        ? DateFormat('dd/MM/yyyy').format(tx.paidDate!)
        : '—';

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (_) => [
          pw.Header(
            level: 0,
            child: pw.Text('Fee Receipt', style: pw.TextStyle(fontSize: 24)),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Month: ${tx.month}', style: pw.TextStyle(fontSize: 16)),
          pw.Text(
            'Amount ${tx.isPaid ? 'Paid' : 'Due'}: Rs ${tx.amount.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 16),
          ),
          pw.Text('Paid On: $paidOn', style: pw.TextStyle(fontSize: 16)),
          pw.Divider(height: 24),
          pw.TableHelper.fromTextArray(
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            headers: ['Field', 'Value'],
            data: [
              ['Fee Amount', 'Rs ${tx.feeAmount.toStringAsFixed(2)}'],
              ['Discount', 'Rs ${tx.discount.toStringAsFixed(2)}'],
              ['Fine', 'Rs ${tx.fine.toStringAsFixed(2)}'],
              [
                'Transaction Date & Time',
                DateFormat('dd/MM/yyyy - HH:mm').format(tx.transactionDate)
              ],
              ['Gateway', tx.transactionGateway],
              ['Reference', tx.transactionRef],
              ['Transaction ID', tx.transactionId],
              ['Status', tx.transactionStatus],
              ['Type', tx.transactionType],
            ],
          ),
          pw.Spacer(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Generated on ${DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ),
        ],
      ),
    );

    return doc.save();
  }
}
