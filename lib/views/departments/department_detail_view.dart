import 'package:flutter/material.dart';
import '../../models/department_model.dart';
import '../../services/api_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/stat_badge_widget.dart';

/// Screen displaying complete details for a single Colombian department.
class DepartmentDetailView extends StatefulWidget {
  final int departmentId;
  final DepartmentModel? initialDepartment;
  final ApiService? apiService;

  const DepartmentDetailView({
    super.key,
    required this.departmentId,
    this.initialDepartment,
    this.apiService,
  });

  @override
  State<DepartmentDetailView> createState() => _DepartmentDetailViewState();
}

class _DepartmentDetailViewState extends State<DepartmentDetailView> {
  late final ApiService _apiService;
  DepartmentModel? _department;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _department = widget.initialDepartment;

    if (_department == null) {
      _loadDepartment();
    }
  }

  Future<void> _loadDepartment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dept = await _apiService.getDepartmentById(widget.departmentId);
      setState(() {
        _department = dept;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudo obtener el detalle del departamento.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_department?.name ?? 'Detalle del Departamento'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando información del departamento...');
    }

    if (_errorMessage != null && _department == null) {
      return ErrorViewWidget(
        message: _errorMessage!,
        onRetry: _loadDepartment,
      );
    }

    final dept = _department;
    if (dept == null) {
      return const Center(child: Text('No hay datos disponibles.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderBanner(dept),
          const SizedBox(height: 16),
          _buildMetricsGrid(dept),
          const SizedBox(height: 16),
          _buildDescriptionCard(dept),
          if (dept.cityCapital != null) ...[
            const SizedBox(height: 16),
            _buildCapitalCard(dept.cityCapital!),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner(DepartmentModel dept) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryBlue, Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ID: #${dept.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              if (dept.phonePrefix != null && dept.phonePrefix!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryAmber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Prefijo: +57 (${dept.phonePrefix})',
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            dept.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_city_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                'Capital: ${dept.capitalName}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(DepartmentModel dept) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        StatBadgeWidget(
          icon: Icons.people_outline_rounded,
          label: 'Población',
          value: dept.population != null
              ? '${dept.population} hab.'
              : 'No registrada',
          color: AppTheme.primaryBlue,
        ),
        StatBadgeWidget(
          icon: Icons.square_foot_rounded,
          label: 'Superficie',
          value: dept.surface != null
              ? '${dept.surface} km²'
              : 'No registrada',
          color: AppTheme.emeraldGreen,
        ),
        StatBadgeWidget(
          icon: Icons.apartment_rounded,
          label: 'Municipios',
          value: dept.municipalities != null
              ? '${dept.municipalities} municipios'
              : 'No registrado',
          color: AppTheme.secondaryAmber,
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(DepartmentModel dept) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Descripción General',
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
              dept.description,
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

  Widget _buildCapitalCard(CityCapitalModel capital) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppTheme.secondaryAmber, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Capital: ${capital.name}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            if (capital.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                capital.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                if (capital.population != null)
                  Expanded(
                    child: Text(
                      'Población: ${capital.population} hab.',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                if (capital.postalCode != null)
                  Text(
                    'Cód. Postal: ${capital.postalCode}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
