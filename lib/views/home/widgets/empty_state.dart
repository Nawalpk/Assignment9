import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../product_form/product_form_screen.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.skeleton.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 56,
                  color: AppColors.textMuted.withValues(alpha: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'No products found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your workspace is currently a clean\nslate. Start by adding your first\nproduct to the repository.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProductFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 26, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
