import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/president_model.dart';
import '../../services/api_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/network_image_with_fallback.dart';
import '../../widgets/search_bar_widget.dart';

/// Screen listing Colombian presidents with search and period filters.
class PresidentsListView extends StatefulWidget {
  final ApiService? apiService;

  const PresidentsListView({super.key, this.apiService});

  @override
  State<PresidentsListView> createState() => _PresidentsListViewState();
}

class _PresidentsListViewState extends State<PresidentsListView> {
  late final ApiService _apiService;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<PresidentModel> _presidents = [];
  List<PresidentModel> _filteredPresidents = [];

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _fetchPresidents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPresidents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _apiService.getPresidents();
      setState(() {
        _presidents = list;
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
        _errorMessage = 'No se pudieron cargar los presidentes.';
        _isLoading = false;
      });
    }
  }

  void _filterList(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredPresidents = List.from(_presidents);
      } else {
        _filteredPresidents = _presidents.where((p) {
          final nameMatch = p.fullName.toLowerCase().contains(q);
          final partyMatch = (p.politicalParty ?? '').toLowerCase().contains(q);
          final descMatch = p.description.toLowerCase().contains(q);
          return nameMatch || partyMatch || descMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presidentes de Colombia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar',
            onPressed: _fetchPresidents,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando presidentes...');
    }

    if (_errorMessage != null) {
      return ErrorViewWidget(
        message: _errorMessage!,
        onRetry: _fetchPresidents,
      );
    }

    return Column(
      children: [
        SearchBarWidget(
          controller: _searchController,
          hintText: 'Buscar por nombre o partido político...',
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
                'Total listados: ${_filteredPresidents.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMuted,
                ),
              ),
              const Text(
                'Datos Históricos',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredPresidents.isEmpty
              ? const EmptyStateWidget(
                  title: 'No se encontraron presidentes',
                  subtitle: 'Verifica los términos ingresados.',
                  icon: Icons.person_search_rounded,
                )
              : RefreshIndicator(
                  onRefresh: _fetchPresidents,
                  color: AppTheme.primaryBlue,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24, top: 4),
                    itemCount: _filteredPresidents.length,
                    itemBuilder: (context, index) {
                      final item = _filteredPresidents[index];
                      return _buildPresidentItem(item);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPresidentItem(PresidentModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: SizedBox(
          width: 52,
          height: 52,
          child: NetworkImageWithFallback(
            imageUrl: item.image,
            borderRadius: BorderRadius.circular(26),
            fallbackIcon: Icons.person_rounded,
          ),
        ),
        title: Text(
          item.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.periodFormatted,
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.politicalParty ?? 'Independiente',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
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
            'president-detail',
            pathParameters: {'id': item.id.toString()},
            extra: item,
          );
        },
      ),
    );
  }
}
