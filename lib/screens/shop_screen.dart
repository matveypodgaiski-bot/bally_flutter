import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/shop_item.dart';
import '../widgets/shop_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _isEditMode = false;
  bool _showAddMenu = false;
  final _nameController = TextEditingController();
  final _pointsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _addShopItem() {
    final name = _nameController.text.trim();
    final points = int.tryParse(_pointsController.text.trim());

    if (name.isEmpty || points == null || points <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название и цену!')),
      );
      return;
    }

    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.addShopItem(
      ShopItem(id: DateTime.now().millisecondsSinceEpoch, name: name, points: points),
    );
    _nameController.clear();
    _pointsController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Товар добавлен!')),
    );
  }

  void _showDeleteDialog(int itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Удалить товар'),
        content: const Text('Вы уверены?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<AppProvider>(context, listen: false);
              provider.removeShopItem(itemId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Товар удалён!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Column(
        children: [
          _buildHeader(),
          _buildScoreSection(),
          Expanded(child: _buildShopList()),
          _buildButtons(),
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
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Магазин',
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
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
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

  Widget _buildShopList() {
    return Consumer<AppProvider>(
      builder: (_, provider, __) {
        if (provider.shopItems.isEmpty) {
          return const Center(child: Text('Нет товаров'));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: provider.shopItems.length,
          itemBuilder: (context, index) {
            final item = provider.shopItems[index];
            final doneToday = provider.hasTransactionToday('spend', item.id);
            return Dismissible(
              key: Key(item.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) => _showDeleteDialog(item.id),
              child: ShopCard(
                item: item,
                isEditMode: _isEditMode,
                doneToday: doneToday,
                onTap: () {
                  if (!provider.hasTransactionToday('spend', item.id)) {
                    if (provider.score >= item.points) {
                      provider.addPoints(-item.points, 'spend', item.id, item.name);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Куплено: ${item.name}')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Недостаточно баллов!')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Уже куплено сегодня!')),
                    );
                  }
                },
                onDelete: () => _showDeleteDialog(item.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _nameController.clear();
                  _pointsController.clear();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Добавить покупку'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(hintText: 'Название покупки'),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _pointsController,
                            decoration: const InputDecoration(hintText: 'Цена в баллах'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Отмена'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _addShopItem();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA500),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Добавить'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Добавить покупку +'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white.withOpacity(0.8),
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF757575),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              textStyle: const TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
            ),
            child: const Text(
              '← Вернуться назад',
              style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}
