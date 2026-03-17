import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boutique_fluide/models/product.dart';
import 'package:boutique_fluide/services/product_service.dart';
import 'package:boutique_fluide/theme.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late TextEditingController _minController;
  late TextEditingController _maxController;
  SaleType? _saleType;

  @override
  void initState() {
    super.initState();
    final service = context.read<ProductService>();
    _minController =
        TextEditingController(text: service.minPrice?.toString() ?? '');
    _maxController =
        TextEditingController(text: service.maxPrice?.toString() ?? '');
    _saleType = service.saleTypeFilter;
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _apply() {
    final service = context.read<ProductService>();
    final min = double.tryParse(_minController.text);
    final max = double.tryParse(_maxController.text);
    service.setPriceRange(min, max);
    service.setSaleType(_saleType);
    Navigator.of(context).pop();
  }

  void _reset() {
    _minController.clear();
    _maxController.clear();
    setState(() => _saleType = null);
    context.read<ProductService>().clearFilters();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.charcoal.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),

          Text('Filtres', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.lg),

          // Price range
          Text('Fourchette de prix (€)',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Min',
                    hintText: '0',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _maxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Max',
                    hintText: '500',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Sale type
          Text('Type de vente', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _SaleTypeChip(
                label: 'Tous',
                selected: _saleType == null,
                onTap: () => setState(() => _saleType = null),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SaleTypeChip(
                label: 'Détail',
                selected: _saleType == SaleType.retail,
                onTap: () => setState(() => _saleType = SaleType.retail),
              ),
              const SizedBox(width: AppSpacing.sm),
              _SaleTypeChip(
                label: 'Gros',
                selected: _saleType == SaleType.wholesale,
                onTap: () => setState(() => _saleType = SaleType.wholesale),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: AppColors.charcoal.withValues(alpha: 0.30)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Réinitialiser',
                      style: TextStyle(color: AppColors.charcoal)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _apply,
                  child: const Text('Appliquer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SaleTypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SaleTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.midnight : AppColors.warmBeige,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.midnight
                : AppColors.charcoal.withValues(alpha: 0.20),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.pureWhite : AppColors.midnight,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
