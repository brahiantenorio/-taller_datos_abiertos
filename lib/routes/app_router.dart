import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/department_model.dart';
import '../models/president_model.dart';
import '../models/touristic_attraction_model.dart';
import '../models/typical_dish_model.dart';
import '../views/attractions/attraction_detail_view.dart';
import '../views/attractions/attractions_list_view.dart';
import '../views/dashboard/dashboard_view.dart';
import '../views/departments/department_detail_view.dart';
import '../views/departments/departments_list_view.dart';
import '../views/dishes/dish_detail_view.dart';
import '../views/dishes/dishes_list_view.dart';
import '../views/presidents/president_detail_view.dart';
import '../views/presidents/presidents_list_view.dart';

/// Centralized declarative routing configuration powered by go_router.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'dashboard',
        path: '/',
        builder: (context, state) => const DashboardView(),
        routes: [
          // ==================== DEPARTMENTS ====================
          GoRoute(
            name: 'departments',
            path: 'departments',
            builder: (context, state) => const DepartmentsListView(),
            routes: [
              GoRoute(
                name: 'department-detail',
                path: ':id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'] ?? '0';
                  final id = int.tryParse(idStr) ?? 0;
                  final extra = state.extra is DepartmentModel
                      ? state.extra as DepartmentModel
                      : null;
                  return DepartmentDetailView(
                    departmentId: id,
                    initialDepartment: extra,
                  );
                },
              ),
            ],
          ),

          // ==================== PRESIDENTS ====================
          GoRoute(
            name: 'presidents',
            path: 'presidents',
            builder: (context, state) => const PresidentsListView(),
            routes: [
              GoRoute(
                name: 'president-detail',
                path: ':id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'] ?? '0';
                  final id = int.tryParse(idStr) ?? 0;
                  final extra = state.extra is PresidentModel
                      ? state.extra as PresidentModel
                      : null;
                  return PresidentDetailView(
                    presidentId: id,
                    initialPresident: extra,
                  );
                },
              ),
            ],
          ),

          // ==================== ATTRACTIONS ====================
          GoRoute(
            name: 'attractions',
            path: 'attractions',
            builder: (context, state) => const AttractionsListView(),
            routes: [
              GoRoute(
                name: 'attraction-detail',
                path: ':id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'] ?? '0';
                  final id = int.tryParse(idStr) ?? 0;
                  final extra = state.extra is TouristicAttractionModel
                      ? state.extra as TouristicAttractionModel
                      : null;
                  return AttractionDetailView(
                    attractionId: id,
                    initialAttraction: extra,
                  );
                },
              ),
            ],
          ),

          // ==================== DISHES ====================
          GoRoute(
            name: 'dishes',
            path: 'dishes',
            builder: (context, state) => const DishesListView(),
            routes: [
              GoRoute(
                name: 'dish-detail',
                path: ':id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'] ?? '0';
                  final id = int.tryParse(idStr) ?? 0;
                  final extra = state.extra is TypicalDishModel
                      ? state.extra as TypicalDishModel
                      : null;
                  return DishDetailView(
                    dishId: id,
                    initialDish: extra,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.broken_image_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Ruta no encontrada: ${state.uri}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.goNamed('dashboard'),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Volver al Inicio'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
