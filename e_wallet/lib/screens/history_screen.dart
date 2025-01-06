import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<Transaction> transactions;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  @override
  void didUpdateWidget(HistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      transactions = TransactionService.getAllTransactions();
    });
  }

  void _refreshTransactions() async {
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshTransactions();
        },
        child: transactions.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada transaksi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  final isExpense = transaction.type == 'withdraw' || 
                                  transaction.type == 'transfer' ||
                                  transaction.type == 'payment' ||
                                  transaction.type == 'pulsa' ||
                                  transaction.type == 'shopping';
                  
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isExpense 
                            ? Colors.red.shade50 
                            : Colors.green.shade50,
                        child: Icon(
                          transaction.typeIcon,
                          color: isExpense 
                              ? Colors.red 
                              : Colors.green,
                        ),
                      ),
                      title: Text(
                        transaction.typeLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy, HH:mm').format(transaction.date),
                          ),
                          Text(
                            transaction.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${isExpense ? "-" : "+"} Rp ${NumberFormat('#,###', 'id_ID').format(transaction.amount)}',
                            style: TextStyle(
                              color: isExpense ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            transaction.status,
                            style: TextStyle(
                              fontSize: 12,
                              color: transaction.status == 'success' 
                                  ? Colors.green 
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
} 