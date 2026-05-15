import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkMode = false;
  bool saveHistory = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: const Color(0xFF2E7D32),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          // SECTION GENERAL
          const Text(
            'Général',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [
                SwitchListTile(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                  title: const Text('Notifications'),
                  subtitle: const Text('Activer les notifications'),
                  secondary: const Icon(Icons.notifications),
                ),

                const Divider(height: 1),

                SwitchListTile(
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                  title: const Text('Mode sombre'),
                  subtitle: const Text('Changer le thème de l’application'),
                  secondary: const Icon(Icons.dark_mode),
                ),

                const Divider(height: 1),

                SwitchListTile(
                  value: saveHistory,
                  onChanged: (value) {
                    setState(() {
                      saveHistory = value;
                    });
                  },
                  title: const Text('Historique'),
                  subtitle: const Text('Sauvegarder les analyses'),
                  secondary: const Icon(Icons.history),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // SECTION INFO
          const Text(
            'Informations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Politique de confidentialité'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Aide'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // BUTTON
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paramètres sauvegardés')),
              );
            },

            icon: const Icon(Icons.save),

            label: const Text('Sauvegarder'),

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
