import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../models/shop_item.dart';
import '../models/transaction.dart';

class AppProvider with ChangeNotifier {
  int _score = 0;
  List<Task> _tasks = [];
  List<ShopItem> _shopItems = [];
  List<Transaction> _transactions = [];
  
  SharedPreferences? _prefs;
  
  static const String KEY_SCORE = 'score_balance';
  static const String KEY_TASKS = 'score_tasks';
  static const String KEY_SHOP_ITEMS = 'score_shop_items';
  static const String KEY_TRANSACTIONS = 'score_transactions';
  
  final List<Task> defaultTasks = [
    Task(id: 1, name: 'Посуда', points: 1),
    Task(id: 2, name: 'Птица', points: 1),
    Task(id: 3, name: 'Уборка', points: 2),
  ];
  
  final List<ShopItem> defaultShopItems = [
    ShopItem(id: 1, name: 'Завтрак', points: 3),
    ShopItem(id: 2, name: 'Обед', points: 3),
    ShopItem(id: 3, name: 'Ужин', points: 3),
    ShopItem(id: 4, name: 'Компьютер', points: 3),
  ];

  int get score => _score;
  List<Task> get tasks => _tasks;
  List<ShopItem> get shopItems => _shopItems;
  List<Transaction> get transactions => _transactions;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    
    _score = _prefs?.getInt(KEY_SCORE) ?? 0;
    
    final tasksJson = _prefs?.getStringList(KEY_TASKS) ?? [];
    _tasks = tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
    if (_tasks.isEmpty) _tasks = List.from(defaultTasks);
    
    final shopJson = _prefs?.getStringList(KEY_SHOP_ITEMS) ?? [];
    _shopItems = shopJson.map((json) => ShopItem.fromJson(jsonDecode(json))).toList();
    if (_shopItems.isEmpty) _shopItems = List.from(defaultShopItems);
    
    final transJson = _prefs?.getStringList(KEY_TRANSACTIONS) ?? [];
    _transactions = transJson.map((json) => Transaction.fromJson(jsonDecode(json))).toList();
    
    notifyListeners();
  }

  void addPoints(int amount, String type, int itemId, String name) {
    _score += amount;
    
    final now = DateTime.now();
    final transaction = Transaction(
      date: _getTodayDate(),
      type: type,
      itemId: itemId,
      name: name,
      points: amount,
      timestamp: now,
    );
    
    _transactions.add(transaction);
    _save();
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _save();
    notifyListeners();
  }

  void removeTask(int taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    _save();
    notifyListeners();
  }

  void addShopItem(ShopItem item) {
    _shopItems.add(item);
    _save();
    notifyListeners();
  }

  void removeShopItem(int itemId) {
    _shopItems.removeWhere((item) => item.id == itemId);
    _save();
    notifyListeners();
  }

  void clearHistory() {
    _transactions.clear();
    _save();
    notifyListeners();
  }

  void resetAll() {
    _score = 0;
    _tasks = List.from(defaultTasks);
    _shopItems = List.from(defaultShopItems);
    _transactions.clear();
    _save();
    notifyListeners();
  }

  void reorderTasks(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    
    // Перемещаем задачу в новый индекс
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    _save();
    notifyListeners();
  }

  bool hasTransactionToday(String type, int itemId) {
    final today = _getTodayDate();
    return _transactions.any((t) => t.date == today && t.type == type && t.itemId == itemId);
  }

  List<Transaction> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _save() async {
    await _prefs?.setInt(KEY_SCORE, _score);
    
    await _prefs?.setStringList(
      KEY_TASKS,
      _tasks.map((t) => jsonEncode(t.toJson())).toList(),
    );
    
    await _prefs?.setStringList(
      KEY_SHOP_ITEMS,
      _shopItems.map((s) => jsonEncode(s.toJson())).toList(),
    );
    
    await _prefs?.setStringList(
      KEY_TRANSACTIONS,
      _transactions.map((t) => jsonEncode(t.toJson())).toList(),
    );
  }
}
