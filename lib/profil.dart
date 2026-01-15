import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Halaman_Profil extends StatelessWidget {
  const Halaman_Profil({super.key});

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Tidak dapat membuka ${uri.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Profil"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// ===== PROFILE CARD =====
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: const [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Profil Pengguna",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Aplikasi Flutter",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ===== ACTION BUTTONS =====
              _buildActionButton(
                icon: Icons.phone,
                label: "Hubungi Kami",
                color: Colors.green,
                onTap: () {
                  _launchUrl(Uri.parse("tel:081548344821"));
                },
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                icon: Icons.chat,
                label: "Chat via WhatsApp",
                color: Colors.teal,
                onTap: () {
                  _launchUrl(Uri.parse("https://wa.me/6281548344812"));
                },
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                icon: Icons.email,
                label: "Kirim Email",
                color: Colors.deepPurple,
                onTap: () {
                  _launchUrl(
                    Uri(
                      scheme: 'mailto',
                      path: 'contoh@email.com',
                      queryParameters: {
                        'subject': 'Halo',
                        'body': 'Ini pesan dari aplikasi Flutter',
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// BUTTON COMPONENT
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 6,
        ),
        onPressed: onTap,
      ),
    );
  }
}