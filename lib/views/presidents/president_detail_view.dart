import 'package:flutter/material.dart';
import '../../models/president_model.dart';
import '../../services/api_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/network_image_with_fallback.dart';
import '../../widgets/stat_badge_widget.dart';

/// Screen displaying complete biographic and historical details for a single President.
class PresidentDetailView extends StatefulWidget {
  final int presidentId;
  final PresidentModel? initialPresident;
  final ApiService? apiService;

  const PresidentDetailView({
    super.key,
    required this.presidentId,
    this.initialPresident,
    this.apiService,
  });

  @override
  State<PresidentDetailView> createState() => _PresidentDetailViewState();
}

class _PresidentDetailViewState extends State<PresidentDetailView> {
  late final ApiService _apiService;
  PresidentModel? _president;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _president = widget.initialPresident;

    if (_president == null) {
      _loadPresident();
    }
  }

  Future<void> _loadPresident() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final p = await _apiService.getPresidentById(widget.presidentId);
      setState(() {
        _president = p;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudo obtener la información del presidente.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_president?.fullName ?? 'Detalle del Presidente'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando información del presidente...');
    }

    if (_errorMessage != null && _president == null) {
      return ErrorViewWidget(
        message: _errorMessage!,
        onRetry: _loadPresident,
      );
    }

    final president = _president;
    if (president == null) {
      return const Center(child: Text('No hay datos disponibles.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPortraitCard(president),
          const SizedBox(height: 16),
          _buildPeriodAndPartyCard(president),
          const SizedBox(height: 16),
          _buildBiographyCard(president),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPortraitCard(PresidentModel president) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.secondaryAmber, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: NetworkImageWithFallback(
                  imageUrl: president.image,
                  width: 140,
                  height: 140,
                  fallbackIcon: Icons.person_rounded,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              president.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.secondaryAmber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                president.politicalParty ?? 'Independiente',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodAndPartyCard(PresidentModel president) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        StatBadgeWidget(
          icon: Icons.calendar_today_rounded,
          label: 'Período Presidencial',
          value: president.periodFormatted,
          color: AppTheme.primaryBlue,
        ),
        StatBadgeWidget(
          icon: Icons.tag_rounded,
          label: 'Identificador Único',
          value: '#${president.id}',
          color: AppTheme.secondaryAmber,
        ),
        if (president.startPeriodDate != null)
          StatBadgeWidget(
            icon: Icons.login_rounded,
            label: 'Posesión',
            value: president.startPeriodDate!,
            color: AppTheme.emeraldGreen,
          ),
        if (president.endPeriodDate != null)
          StatBadgeWidget(
            icon: Icons.logout_rounded,
            label: 'Finalización',
            value: president.endPeriodDate!,
            color: AppTheme.accentCrimson,
          ),
      ],
    );
  }

  Widget _buildBiographyCard(PresidentModel president) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history_edu_rounded, color: AppTheme.primaryBlue, size: 22),
                SizedBox(width: 8),
                Text(
                  'Biografía y Trayectoria',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              president.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textDark,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
