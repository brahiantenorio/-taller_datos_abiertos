import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/touristic_attraction_model.dart';
import '../../services/api_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/network_image_with_fallback.dart';
import '../../widgets/search_bar_widget.dart';

/// Screen listing Colombian Touristic Attractions with image thumbnails and search.
class AttractionsListView extends StatefulWidget {
  final ApiService? apiService;

  const AttractionsListView({super.key, this.apiService});

  @override
  State<AttractionsListView> createState() => _AttractionsListViewState();
}

class _AttractionsListViewState extends State<AttractionsListView> {
  late final ApiService _apiService;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<TouristicAttractionModel> _attractions = [];
  List<TouristicAttractionModel> _filteredAttractions = [];

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _fetchAttractions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAttractions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _apiService.getTouristicAttractions();
      setState(() {
        _attractions = list;
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
        _errorMessage = 'No se pudieron cargar las atracciones turísticas.';
        _isLoading = false;
      });
    }
  }

  void _filterList(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredAttractions = List.from(_attractions);
      } else {
        _filteredAttractions = _attractions.where((a) {
          final nameMatch = a.name.toLowerCase().contains(q);
          final cityMatch = (a.cityName ?? '').toLowerCase().contains(q);
          final descMatch = a.description.toLowerCase().contains(q);
          return nameMatch || cityMatch || descMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atracciones Turísticas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar',
            onPressed: _fetchAttractions,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando atracciones turísticas...');
    }

    if (_errorMessage != null) {
      return ErrorViewWidget(
        message: _errorMessage!,
        onRetry: _fetchAttractions,
      );
    }

    return Column(
      children: [
        SearchBarWidget(
          controller: _searchController,
          hintText: 'Buscar atracción o municipio...',
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
                'Lugares encontrados: ${_filteredAttractions.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMuted,
                ),
              ),
              const Text(
                'Destinos de Colombia',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredAttractions.isEmpty
              ? const EmptyStateWidget(
                  title: 'No se encontraron atracciones',
                  subtitle: 'Prueba buscando por otra ciudad o nombre.',
                  icon: Icons.landscape_outlined,
                )
              : RefreshIndicator(
                  onRefresh: _fetchAttractions,
                  color: AppTheme.primaryBlue,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24, top: 4),
                    itemCount: _filteredAttractions.length,
                    itemBuilder: (context, index) {
                      final item = _filteredAttractions[index];
                      return _buildAttractionItem(item);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAttractionItem(TouristicAttractionModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: NetworkImageWithFallback(
            imageUrl: item.primaryImage,
            width: 60,
            height: 60,
            fallbackIcon: Icons.landscape_rounded,
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.emeraldGreen),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.cityName != null && item.cityName!.isNotEmpty
                      ? item.cityName!
                      : 'Ubicación en Colombia',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            'attraction-detail',
            pathParameters: {'id': item.id.toString()},
            extra: item,
          );
        },
      ),
    );
  }
}
