import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class WithdrawScreen extends StatefulWidget {
  final double balance;
  final Function(double) onWithdraw;

  const WithdrawScreen({
    super.key,
    required this.balance,
    required this.onWithdraw,
  });

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();
  double? _selectedNominal;

  final List<double> _nominals = [
    50000,
    100000,
    200000,
    500000,
    1000000,
    1500000,
    2000000,
  ];

  String _generateWithdrawCode() {
    final random = Random();
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += random.nextInt(10).toString();
    }
    return code;
  }

  void _showWithdrawCodeDialog(BuildContext context, double nominal, String code) {
    // Buat transaksi baru
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: nominal,
      type: 'withdraw',
      date: DateTime.now(),
      code: code,
      description: 'Penarikan Tunai',
      status: 'pending',
    );
    
    // Tambahkan ke daftar transaksi
    TransactionService.addTransaction(transaction);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Kode Penarikan Tunai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Gunakan kode berikut untuk melakukan penarikan di ATM/Merchant terdekat:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nominal: Rp ${NumberFormat('#,###', 'id_ID').format(nominal)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kode berlaku selama 24 jam',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              
              // Update status transaksi menjadi success
              transaction.status = 'success';
              
              // Proses transaksi setelah dialog ditutup
              widget.onWithdraw(nominal);
              Navigator.pop(context); // Kembali ke halaman sebelumnya
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Penarikan tunai sebesar Rp ${NumberFormat('#,###', 'id_ID').format(nominal)} berhasil'
                  ),
                ),
              );
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penarikan Tunai'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Saldo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, 
                      color: Colors.blue.shade800),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saldo Tersedia',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,###', 'id_ID').format(widget.balance)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Pilihan Nominal
              const Text(
                'Pilih Nominal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _nominals.map((nominal) {
                  final isSelected = _selectedNominal == nominal;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedNominal = nominal;
                        _nominalController.text = nominal.toString();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade800 : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.blue.shade800 : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(nominal)}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Nominal Lainnya
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal Lainnya',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  final nominal = double.tryParse(value);
                  if (nominal == null) {
                    return 'Nominal tidak valid';
                  }
                  if (nominal > widget.balance) {
                    return 'Saldo tidak cukup';
                  }
                  if (nominal < 50000) {
                    return 'Minimal penarikan Rp 50.000';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Tombol Tarik
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final nominal = double.parse(_nominalController.text);
                      final withdrawCode = _generateWithdrawCode();
                      
                      // Tampilkan kode penarikan
                      _showWithdrawCodeDialog(context, nominal, withdrawCode);
                    }
                  },
                  child: const Text('Tarik Dana'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 