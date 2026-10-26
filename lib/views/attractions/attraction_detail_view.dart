import 'package:flutter/material.dart';
import '../../models/touristic_attraction_model.dart';
import '../../services/api_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/network_image_with_fallback.dart';
import '../../widgets/stat_badge_widget.dart';

/// Screen displaying complete details for a single Touristic Attraction.
class AttractionDetailView extends StatefulWidget {
  final int attractionId;
  final TouristicAttractionModel? initialAttraction;
  final ApiService? apiService;

  const AttractionDetailView({
    super.key,
    required this.attractionId,
    this.initialAttraction,
    this.apiService,
  });

  @override
  State<AttractionDetailView> createState() => _AttractionDetailViewState();
}

class _AttractionDetailViewState extends State<AttractionDetailView> {
  late final ApiService _apiService;
  TouristicAttractionModel? _attraction;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _attraction = widget.initialAttraction;

    if (_attraction == null) {
      _loadAttraction();
    }
  }

  Future<void> _loadAttraction() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final item = await _apiService.getTouristicAttractionById(widget.attractionId);
      setState(() {
        _attraction = item;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudo obtener el detalle de la atracción.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_attraction?.name ?? 'Detalle de Atracción'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando detalle de la atracción...');
    }

    if (_errorMessage != null && _attraction == null) {
      return ErrorViewWidget(
        message: _errorMessage!,
        onRetry: _loadAttraction,
      );
    }

    final attraction = _attraction;
    if (attraction == null) {
      return const Center(child: Text('No hay datos disponibles.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageBanner(attraction),
          const SizedBox(height: 16),
          _buildInfoPills(attraction),
          const SizedBox(height: 16),
          _buildDescriptionCard(attraction),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildImageBanner(TouristicAttractionModel attraction) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 220,
            child: NetworkImageWithFallback(
              imageUrl: attraction.primaryImage,
              fit: BoxFit.cover,
              fallbackIcon: Icons.landscape_rounded,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        attraction.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.emeraldGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Atracción Oficial',
                        style: TextStyle(
                          color: AppTheme.emeraldGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                if (attraction.cityName != null && attraction.cityName!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 16, color: AppTheme.emeraldGreen),
                      const SizedBox(width: 4),
                      Text(
                        'Municipio: ${attraction.cityName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPills(TouristicAttractionModel attraction) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        StatBadgeWidget(
          icon: Icons.tag_rounded,
          label: 'ID de Atracción',
          value: '#${attraction.id}',
          color: AppTheme.primaryBlue,
        ),
        if (attraction.latitude != null && attraction.latitude!.isNotEmpty)
          StatBadgeWidget(
            icon: Icons.explore_rounded,
            label: 'Latitud',
            value: attraction.latitude!,
            color: AppTheme.emeraldGreen,
          ),
        if (attraction.longitude != null && attraction.longitude!.isNotEmpty)
          StatBadgeWidget(
            icon: Icons.explore_rounded,
            label: 'Longitud',
            value: attraction.longitude!,
            color: AppTheme.secondaryAmber,
          ),
      ],
    );
  }

  Widget _buildDescriptionCard(TouristicAttractionModel attraction) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.description_rounded, color: AppTheme.primaryBlue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Descripción del Lugar',
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
              attraction.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textDark,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
