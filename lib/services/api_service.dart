import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models/diagnosis_result.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  late String baseUrl;

  ApiService._internal() {
    baseUrl = 'http://localhost:8000';
  }

  factory ApiService() {
    return _instance;
  }

  /// Analyse image via FastAPI

  Future<DiagnosisResult> analyzePlantImage(
    Uint8List imageBytes,

    String filename,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/predict');

      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: filename),
      );

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        return DiagnosisResult.fromJson(jsonResponse, filename);
      } else {
        throw Exception('Erreur analyse : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur connexion : $e');
    }
  }

  /// Vérifie disponibilité API

  Future<Map<String, dynamic>> getHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));

      if (response.statusCode == 200) {
        return {'status': 'ok'};
      } else {
        throw Exception('Service indisponible');
      }
    } catch (e) {
      throw Exception('Erreur connexion : $e');
    }
  }
}
