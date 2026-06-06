import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'shop_screen.dart';
import 'journal_screen.dart';
import '../widgets/task_card.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _pointsController = TextEditingController();
  bool _isEditMode = false;
  bool _isAddTaskExpanded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _addTask() {
    final name = _nameController.text.trim();
    final points = int.tryParse(_pointsController.text.trim());

    if (name.isEmpty || points == null || points <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название и баллы!')),
      );
      return;
    }

    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.addTask(Task(id: DateTime.now().millisecondsSinceEpoch, name: name, points: points));
    
    _nameController.clear();
    _pointsController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Задание добавлено!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              _buildScoreSection(),
              Expanded(child: _buildTaskList()),
              _buildAddTaskSection(),
            ],
          ),
          Positioned(
            right: 16,
            top: 210,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isEditMode = !_isEditMode;
                });
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _isEditMode ? Icons.close : Icons.edit,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x4D2E7D32),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Баллы',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontFamily: 'Lobster',
              fontWeight: FontWeight.normal,
              shadows: [
                Shadow(
                  color: Color(0x26000000),
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const JournalScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.store_rounded, color: Colors.white, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ShopScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Заработано баллов',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 30,
              fontFamily: 'Lobster',
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          Consumer<AppProvider>(
            builder: (_, provider, __) => Container(
              width: 160,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C853), Color(0xFF00796B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x4D00961E),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9100), Color(0xFFFF3D00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x66FFFFFF),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: const Color(0x26000000),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      provider.score.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontFamily: 'Lobster',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer<AppProvider>(
      builder: (_, provider, __) {
        if (provider.tasks.isEmpty) {
          return const Center(child: Text('Нет заданий'));
        }
        
        if (_isEditMode) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              final doneToday = provider.hasTransactionToday('earn', task.id);
              return Dismissible(
                key: ValueKey('task-${task.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  provider.removeTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Задание удалено!')),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    task: task,
                    isEditMode: _isEditMode,
                    doneToday: doneToday,
                    showDeleteButton: true,
                    isDragging: false,
                    onTap: () {},
                    onDelete: () {
                      provider.removeTask(task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Задание удалено!')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              final doneToday = provider.hasTransactionToday('earn', task.id);
              return Dismissible(
                key: Key('task-${task.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  provider.removeTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Задание удалено!')),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: TaskCard(
                    task: task,
                    isEditMode: _isEditMode,
                    doneToday: doneToday,
                    showDeleteButton: false,
                    isDragging: false,
                    onTap: () {
                      if (!provider.hasTransactionToday('earn', task.id)) {
                        provider.addPoints(task.points, 'earn', task.id, task.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Заработано ${task.points} баллов!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Выполнено сегодня!')),
                        );
                      }
                    },
                    onDelete: () {
                      provider.removeTask(task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Задание удалено!')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildAddTaskSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              final isExpanded = _isAddTaskExpanded;
              setState(() {
                _isAddTaskExpanded = !isExpanded;
              });
              if (!_isAddTaskExpanded) {
                _nameController.clear();
                _pointsController.clear();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFaed581), Color(0xFF8bc34a)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x332E7D32),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Добавить работу',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isAddTaskExpanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            child: _isAddTaskExpanded
                ? Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x1A000000),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Название работы',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFFFDF0),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFF8bc34a),
                                width: 2,
                              ),
                            ),
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _pointsController,
                          decoration: InputDecoration(
                            hintText: 'Кол-во баллов',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFFFDF0),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Color(0xFF8bc34a),
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _addTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Добавить задание',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}