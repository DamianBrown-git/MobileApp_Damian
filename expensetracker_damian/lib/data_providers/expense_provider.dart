import 'package:flutter/foundation.dart' show ChangeNotifier;
import '../models/expense_model.dart';
import '../models/category_model.dart';
import '../models/subcategory_model.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;
  // List of expenses
  List<Expense> _expenses = [];
  List<Subcategory> _subcategories = [];
  List<Category> _categories = [];

  // List of categories
  /*
  final List<Category> _categories = [
    Category(id: '1', name: 'Something Big', isDefault: false),
    Category(id: '2', name: 'Mind Blowing', isDefault: false),
    Category(id: '3', name: 'Fake', isDefault: false),
    Category(id: '4', name: 'Money Hungry', isDefault: false),
    Category(id: '5', name: 'Bottomless Pit', isDefault: false),
  ];

  // List of tags

  final List<Subcategory> _tasks = [
    Subcategory(id: '1', name: 'Breakfast'),
    Subcategory(id: '2', name: 'Lunch'),
    Subcategory(id: '3', name: 'Dinner'),
    Subcategory(id: '4', name: 'Treat'),
    Subcategory(id: '5', name: 'Vacation'),
    Subcategory(id: '6', name: 'Shopping'),    
    Subcategory(id: '7', name: 'SelfCare'),
    Subcategory(id: '8', name: 'Streaming'),
  ];
  */

  // Getters
  List<Expense> get expenseEntries => _expenses;
  List<Category> get categories => _categories;
  List<Subcategory> get subcategories => _subcategories;

  ExpenseProvider(this.storage) {
    _loadCategoriesFromStorage();
    _loadSubcategoriesFromStorage();
    _loadExpensesFromStorage();
  }

  void _loadExpensesFromStorage() {
  var storedExpenses = storage.getItem('expenses');
  if (storedExpenses != null) {
    final List<dynamic> decoded = jsonDecode(storedExpenses);
    _expenses = decoded
        .map((item) => Expense.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    notifyListeners();
  }
  else
  {
    _saveExpensesToStorage();
  }

}

void _loadCategoriesFromStorage() {
  var storedCategories = storage.getItem('categories');
  if (storedCategories != null) {
    final List<dynamic> decoded = jsonDecode(storedCategories);
    _categories = decoded
        .map((item) => Category.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    notifyListeners();
  }
  else
  {
      storage.setItem(
        'categories',
        jsonEncode(_categories.map((p) => p.toJson()).toList()),
      );
  }
}

void _loadSubcategoriesFromStorage() {
  var storedSubcategories = storage.getItem('subcategories');
  if (storedSubcategories != null) {
    final List<dynamic> decoded = jsonDecode(storedSubcategories);
    _subcategories = decoded
        .map((item) => Subcategory.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    notifyListeners();
  }
  else
  {
      storage.setItem(
        'subcategories',
        jsonEncode(_subcategories.map((t) => t.toJson()).toList()),
      );
  }
}

  // Add an expense
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

 void _saveExpensesToStorage() {
  storage.setItem(
    'expenses',
    jsonEncode(_expenses.map((e) => e.toJson()).toList()),
  );
}

  void addOrUpdateExpenses(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      // Update existing expense
      _expenses[index] = expense;
    } else {
      // Add new Expense
      _expenses.add(expense);
    }
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Delete an expense
  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Add a category
  void addCategory(Category category) {
    if (!_categories.any((p) => p.name == category.name)) {
      _categories.add(category);
      storage.setItem(
        'categories',
        jsonEncode(_categories.map((p) => p.toJson()).toList()),
      );
      notifyListeners();
    }
  }

  //add subcategories
  void addSubcategory(Subcategory subcategory) {
    if (!_subcategories.any((t) => t.name == subcategory.name)) {
      _subcategories.add(subcategory);
      storage.setItem(
        'subcategories',
        jsonEncode(_subcategories.map((t) => t.toJson()).toList()),
      );
      notifyListeners();
    }
  }

  // Delete a category
  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  // Delete a tag
  void deleteSubcategory(String id) {
    _subcategories.removeWhere((subcategory) => subcategory.id == id);
    notifyListeners();
  }

  int generateCategoryId() {
    return categories.length;
  }

  int generateSubcategoryId() {
    return subcategories.length;
  }

  int generateExpenseId() {
    return expenseEntries.length;
  }
/*
  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage(); // Save the updated list to local storage
    notifyListeners();
  }*/
}
