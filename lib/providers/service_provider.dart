import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/service.dart';

class ServiceProvider with ChangeNotifier {
  List<Service> _services = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Service> get services => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final String baseUrl = "http://localhost:3005"; 

  // Fetch all services from API
  Future<void> fetchServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse("$baseUrl/api/services");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _services = data.map((s) => Service.fromJson(s)).toList();
      } else {
        _errorMessage = "Failed to load services.";
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createService({
    required String name,
    required String description,
    required double price,
    required int companyId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse("$baseUrl/services");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": name,
          "description": description,
          "price": price,
          "companyId": companyId,
        }),
      );

      if (response.statusCode == 201) {
        final newService = Service.fromJson(json.decode(response.body));
        _services.add(newService);
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _errorMessage = errorData["message"] ?? "Failed to create service.";
        return false;
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Service? getServiceById(int id) {
    try {
      return _services.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}
