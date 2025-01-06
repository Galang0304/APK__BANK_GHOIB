import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';
import '../services/transaction_service.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class QRISScreen extends StatefulWidget {
  final double balance;
  final Function(double) onBalanceUpdate;
  final VoidCallback onTransaction;

  const QRISScreen({
    super.key,
    required this.balance,
    required this.onBalanceUpdate,
    required this.onTransaction,
  });

  @override
  State<QRISScreen> createState() => _QRISScreenState();
}

class _QRISScreenState extends State<QRISScreen> {
  late MobileScannerController controller;
  bool _isFlashOn = false;
  bool _isScanComplete = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: _isFlashOn,
    );
    _requestCameraPermission();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (!_isScanComplete) {
      final List<Barcode> barcodes = capture.barcodes;
      for (final barcode in barcodes) {
        if (barcode.rawValue != null) {
          _isScanComplete = true;
          _handleQRCode(barcode.rawValue!);
          break;
        }
      }
    }
  }

  void _handleQRCode(String qrData) {
    // Format QR: MERCHANT_NAME|AMOUNT
    final data = qrData.split('|');
    if (data.length == 2) {
      final merchantName = data[0];
      final amount = double.tryParse(data[1]);
      
      if (amount != null) {
        _showPaymentConfirmation(merchantName, amount);
      }
    }
  }

  void _showPaymentConfirmation(String merchantName, double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Merchant: $merchantName'),
            const SizedBox(height: 8),
            Text(
              'Nominal: Rp ${NumberFormat('#,###', 'id_ID').format(amount)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _isScanComplete = false;
              Navigator.pop(context);
              controller.start();
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: amount <= widget.balance ? () {
              _processPayment(merchantName, amount);
              Navigator.pop(context);
            } : null,
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }

  void _processPayment(String merchantName, double amount) {
    // Buat transaksi baru
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: 'qris',
      date: DateTime.now(),
      code: '${DateTime.now().millisecondsSinceEpoch}',
      description: 'Pembayaran QRIS - $merchantName',
      status: 'success',
    );
    
    // Tambahkan ke riwayat transaksi
    TransactionService.addTransaction(transaction);
    
    // Update saldo
    final newBalance = widget.balance - amount;
    widget.onBalanceUpdate(newBalance);
    widget.onTransaction();

    // Tampilkan notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pembayaran ke $merchantName berhasil'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset scanner
    _isScanComplete = false;
    controller.start();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      log('Camera permission is denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QRIS'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
                controller.toggleTorch();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: _handleDetection,
                ),
                CustomPaint(
                  painter: ScannerOverlay(),
                  child: const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 50,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: const Text(
                      'Arahkan kamera ke Kode QR untuk melakukan pembayaran',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Saldo Anda',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${NumberFormat('#,###', 'id_ID').format(widget.balance)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    const scanAreaSize = 300.0;
    final scanAreaLeft = (size.width - scanAreaSize) / 2;
    final scanAreaTop = (size.height - scanAreaSize) / 2;

    // Draw overlay
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                scanAreaLeft,
                scanAreaTop,
                scanAreaSize,
                scanAreaSize,
              ),
              const Radius.circular(10),
            ),
          ),
      ),
      paint,
    );

    // Draw scan area border
    final borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          scanAreaLeft,
          scanAreaTop,
          scanAreaSize,
          scanAreaSize,
        ),
        const Radius.circular(10),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 