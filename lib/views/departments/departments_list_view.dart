import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/department_model.dart';
import '../../services/api_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/search_bar_widget.dart';

/// Screen listing all Colombian departments with search and pull-to-refresh.
class DepartmentsListView extends StatefulWidget {
  final ApiService? apiService;

  const DepartmentsListView({super.key, this.apiService});

  @override
  State<DepartmentsListView> createState() => _DepartmentsListViewState();
}

class _DepartmentsListViewState extends State<DepartmentsListView> {
  late final ApiService _apiService;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<DepartmentModel> _departments = [];
  List<DepartmentModel> _filteredDepartments = [];

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _fetchDepartments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDepartments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _apiService.getDepartments();
      setState(() {
        _departments = list;
        _filterList(_searchController.text);
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudieron cargar los departamentos.';
        _isLoading = false;
      });
    }
  }

  void _filterList(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredDepartments = List.from(_departments);
      } else {
        _filteredDepartments = _departments.where((d) {
          final nameMatch = d.name.toLowerCase().contains(q);
          final capitalMatch = d.capitalName.toLowerCase().contains(q);
          final descMatch = d.description.toLowerCase().contains(q);
          return nameMatch || capitalMatch || descMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar',
            onPressed: _fetchDepartments,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando departamentos...');
    }

    if (_errorMessage != null) {
      return ErrorViewWidget(
        message: _errorMessage!,
        onRetry: _fetchDepartments,
      );
    }

    return Column(
      children: [
        SearchBarWidget(
          controller: _searchController,
          hintText: 'Buscar departamento o capital...',
          onChanged: _filterList,
          onClear: () {
            _searchController.clear();
            _filterList('');
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resultados: ${_filteredDepartments.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMuted,
                ),
              ),
              const Text(
                'API Colombia',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredDepartments.isEmpty
              ? const EmptyStateWidget(
                  title: 'No se encontraron departamentos',
                  subtitle: 'Intenta con otro término de búsqueda.',
                  icon: Icons.map_outlined,
                )
              : RefreshIndicator(
                  onRefresh: _fetchDepartments,
                  color: AppTheme.primaryBlue,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24, top: 4),
                    itemCount: _filteredDepartments.length,
                    itemBuilder: (context, index) {
                      final item = _filteredDepartments[index];
                      return _buildDepartmentItem(item);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDepartmentItem(DepartmentModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.12),
          foregroundColor: AppTheme.primaryBlue,
          radius: 24,
          child: Text(
            item.name.isNotEmpty ? item.name.substring(0, 1).toUpperCase() : 'D',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Capital: ${item.capitalName}',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.municipalities != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${item.municipalities} mun.',
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppTheme.primaryBlue,
        ),
        onTap: () {
          context.pushNamed(
            'department-detail',
            pathParameters: {'id': item.id.toString()},
            extra: item,
          );
        },
      ),
    );
  }
}
