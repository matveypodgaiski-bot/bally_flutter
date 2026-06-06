import 'package:flutter/material.dart';
import '../models/transaction.dart';

class JournalCard extends StatelessWidget {
  final Transaction transaction;

  const JournalCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Text(
                transaction.name,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF43A047),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              transaction.points > 0
                  ? '+${transaction.points}'
                  : '${transaction.points}',
              style: TextStyle(
                fontSize: 22,
                color: transaction.points > 0
                    ? const Color(0xFF389E13)
                    : const Color(0xFFD32F2F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
