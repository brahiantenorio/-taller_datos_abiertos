import 'package:flutter/material.dart';
import '../../models/typical_dish_model.dart';
import '../../services/api_service.dart';
import '../../themes/app_theme.dart';
import '../../widgets/error_view_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/network_image_with_fallback.dart';
import '../../widgets/stat_badge_widget.dart';

/// Screen displaying complete culinary and cultural details for a single Typical Dish.
class DishDetailView extends StatefulWidget {
  final int dishId;
  final TypicalDishModel? initialDish;
  final ApiService? apiService;

  const DishDetailView({
    super.key,
    required this.dishId,
    this.initialDish,
    this.apiService,
  });

  @override
  State<DishDetailView> createState() => _DishDetailViewState();
}

class _DishDetailViewState extends State<DishDetailView> {
  late final ApiService _apiService;
  TypicalDishModel? _dish;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _dish = widget.initialDish;

    if (_dish == null) {
      _loadDish();
    }
  }

  Future<void> _loadDish() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final item = await _apiService.getTypicalDishById(widget.dishId);
      setState(() {
        _dish = item;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudo obtener el detalle del plato.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dish?.name ?? 'Detalle del Plato'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Cargando información del plato...');
    }

    if (_errorMessage != null && _dish == null) {
      return ErrorViewWidget(
        message: _errorMessage!,
        onRetry: _loadDish,
      );
    }

    final dish = _dish;
    if (dish == null) {
      return const Center(child: Text('No hay datos disponibles.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroImageCard(dish),
          const SizedBox(height: 16),
          _buildMetadataBadges(dish),
          const SizedBox(height: 16),
          _buildIngredientsCard(dish),
          const SizedBox(height: 16),
          _buildDescriptionCard(dish),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeroImageCard(TypicalDishModel dish) {
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
              imageUrl: dish.imageUrl,
              fit: BoxFit.cover,
              fallbackIcon: Icons.restaurant_menu_rounded,
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
                        dish.name,
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
                        color: AppTheme.accentCrimson.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Plato Típico',
                        style: TextStyle(
                          color: AppTheme.accentCrimson,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                if (dish.departmentName != null && dish.departmentName!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 16, color: AppTheme.accentCrimson),
                      const SizedBox(width: 4),
                      Text(
                        'Origen: Departamento de ${dish.departmentName}',
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

  Widget _buildMetadataBadges(TypicalDishModel dish) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        StatBadgeWidget(
          icon: Icons.tag_rounded,
          label: 'Identificador',
          value: '#${dish.id}',
          color: AppTheme.primaryBlue,
        ),
        if (dish.departmentName != null)
          StatBadgeWidget(
            icon: Icons.map_rounded,
            label: 'Departamento',
            value: dish.departmentName!,
            color: AppTheme.accentCrimson,
          ),
      ],
    );
  }

  Widget _buildIngredientsCard(TypicalDishModel dish) {
    final ingredients = dish.ingredientsList;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.kitchen_rounded, color: AppTheme.secondaryAmber, size: 22),
                SizedBox(width: 8),
                Text(
                  'Ingredientes Principales',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (ingredients.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ingredients.map((ing) {
                  return Chip(
                    label: Text(ing),
                    backgroundColor: const Color(0xFFF8FAFC),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  );
                }).toList(),
              )
            else
              Text(
                dish.ingredients,
                style: const TextStyle(fontSize: 14, color: AppTheme.textDark),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(TypicalDishModel dish) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.menu_book_rounded, color: AppTheme.primaryBlue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Tradición e Historia',
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
              dish.description,
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
