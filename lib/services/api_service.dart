import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../config/constants.dart';
import '../models/department_model.dart';
import '../models/president_model.dart';
import '../models/touristic_attraction_model.dart';
import '../models/typical_dish_model.dart';

/// Custom exception representing an HTTP or API error.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// Service handling all HTTP requests to API Colombia with error handling and status code validation.
class ApiService {
  final http.Client _client;
  final Duration timeoutDuration;

  ApiService({
    http.Client? client,
    this.timeoutDuration = const Duration(seconds: 15),
  }) : _client = client ?? http.Client();

  String get _baseUrl => AppConfig.apiBaseUrl;

  /// Helper to perform GET request with timeout and error handling.
  Future<dynamic> _get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(timeoutDuration);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        'No hay conexión a Internet. Verifica tu red e intenta de nuevo.',
      );
    } on TimeoutException {
      throw ApiException(
        'El tiempo de espera con el servidor ha expirado.',
      );
    } on FormatException {
      throw ApiException(
        'Error al procesar la respuesta del servidor.',
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Ocurrió un error inesperado: ${e.toString()}');
    }
  }

  /// Validates HTTP status code and parses JSON body.
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        return decoded;
      case 400:
        throw ApiException('Petición incorrecta (400).', 400);
      case 404:
        throw ApiException('El recurso solicitado no fue encontrado (404).', 404);
      case 500:
        throw ApiException('Error interno del servidor (500). Intenta más tarde.', 500);
      case 503:
        throw ApiException('Servicio temporalmente no disponible (503).', 503);
      default:
        throw ApiException(
          'Error del servidor con código de estado: ${response.statusCode}',
          response.statusCode,
        );
    }
  }

  // ==================== DEPARTMENTS ====================

  /// Fetches all departments.
  Future<List<DepartmentModel>> getDepartments() async {
    final data = await _get(ApiEndpoints.departments);
    if (data is List) {
      return data
          .map((item) => DepartmentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Fetches a single department by id.
  Future<DepartmentModel> getDepartmentById(int id) async {
    final data = await _get(ApiEndpoints.departmentDetail(id));
    if (data is Map<String, dynamic>) {
      return DepartmentModel.fromJson(data);
    }
    throw ApiException('No se encontró el departamento con ID $id', 404);
  }

  // ==================== PRESIDENTS ====================

  /// Fetches all presidents.
  Future<List<PresidentModel>> getPresidents() async {
    final data = await _get(ApiEndpoints.presidents);
    if (data is List) {
      return data
          .map((item) => PresidentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Fetches a single president by id.
  Future<PresidentModel> getPresidentById(int id) async {
    final data = await _get(ApiEndpoints.presidentDetail(id));
    if (data is Map<String, dynamic>) {
      return PresidentModel.fromJson(data);
    }
    throw ApiException('No se encontró el presidente con ID $id', 404);
  }

  // ==================== TOURISTIC ATTRACTIONS ====================

  /// Fetches all touristic attractions.
  Future<List<TouristicAttractionModel>> getTouristicAttractions() async {
    final data = await _get(ApiEndpoints.attractions);
    if (data is List) {
      return data
          .map((item) => TouristicAttractionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Fetches a single touristic attraction by id.
  Future<TouristicAttractionModel> getTouristicAttractionById(int id) async {
    final data = await _get(ApiEndpoints.attractionDetail(id));
    if (data is Map<String, dynamic>) {
      return TouristicAttractionModel.fromJson(data);
    }
    throw ApiException('No se encontró la atracción con ID $id', 404);
  }

  // ==================== TYPICAL DISHES ====================

  /// Fetches all typical dishes.
  Future<List<TypicalDishModel>> getTypicalDishes() async {
    final data = await _get(ApiEndpoints.dishes);
    if (data is List) {
      return data
          .map((item) => TypicalDishModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Fetches a single typical dish by id.
  Future<TypicalDishModel> getTypicalDishById(int id) async {
    final data = await _get(ApiEndpoints.dishDetail(id));
    if (data is Map<String, dynamic>) {
      return TypicalDishModel.fromJson(data);
    }
    throw ApiException('No se encontró el plato típico con ID $id', 404);
  }
}
