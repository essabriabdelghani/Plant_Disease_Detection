import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/disease_provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);

        return false;
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text('Résultats d\'analyse'),

          backgroundColor: const Color(0xFF2E7D32),

          leading: IconButton(
            icon: const Icon(Icons.home),

            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),

        body: Consumer<DiseaseProvider>(
          builder: (context, provider, _) {
            final result = provider.currentResult;

            if (result == null) {
              return const Center(child: Text('Aucun résultat disponible'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  /// IMAGE PLACEHOLDER
                  Container(
                    width: double.infinity,

                    height: 250,

                    color: Colors.black,

                    child: result.imageBytes != null
                        ? Image.memory(result.imageBytes!, fit: BoxFit.cover)
                        : Center(
                            child: Icon(
                              Icons.image,

                              size: 100,

                              color: Colors.grey[400],
                            ),
                          ),
                  ),

                  /// STATUS CARD
                  Padding(
                    padding: const EdgeInsets.all(20),

                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: result.isHealthy
                            ? const Color(0xFFC8E6C9)
                            : const Color(0xFFFFCDD2),

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(
                          color: result.isHealthy
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF44336),

                          width: 2,
                        ),
                      ),

                      child: Column(
                        children: [
                          Icon(
                            result.isHealthy
                                ? Icons.check_circle
                                : Icons.warning_amber,

                            size: 40,

                            color: result.isHealthy
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFC62828),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            result.className,

                            style: TextStyle(
                              fontSize: 22,

                              fontWeight: FontWeight.bold,

                              color: result.isHealthy
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFC62828),
                            ),

                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Confiance: ${result.confidence}',

                            style: const TextStyle(
                              fontSize: 14,

                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// DESCRIPTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.grey[100],

                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Description',

                            style: TextStyle(
                              fontSize: 16,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            result.description,

                            style: TextStyle(
                              fontSize: 14,

                              color: Colors.grey[700],

                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// RECOMMENDATIONS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Recommandations',

                          style: TextStyle(
                            fontSize: 16,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        ...result.recommendations.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),

                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Container(
                                  width: 30,
                                  height: 30,

                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2E7D32),

                                    shape: BoxShape.circle,
                                  ),

                                  child: Center(
                                    child: Text(
                                      '${entry.key + 1}',

                                      style: const TextStyle(
                                        color: Colors.white,

                                        fontWeight: FontWeight.bold,

                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),

                                    child: Text(
                                      entry.value,

                                      style: const TextStyle(
                                        fontSize: 14,

                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// META
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: Colors.grey[50],

                        borderRadius: BorderRadius.circular(10),

                        border: Border.all(color: Colors.grey[300]!),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          _MetaItem(
                            label: 'Date d\'analyse',

                            value: DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(result.analysisDate),
                          ),

                          const Divider(),

                          _MetaItem(
                            label: 'Confiance du modèle',

                            value: result.confidence,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// BUTTONS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.popUntil(
                                context,

                                (route) => route.isFirst,
                              );
                            },

                            icon: const Icon(Icons.home),

                            label: const Text('Retour'),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],

                              foregroundColor: Colors.white,

                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Résultats partagés!'),

                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },

                            icon: const Icon(Icons.share),

                            label: const Text('Partager'),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),

                              foregroundColor: Colors.white,

                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;

  final String value;

  const _MetaItem({Key? key, required this.label, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),

          Text(
            value,

            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
