//todo expenses
import 'package:expensetracker/main.dart';
import 'package:expensetracker/widgets/chart/chart.dart';
import 'package:expensetracker/widgets/expenses_list/expenses_list.dart';
import 'package:expensetracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/models/expense.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    // TODO: implement createState
    return _ExpensesState();
  }
}
class _ExpensesState extends State<Expenses>{
  final List<Expense> _registeredExpenses = [
    Expense(title: 'Flutter Course ',
        amount:19.99 ,
        date: DateTime.now(),
        category:Category.work
    ),//1
    Expense(title: 'Cinema ',
        amount:15.69 ,
        date: DateTime.now(),
        category:Category.leisure
    ),//2
  ];

  void _openAddExpensesOverlay(){
    showModalBottomSheet(
      isScrollControlled:true ,
      context: context,
      builder: (ctx){
      return NewExpense(onAddExpense:_addExpense);
    },
    );
  }
  void _addExpense (Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final _removeExpenseIndex=_registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Expense deleted'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label:'Undo',
              onPressed:(){
                setState(() {
                  _registeredExpenses.insert(_removeExpenseIndex, expense);
                });
              } ,
            ),
        ),
    );
  }
  @override
  Widget build(BuildContext context){

    Widget mainContent=const Center(child: Text('no expenses found start adding some'),);
    if (_registeredExpenses.isNotEmpty){
      mainContent=ExpensesList(expenses: _registeredExpenses , onRemoveExpense: _removeExpense,);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
              onPressed:_openAddExpensesOverlay,
              icon:const Icon(Icons.add))
        ],
      ),
      body: Column(
        children:[
          Chart(expenses:_registeredExpenses),
          Expanded(child:mainContent),
        ],
      ),
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  }
      );
  ExpenseBucket.forCategory(List <Expense> allExpenses , this.category)
      : expenses= allExpenses
      .where((expense) =>expense.category==category).toList();
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses{
    double sum=0;
    for(final expense in expenses){
      sum+=expense.amount;
    }
    return sum;
  }
}