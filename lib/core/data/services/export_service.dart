import 'dart:io';
import 'package:flutter_steps_tracker/core/data/services/database_service.dart';
import 'package:flutter_steps_tracker/core/data/services/stats_tracker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  final DatabaseService _databaseService = DatabaseService();
  final StatsTracker _statsTracker = StatsTracker();

  // Export to CSV
  Future<File> exportToCSV({DateTime? startDate, DateTime? endDate}) async {
    final now = DateTime.now();
    final start = startDate ?? now.subtract(const Duration(days: 30));
    final end = endDate ?? now;

    // Get data from database
    final stats = await _databaseService.getStatsInRange(
      DateFormat('yyyy-MM-dd').format(start),
      DateFormat('yyyy-MM-dd').format(end),
    );

    // Create CSV content
    final StringBuffer csvBuffer = StringBuffer();
    csvBuffer.writeln(
        'Date,Steps,Distance (km),Calories,Average Speed (km/h),Active Minutes');

    for (var stat in stats) {
      final date = DateFormat('dd/MM/yyyy').format(DateTime.parse(stat.date));
      csvBuffer.writeln(
          '$date,${stat.steps},${stat.distance.toStringAsFixed(2)},${stat.calories},${stat.avgSpeed.toStringAsFixed(1)},${stat.activeMinutes}');
    }

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'steps_tracker_export_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(csvBuffer.toString());

    return file;
  }

  // Export to PDF
  Future<File> exportToPDF({DateTime? startDate, DateTime? endDate}) async {
    final now = DateTime.now();
    final start = startDate ?? now.subtract(const Duration(days: 30));
    final end = endDate ?? now;

    // Get data from database
    final stats = await _databaseService.getStatsInRange(
      DateFormat('yyyy-MM-dd').format(start),
      DateFormat('yyyy-MM-dd').format(end),
    );
    final lifetimeStats = await _statsTracker.getLifetimeStats();
    final records = await _statsTracker.getRecords();

    // Create PDF
    final pdf = pw.Document();

    // Add page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Title
          pw.Header(
            level: 0,
            child: pw.Text(
              'Steps Tracker - Rapport d\'Activité',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Période: ${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}',
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 20),

          // Lifetime Summary
          pw.Header(level: 1, text: 'Résumé Total'),
          pw.SizedBox(height: 10),
          _buildSummaryTable(lifetimeStats),
          pw.SizedBox(height: 20),

          // Records
          pw.Header(level: 1, text: 'Records Personnels'),
          pw.SizedBox(height: 10),
          _buildRecordsTable(records),
          pw.SizedBox(height: 20),

          // Detailed Data
          pw.Header(level: 1, text: 'Données Détaillées'),
          pw.SizedBox(height: 10),
          _buildDataTable(stats),
        ],
      ),
    );

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'steps_tracker_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Widget _buildSummaryTable(Map<String, dynamic> lifetimeStats) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        _buildTableRow(
            'Total Pas', '${lifetimeStats['totalSteps'] ?? 0}', true),
        _buildTableRow(
            'Distance Totale',
            '${(lifetimeStats['totalDistance'] ?? 0.0).toStringAsFixed(2)} km',
            false),
        _buildTableRow(
            'Calories Totales', '${lifetimeStats['totalCalories'] ?? 0}', true),
        _buildTableRow(
            'Jours Actifs', '${lifetimeStats['activeDays'] ?? 0}', false),
        _buildTableRow('Moyenne Quotidienne',
            '${lifetimeStats['avgSteps'] ?? 0} pas', true),
      ],
    );
  }

  pw.Widget _buildRecordsTable(Map<String, dynamic> records) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      children: [
        _buildTableRow('Record de Pas', '${records['stepsRecord'] ?? 0}', true),
        _buildTableRow('Record de Distance',
            '${(records['distanceRecord'] ?? 0) / 1000} km', false),
        _buildTableRow(
            'Record de Calories', '${records['caloriesRecord'] ?? 0}', true),
        _buildTableRow(
            'Série Actuelle', '${records['currentStreak'] ?? 0} jours', false),
      ],
    );
  }

  pw.Widget _buildDataTable(List<DailyStats> stats) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(1.5),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('Date', true),
            _buildTableCell('Pas', true),
            _buildTableCell('Distance', true),
            _buildTableCell('Calories', true),
            _buildTableCell('Minutes', true),
          ],
        ),
        // Data rows
        ...stats.map((stat) => pw.TableRow(
              children: [
                _buildTableCell(
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(stat.date)),
                    false),
                _buildTableCell('${stat.steps}', false),
                _buildTableCell(
                    '${stat.distance.toStringAsFixed(2)} km', false),
                _buildTableCell('${stat.calories}', false),
                _buildTableCell('${stat.activeMinutes}', false),
              ],
            )),
      ],
    );
  }

  pw.TableRow _buildTableRow(String label, String value, bool isGrey) {
    return pw.TableRow(
      decoration:
          isGrey ? const pw.BoxDecoration(color: PdfColors.grey100) : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value),
        ),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, bool isHeader) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 10 : 9,
        ),
      ),
    );
  }

  // Share file
  Future<void> shareFile(File file, String mimeType) async {
    final xFile = XFile(file.path);
    await Share.shareXFiles(
      [xFile],
      subject: 'Steps Tracker - Export des données',
      text: 'Voici mon rapport d\'activité Steps Tracker',
    );
  }

  // Export and share CSV
  Future<void> exportAndShareCSV(
      {DateTime? startDate, DateTime? endDate}) async {
    final file = await exportToCSV(startDate: startDate, endDate: endDate);
    await shareFile(file, 'text/csv');
  }

  // Export and share PDF
  Future<void> exportAndSharePDF(
      {DateTime? startDate, DateTime? endDate}) async {
    final file = await exportToPDF(startDate: startDate, endDate: endDate);
    await shareFile(file, 'application/pdf');
  }

  // Get export file info
  Future<Map<String, dynamic>> getExportInfo() async {
    final directory = await getApplicationDocumentsDirectory();
    final allFiles = directory.listSync();

    final csvFiles = allFiles
        .where((file) =>
            file.path.endsWith('.csv') &&
            file.path.contains('steps_tracker_export'))
        .length;

    final pdfFiles = allFiles
        .where((file) =>
            file.path.endsWith('.pdf') &&
            file.path.contains('steps_tracker_report'))
        .length;

    return {
      'csvExports': csvFiles,
      'pdfExports': pdfFiles,
      'totalExports': csvFiles + pdfFiles,
    };
  }

  // Clean old export files (older than 30 days)
  Future<void> cleanOldExports({int daysToKeep = 30}) async {
    final directory = await getApplicationDocumentsDirectory();
    final allFiles = directory.listSync();
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

    for (var file in allFiles) {
      if (file is File) {
        final fileName = file.path.split('/').last;
        if ((fileName.contains('steps_tracker_export') ||
                fileName.contains('steps_tracker_report')) &&
            (fileName.endsWith('.csv') || fileName.endsWith('.pdf'))) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await file.delete();
          }
        }
      }
    }
  }
}
