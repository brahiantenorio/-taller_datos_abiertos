import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/typical_dish_model.dart';
import '../../services/api_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/network_image_with_fallback.dart';
import '../../widgets/search_bar_widget.dart';

/// Screen listing Colombian Typical Dishes with photos, ingredients and search.
class DishesListView extends StatefulWidget {
  final ApiService? apiService;

  const DishesListView({super.key, this.apiService});

  @override
  State<DishesListView> createState() => _DishesListViewState();
}

class _DishesListViewState extends State<DishesListView> {
  late final ApiService _apiService;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<TypicalDishModel> _dishes = [];
  List<TypicalDishModel> _filteredDishes = [];

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _fetchDishes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDishes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final list = await _apiService.getTypicalDishes();
      setState(() {
        _dishes = list;
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
        _errorMessage = 'No se pudieron cargar los platos típicos.';
        _isLoading = false;
      });
    }
  }

  void _filterList(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filteredDishes = List.from(_dishes);
      } else {
        _filteredDishes = _dishes.where((d) {
          final nameMatch = d.name.toLowerCase().contains(q);
          final deptMatch = (d.departmentName ?? '').toLowerCase().contains(q);
          final ingMatch = d.ingredients.toLowerCase().contains(q);
          final descMatch = d.description.toLowerCase().contains(q);
          return nameMatch || deptMatch || ingMatch || descMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platos Típicos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Recargar',
            onPressed: _fetchDishes,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando platos típicos...');
    }

    if (_errorMessage != null) {
      return ErrorViewWidget(
        message: _errorMessage!,
        onRetry: _fetchDishes,
      );
    }

    return Column(
      children: [
        SearchBarWidget(
          controller: _searchController,
          hintText: 'Buscar por plato, ingrediente o región...',
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
                'Platos disponibles: ${_filteredDishes.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMuted,
                ),
              ),
              const Text(
                'Gastronomía Colombiana',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredDishes.isEmpty
              ? const EmptyStateWidget(
                  title: 'No se encontraron platos',
                  subtitle: 'Prueba buscando con otro ingrediente.',
                  icon: Icons.restaurant_rounded,
                )
              : RefreshIndicator(
                  onRefresh: _fetchDishes,
                  color: AppTheme.accentCrimson,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24, top: 4),
                    itemCount: _filteredDishes.length,
                    itemBuilder: (context, index) {
                      final item = _filteredDishes[index];
                      return _buildDishItem(item);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDishItem(TypicalDishModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: NetworkImageWithFallback(
            imageUrl: item.imageUrl,
            width: 60,
            height: 60,
            fallbackIcon: Icons.restaurant_menu_rounded,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.departmentName != null && item.departmentName!.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.accentCrimson),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Región: ${item.departmentName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.accentCrimson,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 2),
              Text(
                item.ingredients,
                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
            'dish-detail',
            pathParameters: {'id': item.id.toString()},
            extra: item,
          );
        },
      ),
    );
  }
}
