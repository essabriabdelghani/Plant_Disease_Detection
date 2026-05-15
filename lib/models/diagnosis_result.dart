import 'dart:typed_data';

class DiagnosisResult {
  final String className;

  final String confidence;

  final String description;

  final List<String> recommendations;

  final DateTime analysisDate;

  final String imagePath;

  final bool isHealthy;

  Uint8List? imageBytes;

  DiagnosisResult({
    required this.className,

    required this.confidence,

    required this.description,

    required this.recommendations,

    required this.analysisDate,

    required this.imagePath,

    required this.isHealthy,

    this.imageBytes,
  });

  factory DiagnosisResult.fromJson(
    Map<String, dynamic> json,

    String imagePath,
  ) {
    final classLabel = json['predicted_class'] as String? ?? 'Unknown';

    final isHealthy =
        json['is_healthy'] as bool? ??
        classLabel.toLowerCase().contains('healthy');

    return DiagnosisResult(
      className: classLabel,

      confidence: '${(json['confidence'] as num? ?? 0).toStringAsFixed(2)}%',

      description:
          json['description'] as String? ?? _getDescription(classLabel),

      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : _getRecommendations(classLabel),

      analysisDate: DateTime.now(),

      imagePath: imagePath,

      isHealthy: isHealthy,
    );
  }

  /// DESCRIPTIONS LOCALES

  static String _getDescription(String className) {
    final descriptions = {
      'Pep_Bacterial_spot': 'Tache bactérienne du poivron',

      'Pep_healthy': 'Poivron sain',

      'Pot_Early_blight': 'Mildiou précoce pomme de terre',

      'Pot_Late_blight': 'Mildiou tardif pomme de terre',

      'Pot_healthy': 'Pomme de terre saine',

      'Tom_Bacterial_spot': 'Tache bactérienne tomate',

      'Tom_Early_blight': 'Mildiou précoce tomate',

      'Tom_Late_blight': 'Mildiou tardif tomate',

      'Tom_Leaf_Mold': 'Moisissure foliaire tomate',

      'Tom_Septoria_leaf_spot': 'Tache septorienne tomate',

      'Tom_Spider_mites_Two_spotted_spider_mite': 'Acariens rouges tomate',

      'Tom_Target_spot': 'Tache cible tomate',

      'Tom_Mosaic_virus': 'Virus mosaïque tomate',

      'Tom_Yellow_leaf_curl_virus': 'Virus enroulement jaune tomate',

      'Tom_healthy': 'Tomate saine',
    };

    return descriptions[className] ?? 'Maladie non identifiée';
  }

  /// RECOMMANDATIONS LOCALES

  static List<String> _getRecommendations(String className) {
    final recommendations = {
      'Pep_Bacterial_spot': [
        'Éliminer feuilles infectées',

        'Appliquer fongicide cuivré',

        'Améliorer circulation air',

        'Éviter irrigation excessive',
      ],

      'Pep_healthy': [
        'Continuer entretien régulier',

        'Surveiller parasites',

        'Bonne luminosité',
      ],

      'Pot_Early_blight': [
        'Retirer feuilles infectées',

        'Appliquer fongicide',

        'Réduire humidité',
      ],

      'Pot_Late_blight': [
        'Isoler plants infectés',

        'Traiter immédiatement',

        'Augmenter ventilation',
      ],

      'Pot_healthy': ['Maintenir arrosage équilibré', 'Contrôler parasites'],
    };

    return recommendations[className] ??
        [
          'Consulter expert agricole',

          'Prendre mesures préventives',

          'Suivre évolution plante',
        ];
  }

  /// JSON SAVE

  Map<String, dynamic> toJson() => {
    'className': className,

    'confidence': confidence,

    'description': description,

    'recommendations': recommendations,

    'analysisDate': analysisDate.toIso8601String(),

    'imagePath': imagePath,

    'isHealthy': isHealthy,
  };
}
