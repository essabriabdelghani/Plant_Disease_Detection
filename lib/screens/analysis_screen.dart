import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/disease_provider.dart';
import 'result_screen.dart';

class AnalysisScreen extends StatefulWidget {
  final bool useCamera;

  const AnalysisScreen({Key? key, required this.useCamera}) : super(key: key);

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  XFile? _selectedImage;

  Uint8List? _imageBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _pickImage();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: widget.useCamera ? ImageSource.camera : ImageSource.gallery,

        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        setState(() {
          _selectedImage = pickedFile;

          _imageBytes = bytes;
        });
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null || _imageBytes == null) {
      return;
    }

    final provider = context.read<DiseaseProvider>();

    await provider.analyzeImage(_imageBytes!, _selectedImage!.name);

    if (provider.errorMessage == null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Erreur inconnue'),

          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection d\'image'),

        backgroundColor: const Color(0xFF2E7D32),
      ),

      body: _selectedImage == null
          ? _buildLoadingState()
          : _buildImagePreview(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(
            width: 50,
            height: 50,

            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF2E7D32).withOpacity(0.7),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            widget.useCamera
                ? 'Accès à la caméra...'
                : 'Ouverture de la galerie...',

            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Consumer<DiseaseProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,

                child: _imageBytes != null
                    ? Image.memory(_imageBytes!, fit: BoxFit.contain)
                    : const Center(
                        child: Text(
                          'Aucune image',

                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  if (provider.isLoading)
                    Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,

                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF2E7D32).withOpacity(0.7),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          'Analyse en cours...',

                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await _pickImage();
                            },

                            icon: const Icon(Icons.refresh),

                            label: const Text('Nouvelle image'),

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
                            onPressed: _analyzeImage,

                            icon: const Icon(Icons.check_circle),

                            label: const Text('Analyser'),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),

                              foregroundColor: Colors.white,

                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
