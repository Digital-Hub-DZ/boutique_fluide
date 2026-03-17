import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:boutique_fluide/services/admin_auth_service.dart';
import 'package:boutique_fluide/services/product_service.dart';
import 'package:boutique_fluide/theme.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ProductService>();
    final products = service.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AdminAuthService>().signOut();
              if (context.mounted) context.go('/');
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/admin/add'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final product = products[index];
          return Dismissible(
            key: Key(product.id),
            background: Container(
              color: AppColors.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: const Icon(Icons.delete, color: AppColors.pureWhite),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Supprimer ?'),
                  content: Text('Voulez-vous vraiment supprimer "${product.name}" ?'),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(false),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () => context.pop(true),
                      child: const Text('Supprimer', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              service.deleteProduct(product.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} supprimé')),
              );
            },
            child: Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) => 
                      Container(width: 50, height: 50, color: Colors.grey),
                  ),
                ),
                title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${product.price}€ • Stock: ${product.stock}',
                  style: const TextStyle(color: AppColors.charcoal),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.midnight),
                  onPressed: () => context.push('/admin/edit/${product.id}'),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/admin/add'),
        backgroundColor: AppColors.midnight,
        child: const Icon(Icons.add, color: AppColors.pureWhite),
      ),
    );
  }
}
