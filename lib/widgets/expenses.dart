import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 9.99,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      builder: (ctx) => NewExpense(
        onAddExpense: addExpense,
      ),
      isScrollControlled: true,
    );
  }

  void addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex=_registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(label: ('Undo'), onPressed:() {
          setState(() {
            _registeredExpense.insert(expenseIndex, expense);
          });
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expenses found.Start adding some!'),
    );
    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpense,
        onRemoveExpense: removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker',style: TextStyle(fontSize: 20),),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
        ],
      ),
      body:width<600? Column(
        children: [
          Chart(expenses: _registeredExpense),
          Expanded(child: mainContent),
        ],
      ):Row(
        children: [
          Expanded(child: Chart(expenses: _registeredExpense)),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
