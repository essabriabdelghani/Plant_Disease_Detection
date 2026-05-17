# 🌱 Plant Disease Detection

Une application intelligente de détection des maladies des plantes utilisant l'intelligence artificielle et l'apprentissage automatique pour identifier et classifier les maladies végétales en temps réel.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Python](https://img.shields.io/badge/Python-3.8+-green.svg)](https://www.python.org/)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.10+-orange.svg)](https://www.tensorflow.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🎬 Démo Vidéo

### Regardez notre vidéo de présentation complète :


     





## 📋 Table des matières

- [À propos](#à-propos)
- [Caractéristiques](#caractéristiques)
- [Architecture technique](#architecture-technique)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Modèle ML](#modèle-ml)
- [Contribution](#contribution)
- [Licence](#licence)

---

## 🎯 À propos

**Plant Disease Detection** est une solution complète pour l'identification automatique des maladies affectant les cultures. L'application combine une interface mobile intuitive développée avec **Flutter** et des modèles de **deep learning** puissants pour fournir des diagnostics précis et des recommandations de traitement en temps réel.

### 🌍 Cas d'usage

- 🌾 **Agriculture de précision** : Surveillance des grandes cultures
- 🏠 **Jardinage domestique** : Diagnostic pour jardiniers amateurs
- 🔬 **Recherche agronomique** : Collecte de données et analyse
- 📊 **Gestion de cultures** : Aide à la décision pour agriculteurs

---

## ✨ Caractéristiques principales

### 📱 Interface Mobile Flutter
- ✅ Interface utilisateur intuitive et fluide
- ✅ Capture d'images en temps réel via caméra
- ✅ Galerie de photos avec historique
- ✅ Prévisualisation avant analyse
- ✅ Support multi-plateforme (iOS & Android)

### 🤖 Moteur d'Intelligence Artificielle
- ✅ Modèles CNN (Convolutional Neural Networks) avancés
- ✅ Taux de précision supérieur à 95%
- ✅ Détection rapide (< 2 secondes par image)
- ✅ Support de multiples espèces végétales
- ✅ Classification de 38+ maladies différentes
- ✅ Recommandations de traitement automatiques

### 🔧 Architecture Robuste
- ✅ Backend API optimisé
- ✅ Traitement efficace des images
- ✅ Stockage des diagnostics en cache
- ✅ Mode hors ligne disponible

---

## 🏗️ Architecture technique

### Stack Technologique

| Domaine | Technologie | Version |
|---------|-------------|---------|
| **Frontend Mobile** | Flutter | 3.0+ |
| **Langage Frontend** | Dart | 2.17+ |
| **Backend** | Python | 3.8+ |
| **ML Framework** | TensorFlow/Keras | 2.10+ |
| **Architecture ML** | EfficientNet-B3, ResNet-50 | - |
| **Base de données** | SQLite | - |
| **Plateforme Native iOS** | Swift | 5.0+ |
| **Plateforme Native Android** | Kotlin/Java | - |

---

## 🚀 Installation

### ✅ Prérequis

- Git >= 2.30
- Python >= 3.8
- Flutter >= 3.0.0
- Dart >= 2.17.0



# 📥 ÉTAPE 1 : Cloner le repository et entrer dans le dossier
git clone https://github.com/essabriabdelghani/Plant_Disease_Detection.git
cd Plant_Disease_Detection

# 📦 ÉTAPE 2 : Installation des dépendances Flutter
flutter pub get
flutter doctor

# 🐍 ÉTAPE 3 : Création et activation de l'environnement Python
python3 -m venv venv

# SÉLECTIONNEZ LA COMMANDE SELON VOTRE SYSTÈME :
# Pour macOS/Linux :
source venv/bin/activate
# Pour Windows (Décommentez la ligne suivante si nécessaire) :
# venv\Scripts\activate

# Installer les dépendances requises
pip install -r requirements.txt

# 🧠 ÉTAPE 4 : Télécharger les modèles de Machine Learning
python scripts/download_models.py

# ⚙️ ÉTAPE 5 : Vérifier la configuration et les appareils Android connectés
flutter devices

# 🚀 ÉTAPE 6 : Lancer l'application
flutter run
