import 'package:flutter/material.dart';
import '../widgets/menu_item.dart';
import '../widgets/fade_animation.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../screens/transfer_screen.dart';
import '../screens/withdraw_screen.dart';
import '../screens/deposit_screen.dart';
import '../screens/history_screen.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';

class HomeScreen extends StatefulWidget {
  final double initialBalance;
  final Function(double) onBalanceUpdate;
  final VoidCallback onTransaction;

  const HomeScreen({
    super.key, 
    required this.initialBalance,
    required this.onBalanceUpdate,
    required this.onTransaction,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double _balance;
  bool _isBalanceVisible = true;
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    _balance = widget.initialBalance;
    selectedMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalIncome = TransactionService.getTotalIncome(selectedMonth);
    final totalExpense = TransactionService.getTotalExpense(selectedMonth);
    
    return Column(
      children: [
        // Info Pengguna
        FadeAnimation(
          delay: 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blue.shade800, size: 26),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      'Andia Galang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Bagian Saldo
        FadeAnimation(
          delay: 0.8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Saldo',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _isBalanceVisible 
                          ? 'Rp ${NumberFormat('#,###', 'id_ID').format(_balance)}'
                          : 'Rp ••••••',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        _isBalanceVisible 
                            ? Icons.visibility_outlined 
                            : Icons.visibility_off_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Menu Utama
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  FadeAnimation(
                    delay: 1.0,
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.82,
                      padding: EdgeInsets.zero,
                      children: [
                        MenuItem(
                          icon: Icons.send, 
                          label: 'Transfer',
                          description: 'Kirim Uang',
                          onTap: _handleKirimUang,
                        ),
                        MenuItem(
                          icon: Icons.account_balance, 
                          label: 'Tunai',
                          description: 'Tarik & Setor',
                          onTap: _handleWithdraw,
                        ),
                        MenuItem(
                          icon: Icons.shopping_cart, 
                          label: 'Belanja',
                          description: 'Online',
                          onTap: _handleBelanja,
                        ),
                        MenuItem(
                          icon: Icons.grid_view, 
                          label: 'Menu',
                          description: 'Lainnya',
                          onTap: _handleSemuaMenu,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade800,
                          Colors.blue.shade600,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.insert_chart_outlined, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Ringkasan Bulan Ini',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                                  onPressed: _previousMonth,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM yyyy', 'id_ID').format(selectedMonth),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                                  onPressed: _nextMonth,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.arrow_downward, color: Colors.white, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      'Pemasukan',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Rp ${NumberFormat('#,###', 'id_ID').format(totalIncome)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white24,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      'Pengeluaran',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Rp ${NumberFormat('#,###', 'id_ID').format(totalExpense)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Grafik Transaksi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: Stack(
                            children: [
                              // Garis dasar
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              // Bar chart
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBar('Minggu 1', 0.3, Colors.blue),
                                  _buildBar('Minggu 2', 0.5, Colors.blue),
                                  _buildBar('Minggu 3', 0.7, Colors.blue),
                                  _buildBar('Minggu 4', 0.4, Colors.blue),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLegend('Pemasukan', Colors.blue),
                            const SizedBox(width: 16),
                            _buildLegend('Pengeluaran', Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection() {
    final totalIncome = TransactionService.getTotalIncome(selectedMonth);
    final totalExpense = TransactionService.getTotalExpense(selectedMonth);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade800,
                Colors.blue.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.insert_chart_outlined, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Ringkasan Bulan Ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 20,
                        icon: const Icon(Icons.chevron_left, color: Colors.white),
                        onPressed: _previousMonth,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM yyyy', 'id_ID').format(selectedMonth),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 20,
                        icon: const Icon(Icons.chevron_right, color: Colors.white),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Pemasukan',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(totalIncome)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Pengeluaran',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rp ${NumberFormat('#,###', 'id_ID').format(totalExpense)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Grafik Transaksi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    // Garis dasar
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    // Bar chart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar('Minggu 1', 0.3, Colors.blue),
                        _buildBar('Minggu 2', 0.5, Colors.blue),
                        _buildBar('Minggu 3', 0.7, Colors.blue),
                        _buildBar('Minggu 4', 0.4, Colors.blue),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegend('Pemasukan', Colors.blue),
                  const SizedBox(width: 16),
                  _buildLegend('Pengeluaran', Colors.red),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBar(String label, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 80 * height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 80 * height * 0.7,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _handleKirimUang() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferScreen(
          balance: _balance,
          onTransfer: (nominal) {
            final transaction = Transaction(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              amount: nominal,
              type: 'transfer',
              date: DateTime.now(),
              code: '${Random().nextInt(900000) + 100000}',
              description: 'Transfer Uang',
              status: 'success',
            );
            TransactionService.addTransaction(transaction);
            
            setState(() {
              _balance -= nominal;
              widget.onBalanceUpdate(_balance);
            });
            widget.onTransaction();
          },
        ),
      ),
    );
  }

  void _handleDeposit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepositScreen(
          balance: _balance,
          onDeposit: (nominal) {
            setState(() {
              _balance += nominal;
              widget.onBalanceUpdate(_balance);
            });
          },
        ),
      ),
    );
  }

  void _handleWithdraw() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Transaksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Icon(Icons.arrow_downward, color: Colors.blue.shade800),
              ),
              title: const Text('Setor Tunai'),
              subtitle: const Text('Setor uang tunai ke rekening'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepositScreen(
                      balance: _balance,
                      onDeposit: (nominal) {
                        setState(() {
                          _balance += nominal;
                          widget.onBalanceUpdate(_balance);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.shade50,
                child: Icon(Icons.arrow_upward, color: Colors.red.shade800),
              ),
              title: const Text('Tarik Tunai'),
              subtitle: const Text('Tarik uang tunai dari rekening'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawScreen(
                      balance: _balance,
                      onWithdraw: (nominal) {
                        setState(() {
                          _balance -= nominal;
                          widget.onBalanceUpdate(_balance);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleTagihanListrik() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bayar Tagihan Listrik'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nomor Meter/ID Pelanggan',
                hintText: 'Masukkan nomor meter',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tagihan: Rp 250.000'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final transaction = Transaction(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                amount: 250000,
                type: 'payment',
                date: DateTime.now(),
                code: '${Random().nextInt(900000) + 100000}',
                description: 'Pembayaran Tagihan Listrik',
                status: 'success',
              );
              TransactionService.addTransaction(transaction);
              
              setState(() {
                _balance -= 250000;
                widget.onBalanceUpdate(_balance);
              });
              widget.onTransaction();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pembayaran listrik berhasil')),
              );
            },
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }

  void _handlePulsaPaket() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Isi Pulsa & Paket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                hintText: 'Masukkan nomor telepon',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Nominal'),
              items: [
                10000, 20000, 50000, 100000
              ].map((nominal) => DropdownMenuItem(
                value: nominal,
                child: Text('Rp ${NumberFormat('#,###', 'id_ID').format(nominal)}'),
              )).toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final transaction = Transaction(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                amount: 50000,
                type: 'pulsa',
                date: DateTime.now(),
                code: '${Random().nextInt(900000) + 100000}',
                description: 'Pembelian Pulsa',
                status: 'success',
              );
              TransactionService.addTransaction(transaction);
              
              setState(() {
                _balance -= 50000;
                widget.onBalanceUpdate(_balance);
              });
              widget.onTransaction();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pembelian pulsa berhasil')),
              );
            },
            child: const Text('Beli'),
          ),
        ],
      ),
    );
  }

  void _handleBelanja() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Belanja Online'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nama Merchant',
                hintText: 'Masukkan nama merchant',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                prefixText: 'Rp ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final transaction = Transaction(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                amount: 150000,
                type: 'shopping',
                date: DateTime.now(),
                code: '${Random().nextInt(900000) + 100000}',
                description: 'Pembayaran Merchant XYZ',
                status: 'success',
              );
              TransactionService.addTransaction(transaction);
              
              setState(() {
                _balance -= 150000;
                widget.onBalanceUpdate(_balance);
              });
              widget.onTransaction();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pembayaran merchant berhasil')),
              );
            },
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }

  void _handlePromo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Promo Spesial'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.local_offer, color: Colors.blue.shade800),
              title: const Text('Diskon 50% Merchant ABC'),
              subtitle: const Text('Min. transaksi Rp 100.000'),
              onTap: () {
                final transaction = Transaction(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  amount: 100000,
                  type: 'shopping',
                  date: DateTime.now(),
                  code: '${Random().nextInt(900000) + 100000}',
                  description: 'Promo Diskon 50% Merchant ABC',
                  status: 'success',
                );
                TransactionService.addTransaction(transaction);
                
                setState(() {
                  _balance -= 100000;
                  widget.onBalanceUpdate(_balance);
                });
                widget.onTransaction();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pembayaran promo berhasil')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.local_offer, color: Colors.blue.shade800),
              title: const Text('Cashback 20% Merchant XYZ'),
              subtitle: const Text('Max. cashback Rp 50.000'),
              onTap: () {
                final transaction = Transaction(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  amount: 200000,
                  type: 'shopping',
                  date: DateTime.now(),
                  code: '${Random().nextInt(900000) + 100000}',
                  description: 'Promo Cashback 20% Merchant XYZ',
                  status: 'success',
                );
                TransactionService.addTransaction(transaction);
                
                setState(() {
                  _balance -= 200000;
                  widget.onBalanceUpdate(_balance);
                });
                widget.onTransaction();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pembayaran promo berhasil')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleRiwayat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HistoryScreen(),
      ),
    );
  }

  void _handleSemuaMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Semua Menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildMenuItem(Icons.payment, 'Tagihan Listrik', () {
                  Navigator.pop(context);
                  _handleTagihanListrik();
                }),
                _buildMenuItem(Icons.phone_android, 'Pulsa & Data', () {
                  Navigator.pop(context);
                  _handlePulsaPaket();
                }),
                _buildMenuItem(Icons.water_drop, 'PDAM', () {}),
                _buildMenuItem(Icons.payment, 'BPJS', () {}),
                _buildMenuItem(Icons.wifi, 'Internet', () {}),
                _buildMenuItem(Icons.credit_card, 'Kartu Kredit', () {}),
                _buildMenuItem(Icons.movie, 'Hiburan', () {}),
                _buildMenuItem(Icons.school, 'Pendidikan', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade800),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
} 