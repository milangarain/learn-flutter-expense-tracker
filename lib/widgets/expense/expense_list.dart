import 'package:expense_tracker/widgets/expense/expense_item.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.onExpenseRemove});
  final List<Expense> expenses;
  final void Function(Expense expense) onExpenseRemove;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        onDismissed: (direction) => {
          onExpenseRemove(expenses[index]),
        },
        child: ExpenseItem(
          expense: expenses[index],
        ),
      ),
    );
  }
}
