import 'package:flutter/material.dart';
import 'package:expensetracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
      //the picked date value is now assigned to a global variable to be used later
    });
    // the await method will allow flutter to wait for the date to be enetered
  } //to show dates
  final _titlecontroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory=Category.leisure;
  void _submitExpenseData(){
    final enteredAmount=double.tryParse(_amountcontroller.text);
    //tryparse coverts the given into double or null if it cannot
    final _amountIsInvalid= enteredAmount==null||enteredAmount<=0;
    if(_titlecontroller.text.trim().isEmpty|| _amountIsInvalid || _selectedDate == null){
      showDialog(context: context, builder: (ctx)=> AlertDialog(
        title: const Text('Invalid Input'),
        content: const Text('Please make sure correct title, date , amount and category was entered'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pop(ctx);
              }, 
              child: const Text('Okay'))
        ],
      ),
      );
      return;
      //show error message
    }
    widget.onAddExpense(Expense(
        title: _titlecontroller.text,
        amount:enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory)
    );
    Navigator.pop(context);
  }


  @override
  void dispose() {
    _titlecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            controller: _titlecontroller,
            maxLength: 50,
            decoration: InputDecoration(label: Text('Title')),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountcontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text('Amount'),
                    prefixText: '\$',
                  ),
                ),
              ), //expense amount
              const SizedBox(
                width: 50,
              ), // space between date and amount
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null
                        ? 'no date selected'
                        : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: () {
                        return _presentDatePicker();
                      },
                      icon: const Icon(
                        Icons.calendar_month,
                      ),
                    )
                  ],
                ),
              ), //date
            ],
          ), //textfields for information
          const SizedBox(height: 10,),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((category) =>
                        DropdownMenuItem(value: category,
                            child: Text(category.name.toUpperCase()),
                        ),
                )
                    .toList(),
                onChanged: (value){
                  if(value==null){
                    return;
                  }
                  setState(() {
                    _selectedCategory=value;
                  });

                },
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')), //cancel button
              ElevatedButton(
                onPressed: () {
                  _submitExpenseData();
                },
                child: const Text('Save Expense'),
              ) //save button
            ],
          ) //buttons
        ],
      ),
    );
  }
}
