import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/colors.dart';

class IngredientTile extends StatelessWidget {
  final String ingredient;
  final bool isSelected;
  final VoidCallback onTap;

  const IngredientTile({
    super.key,
    required this.ingredient,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySage.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primarySage : Colors.black.withOpacity(0.05),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primarySage : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primarySage : Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Icon(
                LucideIcons.check,
                size: 14,
                color: isSelected ? Colors.white : Colors.transparent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                ingredient,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primarySage : AppColors.softCharcoal,
                  decoration: isSelected ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
