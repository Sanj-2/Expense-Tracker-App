import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData(){
    final enteredAmount=double.tryParse(_amountController.text);
    final amountIsInvalid=(enteredAmount==null || enteredAmount<=0);
    if (_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate== null) {
      showDialog(context: context, builder: 
      (ctx)=>AlertDialog(title: const Text('Invalid Input'),
      content: const Text('Please make sure a valid title,date,amountand category has been enetered.'),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(ctx);
        }, child: const Text('Okay'))
      ],
      )
      );
      return;
    }
    widget.onAddExpense(Expense(title: _titleController.text, amount: enteredAmount, date: _selectedDate!, category: _selectedCategory));
    Navigator.pop(context);
  }
  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSize=MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(16,48,16,keyBoardSize+16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text('Title',style: Theme.of(context).textTheme.titleMedium,),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount',style: Theme.of(context).textTheme.titleMedium,),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_selectedDate == null
                          ? ('No Date Selected')
                          : formatter.format(_selectedDate!),style: Theme.of(context).textTheme.titleMedium,),
                      IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month)),
                    ],
                  ))
                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if(value==null){
                          return;
                        }
                        setState(() {
                          _selectedCategory=value;
                        });
                      },
                    ),
                    const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',style: Theme.of(context).textTheme.titleMedium,)),
                  ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: Text('Save Expense',style: Theme.of(context).textTheme.titleMedium,)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
