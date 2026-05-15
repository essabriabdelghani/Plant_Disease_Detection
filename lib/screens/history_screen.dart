import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/disease_provider.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiseaseProvider>(
      builder: (context, provider, _) {
        if (provider.analysisHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(Icons.history, size: 80, color: Colors.grey[300]),

                const SizedBox(height: 20),

                Text(
                  'Aucune analyse effectuée',

                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Commencez par analyser une image de plante',

                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            if (provider.analysisHistory.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),

                child: SizedBox(
                  width: double.infinity,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,

                        builder: (context) => AlertDialog(
                          title: const Text('Effacer l\'historique'),

                          content: const Text(
                            'Êtes-vous sûr de vouloir supprimer tout l\'historique ?',
                          ),

                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),

                              child: const Text('Annuler'),
                            ),

                            TextButton(
                              onPressed: () {
                                provider.clearHistory();

                                Navigator.pop(context);
                              },

                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),

                              child: const Text('Effacer'),
                            ),
                          ],
                        ),
                      );
                    },

                    icon: const Icon(Icons.delete_outline),

                    label: const Text('Effacer l\'historique'),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                itemCount: provider.analysisHistory.length,

                itemBuilder: (context, index) {
                  final result = provider.analysisHistory[index];

                  return _HistoryCard(
                    result: result,

                    onTap: () {
                      provider.setCurrentResult(result);

                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (_) => const ResultScreen()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final dynamic result;

  final VoidCallback onTap;

  const _HistoryCard({Key? key, required this.result, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: Colors.grey[200]!),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),

              blurRadius: 4,

              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          children: [
            /// IMAGE PLACEHOLDER
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),

                bottomLeft: Radius.circular(12),
              ),

              child: Container(
                width: 100,
                height: 100,

                color: Colors.grey[200],

                child: Center(
                  child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
                ),
              ),
            ),

            /// CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            result.className,

                            style: const TextStyle(
                              fontSize: 15,

                              fontWeight: FontWeight.w600,
                            ),

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,

                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: result.isHealthy
                                ? const Color(0xFFC8E6C9)
                                : const Color(0xFFFFCDD2),

                            borderRadius: BorderRadius.circular(6),
                          ),

                          child: Text(
                            result.isHealthy ? '✓ Sain' : '⚠ Malade',

                            style: TextStyle(
                              fontSize: 11,

                              fontWeight: FontWeight.w600,

                              color: result.isHealthy
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFC62828),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Confiance: ${result.confidence}',

                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(result.analysisDate),

                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 12),

              child: Icon(
                Icons.arrow_forward_ios,

                size: 14,

                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
