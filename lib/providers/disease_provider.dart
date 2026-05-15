import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/diagnosis_result.dart';
import '../services/api_service.dart';

class DiseaseProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  DiagnosisResult? _currentResult;

  List<DiagnosisResult> _analysisHistory = [];

  bool _isLoading = false;

  String? _errorMessage;

  // Getters

  DiagnosisResult? get currentResult => _currentResult;

  List<DiagnosisResult> get analysisHistory => _analysisHistory;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  DiseaseProvider() {
    _loadHistory();
  }

  /// Analyse image

  Future<void> analyzeImage(Uint8List imageBytes, String filename) async {
    _isLoading = true;

    _errorMessage = null;

    notifyListeners();

    try {
      final result = await _apiService.analyzePlantImage(imageBytes, filename);

      /// IMPORTANT :
      /// sauvegarder image mémoire
      /// pour ResultScreen et HistoryScreen

      result.imageBytes = imageBytes;

      _currentResult = result;

      _analysisHistory.insert(0, result);

      await _saveHistory();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  /// Sauvegarde historique

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final jsonList = _analysisHistory
          .map((result) => jsonEncode(result.toJson()))
          .toList();

      await prefs.setStringList('analysis_history', jsonList);
    } catch (e) {
      print('Erreur sauvegarde : $e');
    }
  }

  /// Charger historique

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final jsonList = prefs.getStringList('analysis_history') ?? [];

      _analysisHistory = jsonList.map((json) {
        final data = jsonDecode(json) as Map<String, dynamic>;

        return DiagnosisResult(
          className: data['className'] ?? '',

          confidence: data['confidence'] ?? '0%',

          description: data['description'] ?? '',

          recommendations: List<String>.from(data['recommendations'] ?? []),

          analysisDate: DateTime.parse(
            data['analysisDate'] ?? DateTime.now().toIso8601String(),
          ),

          imagePath: data['imagePath'] ?? '',

          isHealthy: data['isHealthy'] ?? false,
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Erreur chargement : $e');
    }
  }

  /// Effacer historique

  void clearHistory() async {
    _analysisHistory.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('analysis_history');

    notifyListeners();
  }

  /// Définir résultat actuel

  void setCurrentResult(DiagnosisResult result) {
    _currentResult = result;

    notifyListeners();
  }
}
