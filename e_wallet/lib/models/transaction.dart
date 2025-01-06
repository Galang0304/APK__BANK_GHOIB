import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final double amount;
  final String type; // 'withdraw', 'deposit', 'transfer', 'payment', 'pulsa', 'shopping'
  final DateTime date;
  final String code;
  final String description;
  String status;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.code,
    required this.description,
    this.status = 'pending',
  });

  void updateStatus(String newStatus) {
    status = newStatus;
  }

  String get typeLabel {
    switch (type) {
      case 'withdraw':
        return 'Penarikan Tunai';
      case 'deposit':
        return 'Setor Tunai';
      case 'transfer':
        return 'Transfer';
      case 'payment':
        return 'Pembayaran';
      case 'pulsa':
        return 'Pulsa & Paket';
      case 'shopping':
        return 'Belanja';
      default:
        return 'Transaksi';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case 'withdraw':
        return Icons.account_balance;
      case 'deposit':
        return Icons.add_circle_outline;
      case 'transfer':
        return Icons.send;
      case 'payment':
        return Icons.payment;
      case 'pulsa':
        return Icons.phone_android;
      case 'shopping':
        return Icons.shopping_cart;
      default:
        return Icons.receipt_long;
    }
  }
} 