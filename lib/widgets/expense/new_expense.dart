import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.addNewExpense, {super.key});

  final void Function(Expense newExpense) addNewExpense;
  @override
  State<StatefulWidget> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  var _enteredTitle = '';
  DateTime? selectedDate;
  Category selectedCategory = Category.food;
  void _saveTitleInput(String inputValue) {
    _enteredTitle = inputValue;
  }

  void _saveExpense() {
    var amount = double.tryParse(_amountController.text);
    var isvalidAmount = amount != null && amount > 0;
    if (!isvalidAmount ||
        _enteredTitle.trim().isEmpty ||
        selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) =>  AlertDialog(
          title: const Text("Invalid data"),
          content: const Text("Please make sure entered title, amount, date and Category are correct."),
          actions: [TextButton(onPressed: () {Navigator.pop(ctx);}, child: const Text("Ok"))],
        ),
      );
      return;
    }
    Expense newExpense = Expense(
        title: _enteredTitle,
        amount: amount,
        expenseDate: selectedDate!,
        category: selectedCategory);
    widget.addNewExpense(newExpense);
    Navigator.pop(context);
  }

  final _amountController = TextEditingController();
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = now;
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: now,
    );
    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        children: [
          TextField(
            onChanged: _saveTitleInput,
            maxLength: 30,
            decoration: const InputDecoration(label: Text("Title")),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text("Amount"),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(selectedDate == null
                        ? "no date selected"
                        : formatter.format(selectedDate!)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12,),
          Row(
            children: [
              DropdownButton(
                  value: selectedCategory,
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (Category? value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      selectedCategory = value;
                    });
                  }),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text("Save Expense"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
