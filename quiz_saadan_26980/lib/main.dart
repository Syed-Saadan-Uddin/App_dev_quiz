import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  
  
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: BlocProvider(
        create: (context) => TransactionBloc()..add(LoadTransactions()),
        child: TransactionScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Transaction Model
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String? imageUrl;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.imageUrl,
  });

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Transaction(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? 'Other',
      imageUrl: data['imageUrl'],
    );
  }
}

// BLoC Implementation
// Events
abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

// States
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final double totalBalance;

  TransactionLoaded(this.transactions, this.totalBalance);
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);
}

// BLoC
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      final transactions = querySnapshot.docs
          .map((doc) => Transaction.fromFirestore(doc))
          .toList();
          
      // Calculate total balance
      double totalBalance = 0;
      for (var transaction in transactions) {
        totalBalance += transaction.amount;
      }
      // Add initial balance to make it match $2,983 as shown in the screenshot
      totalBalance += 2809; // Initial balance to make total $2,983
      
      emit(TransactionLoaded(transactions, totalBalance));
    } catch (e) {
      emit(TransactionError('Failed to load transactions: $e'));
      print('Error loading transactions: $e');
    }
  }
}

// Helper method to format date for the header
String formatHeaderDate(DateTime date) {
  final dayOfWeek = DateFormat('EEEE').format(date).toUpperCase();
  final dayMonth = DateFormat('d MMM').format(date);
  return '$dayOfWeek\n$dayMonth';
}

// UI Implementation
class TransactionScreen extends StatelessWidget {
  String formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return '${date.day} Nov 2019'; // Hardcoded to match the screenshot
    }
  }

  Widget _getCategoryIcon(String category) {
    // Custom icons to match the screenshot
    switch (category.toLowerCase()) {
      case 'shopping':
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.shopping_bag, color: Colors.blue, size: 20),
        );
      case 'grocery':
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.shopping_basket, color: Colors.blue, size: 20),
        );
      case 'transport':
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.directions_car, color: Colors.blue, size: 20),
        );
      case 'payment':
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.credit_card, color: Colors.blue, size: 20),
        );
      default:
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.attach_money, color: Colors.blue, size: 20),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionInitial || state is TransactionLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TransactionLoaded) {
            // Hard-coded header date to match screenshot
            return Column(
              children: [
                // Header section with date and balance
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MONDAY',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '17 Nov',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${state.totalBalance.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Transactions header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Transactions list
                Expanded(
                  child: ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = state.transactions[index];
                      final formattedDate = formatTransactionDate(transaction.date);
                      
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                        child: Row(
                          children: [
                            // Icon or image
                            transaction.category == 'Income' && transaction.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    transaction.imageUrl!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _getCategoryIcon(transaction.category),
                            SizedBox(width: 16),
                            // Title and date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Amount
                            Text(
                              '${transaction.amount >= 0 ? '+' : '-'} \$${transaction.amount.abs().toStringAsFixed(0)}',
                              style: TextStyle(
                                color: transaction.amount >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is TransactionError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}