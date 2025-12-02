import 'package:flutter/material.dart';
import 'package:flutter_steps_tracker/core/data/services/export_service.dart';
import 'package:flutter_steps_tracker/utilities/constants/app_colors.dart';
import 'package:intl/intl.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({Key? key}) : super(key: key);

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  final ExportService _exportService = ExportService();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isExporting = false;
  Map<String, dynamic> _exportInfo = {};

  @override
  void initState() {
    super.initState();
    _loadExportInfo();
    // Default: last 30 days
    _endDate = DateTime.now();
    _startDate = _endDate!.subtract(const Duration(days: 30));
  }

  Future<void> _loadExportInfo() async {
    final info = await _exportService.getExportInfo();
    setState(() => _exportInfo = info);
  }

  Future<void> _selectDateRange() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
        end: _endDate ?? DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: isDark
              ? ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: AppColors.kPrimaryColor,
                    onPrimary: Colors.white,
                    surface: AppColors.kDarkCardColor,
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.kPrimaryColor,
                    onPrimary: Colors.white,
                    surface: AppColors.kWhiteColor,
                    onSurface: Colors.black87,
                  ),
                ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _exportCSV() async {
    setState(() => _isExporting = true);
    try {
      await _exportService.exportAndShareCSV(
        startDate: _startDate,
        endDate: _endDate,
      );
      _showSnackBar('✓ Export CSV réussi', Colors.green);
      _loadExportInfo();
    } catch (e) {
      _showSnackBar('✗ Erreur lors de l\'export: $e', Colors.red);
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportPDF() async {
    setState(() => _isExporting = true);
    try {
      await _exportService.exportAndSharePDF(
        startDate: _startDate,
        endDate: _endDate,
      );
      _showSnackBar('✓ Export PDF réussi', Colors.green);
      _loadExportInfo();
    } catch (e) {
      _showSnackBar('✗ Erreur lors de l\'export: $e', Colors.red);
    } finally {
      setState(() => _isExporting = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Non défini';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.kDarkBackgroundColor : AppColors.kWhiteColor,
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // AppBar
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppColors.kPrimaryColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    'Exporter les Données',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Contenu
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Info section
                        _buildInfoSection(isDark),
                        const SizedBox(height: 16),

                        // Date range selection
                        _buildDateRangeSection(isDark),
                        const SizedBox(height: 16),

                        // Export options
                        _buildExportOptionsSection(isDark),
                        const SizedBox(height: 16),

                        // Export history
                        _buildExportHistorySection(isDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isExporting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.kPrimaryColor),
                    const SizedBox(height: 16),
                    const Text(
                      'Export en cours...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline,
                    color: AppColors.kPrimaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'À propos de l\'export',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Exportez vos données d\'activité dans différents formats pour les sauvegarder, les partager ou les analyser.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard('CSV', 'Données brutes', Icons.table_chart,
                    Colors.green, isDark),
                _buildInfoCard('PDF', 'Rapport complet', Icons.picture_as_pdf,
                    Colors.red, isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String subtitle, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection(bool isDark) {
    final daysCount = _endDate!.difference(_startDate!).inDays + 1;

    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.date_range,
                    color: AppColors.kPrimaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Période à Exporter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.kBlackMedium : AppColors.kWhiteOff,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Début',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(_startDate),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: AppColors.kPrimaryColor),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Fin',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(_endDate),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$daysCount jour${daysCount > 1 ? 's' : ''} de données',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectDateRange,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.kPrimaryColor.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_calendar, color: AppColors.kPrimaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Modifier la période',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOptionsSection(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.file_download,
                    color: AppColors.kPrimaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Options d\'Export',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildExportButton(
              'Exporter en CSV',
              'Format tableau pour Excel, Google Sheets...',
              Icons.table_chart,
              Colors.green,
              isDark,
              _exportCSV,
            ),
            const SizedBox(height: 12),
            _buildExportButton(
              'Exporter en PDF',
              'Rapport complet avec graphiques et statistiques',
              Icons.picture_as_pdf,
              Colors.red,
              isDark,
              _exportPDF,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: _isExporting ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportHistorySection(bool isDark) {
    return Card(
      color: isDark ? AppColors.kDarkCardColor : AppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: AppColors.kPrimaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Historique d\'Exports',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('CSV', '${_exportInfo['csvExports'] ?? 0}',
                    Icons.table_chart, Colors.green, isDark),
                _buildStatCard('PDF', '${_exportInfo['pdfExports'] ?? 0}',
                    Icons.picture_as_pdf, Colors.red, isDark),
                _buildStatCard('Total', '${_exportInfo['totalExports'] ?? 0}',
                    Icons.folder, AppColors.kPrimaryColor, isDark),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await _exportService.cleanOldExports();
                _showSnackBar('✓ Anciens exports nettoyés', Colors.green);
                _loadExportInfo();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.kPrimaryColor.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_sweep, color: AppColors.kPrimaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Nettoyer les anciens exports',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      ],
    );
  }
}
