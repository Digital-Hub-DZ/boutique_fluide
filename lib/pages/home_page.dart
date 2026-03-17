import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:boutique_fluide/models/product.dart';
import 'package:boutique_fluide/services/product_service.dart';
import 'package:boutique_fluide/theme.dart';
import 'package:boutique_fluide/widgets/filter_modal.dart';
import 'package:boutique_fluide/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchSocial(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onItemTapped(int index) async {
    if (index == 0) {
      setState(() => _selectedIndex = 0);
      return;
    }

    if (index == 1) {
      context.push('/admin');
      return;
    }

    if (index == 2) {
      await _launchSocial('https://facebook.com');
      return;
    }

    if (index == 3) {
      await _launchSocial('https://instagram.com');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ProductService>();
    final products = service.filteredProducts;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeHeader(
                controller: _searchController,
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const FilterModal(),
                  );
                },
                onSearchChanged: (value) => context.read<ProductService>().search(value),
              ),
            ),
            SliverToBoxAdapter(child: CategoryTabs(selected: service.selectedCategory)),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
            if (products.isEmpty)
              const SliverFillRemaining(hasScrollBody: false, child: EmptyProductsState())
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(product: products[index]),
                    childCount: products.length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            SliverToBoxAdapter(
              child: HomeFooter(
                onFacebookTap: () => _launchSocial('https://facebook.com'),
                onInstagramTap: () => _launchSocial('https://instagram.com'),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.midnight,
        unselectedItemColor: AppColors.charcoal.withValues(alpha: 0.70),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'Boutique'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings_outlined), activeIcon: Icon(Icons.admin_panel_settings), label: 'Admin'),
          BottomNavigationBarItem(icon: Icon(Icons.facebook), label: 'Facebook'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), label: 'Instagram'),
        ],
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onSearchChanged;

  const HomeHeader({super.key, required this.controller, required this.onFilterTap, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Boutique Fluide', style: theme.textTheme.displaySmall),
              RoundIconButton(icon: Icons.tune, onTap: onFilterTap, tooltip: 'Filtres'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Rechercher un produit…',
              prefixIcon: Icon(Icons.search, color: AppColors.charcoal),
            ),
            onChanged: onSearchChanged,
          ),
        ],
      ),
    );
  }
}

class CategoryTabs extends StatelessWidget {
  final ProductCategory? selected;

  const CategoryTabs({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    final service = context.read<ProductService>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          CategoryChip(label: 'Tout', isSelected: selected == null, onTap: () => service.setCategory(null)),
          const SizedBox(width: AppSpacing.sm),
          CategoryChip(label: 'Hommes', isSelected: selected == ProductCategory.men, onTap: () => service.setCategory(ProductCategory.men)),
          const SizedBox(width: AppSpacing.sm),
          CategoryChip(label: 'Femmes', isSelected: selected == ProductCategory.women, onTap: () => service.setCategory(ProductCategory.women)),
          const SizedBox(width: AppSpacing.sm),
          CategoryChip(label: 'Enfants', isSelected: selected == ProductCategory.kids, onTap: () => service.setCategory(ProductCategory.kids)),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.midnight : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: isSelected ? AppColors.midnight : AppColors.charcoal.withValues(alpha: 0.18)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.midnight.withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.pureWhite : AppColors.midnight,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class EmptyProductsState extends StatelessWidget {
  const EmptyProductsState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 62, color: AppColors.charcoal.withValues(alpha: 0.70)),
          const SizedBox(height: AppSpacing.md),
          Text('Aucun produit trouvé', style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Essayez un autre terme de recherche ou ajustez les filtres.',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.charcoal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class HomeFooter extends StatelessWidget {
  final VoidCallback onFacebookTap;
  final VoidCallback onInstagramTap;

  const HomeFooter({super.key, required this.onFacebookTap, required this.onInstagramTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.charcoal.withValues(alpha: 0.10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.midnight.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Suivez-nous', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Nouveautés, offres et inspirations.',
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.charcoal),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                SocialIconLink(icon: Icons.facebook, label: 'Facebook', onTap: onFacebookTap),
                const SizedBox(width: AppSpacing.md),
                SocialIconLink(icon: Icons.camera_alt_outlined, label: 'Instagram', onTap: onInstagramTap),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '© ${DateTime.now().year} Boutique Fluide',
              style: theme.textTheme.labelSmall?.copyWith(color: AppColors.charcoal),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialIconLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SocialIconLink({super.key, required this.icon, required this.label, required this.onTap});

  @override
  State<SocialIconLink> createState() => _SocialIconLinkState();
}

class _SocialIconLinkState extends State<SocialIconLink> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: _pressed ? 0.98 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.warmBeige,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.charcoal.withValues(alpha: 0.16)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: AppColors.midnight, size: 20),
              const SizedBox(width: 10),
              Text(widget.label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.midnight)),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const RoundIconButton({super.key, required this.icon, required this.onTap, required this.tooltip});

  @override
  State<RoundIconButton> createState() => _RoundIconButtonState();
}

class _RoundIconButtonState extends State<RoundIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 140),
          scale: _pressed ? 0.97 : 1.0,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.charcoal.withValues(alpha: 0.12)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.midnight.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(widget.icon, color: AppColors.midnight),
          ),
        ),
      ),
    );
  }
}
