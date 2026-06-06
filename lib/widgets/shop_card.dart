import 'package:flutter/material.dart';
import '../models/shop_item.dart';

class ShopCard extends StatelessWidget {
  final ShopItem item;
  final bool isEditMode;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool doneToday;

  const ShopCard({
    super.key,
    required this.item,
    required this.isEditMode,
    required this.onTap,
    required this.onDelete,
    this.doneToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(item.id),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: doneToday ? const Color(0xFFEF9A9A) : Colors.white,
      child: InkWell(
        onTap: isEditMode ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: doneToday
                        ? const Color(0xFFC62828)
                        : const Color(0xFF43A047),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                doneToday ? 'Куплено' : '-${item.points}',
                style: TextStyle(
                  fontSize: 22,
                  color: doneToday
                      ? const Color(0xFFC62828)
                      : const Color(0xFFD32F2F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditMode) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFFD32F2F)),
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
