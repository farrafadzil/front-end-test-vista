import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/company.dart';

class CompanyProvider with ChangeNotifier {
  List<Company> companies = [];
  bool isLoading = false;
  String? errorMessage;
  final String baseUrl = "http://localhost:3005";

  Future<void> fetchCompanies() async {
    isLoading = true;
    notifyListeners();
    try {
      final res = await http.get(Uri.parse('$baseUrl/companies'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        companies = data.map((c) => Company.fromJson(c)).toList();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<bool> createCompany(String name, String registrationNumber) async {
  try {
    final res = await http.post(
      Uri.parse('$baseUrl/companies'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'registrationNumber': registrationNumber,
      }),
    );

    print('Status code: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 201) {
      await fetchCompanies();
      return true;
    }
    return false;
  } catch (e) {
    print('Error: $e');
    return false;
  }
}
}
