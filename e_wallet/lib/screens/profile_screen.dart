import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Andia Galang',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'andiagalang@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Edit Profil'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Informasi Akun
            _buildSectionHeader('Informasi Akun'),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.blue.shade800),
              title: const Text('Nomor Telepon'),
              subtitle: const Text('+62 812-3456-7890'),
              trailing: const Icon(Icons.edit, size: 20),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.blue.shade800),
              title: const Text('Alamat'),
              subtitle: const Text('Jl. Raya No. 123, Jakarta'),
              trailing: const Icon(Icons.edit, size: 20),
              onTap: () {},
            ),
            const Divider(),

            // Keamanan
            _buildSectionHeader('Keamanan'),
            ListTile(
              leading: Icon(Icons.password, color: Colors.blue.shade800),
              title: const Text('Ubah Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.security, color: Colors.blue.shade800),
              title: const Text('Verifikasi 2 Langkah'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: Colors.blue,
              ),
            ),
            const Divider(),

            // Dokumen
            _buildSectionHeader('Dokumen'),
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.blue.shade800),
              title: const Text('KTP'),
              subtitle: const Text('Terverifikasi'),
              trailing: Icon(Icons.check_circle, color: Colors.green.shade600),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.badge, color: Colors.blue.shade800),
              title: const Text('NPWP'),
              subtitle: const Text('Belum terverifikasi'),
              trailing: Icon(Icons.warning, color: Colors.orange.shade600),
              onTap: () {},
            ),
            const Divider(),

            // Limit & Verifikasi
            _buildSectionHeader('Limit & Verifikasi'),
            ListTile(
              leading: Icon(Icons.account_balance_wallet, color: Colors.blue.shade800),
              title: const Text('Limit Transaksi'),
              subtitle: const Text('Rp 10.000.000 / hari'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.verified_user, color: Colors.blue.shade800),
              title: const Text('Status Verifikasi'),
              subtitle: const Text('Premium'),
              trailing: Icon(Icons.star, color: Colors.amber.shade600),
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        ),
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