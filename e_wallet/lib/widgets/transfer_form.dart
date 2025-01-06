import 'package:flutter/material.dart';

class TransferForm extends StatefulWidget {
  final String title;
  final Function(double) onTransfer;

  const TransferForm({
    super.key,
    required this.title,
    required this.onTransfer,
  });

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();
  final _tujuanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tujuanController,
              decoration: const InputDecoration(
                labelText: 'Nomor Tujuan',
                hintText: 'Masukkan nomor/rekening tujuan',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor tujuan harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                hintText: 'Masukkan jumlah transfer',
                prefixText: 'Rp ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nominal harus diisi';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final nominal = double.parse(_nominalController.text);
              widget.onTransfer(nominal);
              Navigator.pop(context);
            }
          },
          child: const Text('Kirim'),
        ),
      ],
    );
  }
} 