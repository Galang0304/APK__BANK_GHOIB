import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          // Keamanan
          _buildSectionHeader('Keamanan'),
          ListTile(
            leading: Icon(Icons.fingerprint, color: Colors.blue.shade800),
            title: const Text('Biometrik'),
            subtitle: const Text('Gunakan sidik jari untuk login'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.blue.shade800),
            title: const Text('Ubah PIN'),
            subtitle: const Text('Ganti PIN transaksi'),
            onTap: () {},
          ),
          const Divider(),

          // Notifikasi
          _buildSectionHeader('Notifikasi'),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue.shade800),
            title: const Text('Notifikasi Push'),
            subtitle: const Text('Terima notifikasi transaksi'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.blue.shade800),
            title: const Text('Email'),
            subtitle: const Text('Terima notifikasi via email'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: Colors.blue,
            ),
          ),
          const Divider(),

          // Preferensi
          _buildSectionHeader('Preferensi'),
          ListTile(
            leading: Icon(Icons.language, color: Colors.blue.shade800),
            title: const Text('Bahasa'),
            subtitle: const Text('Indonesia'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.blue.shade800),
            title: const Text('Tema'),
            subtitle: const Text('Mode Terang'),
            onTap: () {},
          ),
          const Divider(),

          // Informasi
          _buildSectionHeader('Informasi'),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue.shade800),
            title: const Text('Tentang Aplikasi'),
            subtitle: const Text('Versi 1.0.0'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.blue.shade800),
            title: const Text('Kebijakan Privasi'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.blue.shade800),
            title: const Text('Bantuan'),
            onTap: () {},
          ),
          const Divider(),

          // Akun
          _buildSectionHeader('Akun'),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade800),
            title: const Text('Keluar'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
} 