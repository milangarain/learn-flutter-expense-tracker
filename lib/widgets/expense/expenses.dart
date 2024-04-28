import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense/expense_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  List<Expense> allExpenses = [
    Expense(
        title: 'Flutter',
        amount: 1999.0,
        expenseDate: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 199.0,
        expenseDate: DateTime.now(),
        category: Category.leisure),
  ];

  void addNewExpense(Expense newExpense) {
    setState(() {
      allExpenses.add(newExpense);
    });
  }

  void removeExpense(Expense expense) {
    final int index = allExpenses.indexOf(expense);
    setState(() {
      allExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Item removed from list.'),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () => {
          setState(() {
            allExpenses.insert(index, expense);
          })
        },
      ),
    ));
  }

  void _onShowOverlay() => {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (ctx) => NewExpense(addNewExpense))
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses Tracker"),
        actions: [
          IconButton(
            onPressed: _onShowOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: allExpenses),
          Expanded(
            child: ExpenseList(
              expenses: allExpenses,
              onExpenseRemove: removeExpense,
            ),
          ),
        ],
      ),
    );
    // const Text("aabc");
  }
}
