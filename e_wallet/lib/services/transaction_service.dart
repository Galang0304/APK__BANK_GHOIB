import '../models/transaction.dart';

class TransactionService {
  static final List<Transaction> _transactions = [];

  static void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
  }

  static List<Transaction> getAllTransactions() {
    return List.from(_transactions.reversed);
  }

  static double getTotalIncome([DateTime? month]) {
    final transactions = _transactions.where((t) {
      if (month != null) {
        return t.date.year == month.year && 
               t.date.month == month.month && 
               (t.type == 'deposit' || t.type == 'transfer_in');
      }
      return t.type == 'deposit' || t.type == 'transfer_in';
    });
    return transactions.fold(0, (sum, t) => sum + t.amount);
  }

  static double getTotalExpense([DateTime? month]) {
    final transactions = _transactions.where((t) {
      if (month != null) {
        return t.date.year == month.year && 
               t.date.month == month.month && 
               (t.type == 'withdraw' || t.type == 'transfer' || 
                t.type == 'payment' || t.type == 'pulsa' || 
                t.type == 'shopping');
      }
      return t.type == 'withdraw' || t.type == 'transfer' || 
             t.type == 'payment' || t.type == 'pulsa' || 
             t.type == 'shopping';
    });
    return transactions.fold(0, (sum, t) => sum + t.amount);
  }

  static List<Transaction> getTransactionsByMonth(DateTime month) {
    return _transactions.where((t) => 
      t.date.year == month.year && t.date.month == month.month
    ).toList();
  }
} 