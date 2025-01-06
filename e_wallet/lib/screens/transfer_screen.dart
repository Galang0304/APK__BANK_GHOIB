import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferScreen extends StatefulWidget {
  final double balance;
  final Function(double) onTransfer;

  const TransferScreen({
    super.key,
    required this.balance,
    required this.onTransfer,
  });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomorController = TextEditingController();
  final _nominalController = TextEditingController();
  String _selectedBank = 'BRI';
  String _selectedType = 'bank'; // bank atau ewallet

  final List<String> _banks = [
    'BRI',
    'BCA',
    'Mandiri',
    'BNI',
    'CIMB Niaga',
    'BTN',
    'Bank Permata',
  ];

  final List<String> _ewallets = [
    'OVO',
    'GoPay',
    'DANA',
    'LinkAja',
    'ShopeePay',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
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
              // Pilihan Tipe Transfer
              const Text(
                'Pilih Jenis Transfer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      'Bank',
                      'bank',
                      Icons.account_balance,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTypeButton(
                      'E-Wallet',
                      'ewallet',
                      Icons.account_balance_wallet,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Pilihan Bank/E-Wallet
              if (_selectedType == 'bank') ...[
                const Text(
                  'Pilih Bank',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedBank,
                      items: _banks.map((bank) {
                        return DropdownMenuItem(
                          value: bank,
                          child: Text(bank),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBank = value!;
                        });
                      },
                    ),
                  ),
                ),
              ] else ...[
                const Text(
                  'Pilih E-Wallet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedBank,
                      items: _ewallets.map((wallet) {
                        return DropdownMenuItem(
                          value: wallet,
                          child: Text(wallet),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBank = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Nomor Rekening/Nomor HP
              TextFormField(
                controller: _nomorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _selectedType == 'bank' 
                      ? 'Nomor Rekening' 
                      : 'Nomor Telepon',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Nominal Transfer
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal Transfer',
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
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Tombol Transfer
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
                      widget.onTransfer(nominal);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Berhasil transfer ${_selectedType == 'bank' ? 'ke $_selectedBank' : 'ke $_selectedBank'} '
                            'Rp ${NumberFormat('#,###', 'id_ID').format(nominal)}'
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Transfer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, String type, IconData icon) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedBank = type == 'bank' ? _banks.first : _ewallets.first;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade800 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue.shade800 : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 