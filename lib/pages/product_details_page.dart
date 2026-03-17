import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:boutique_fluide/services/product_service.dart';
import 'package:boutique_fluide/models/product.dart';
import 'package:boutique_fluide/theme.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  Future<void> _launchWhatsApp(BuildContext context, Product product) async {
    final phoneNumber = "33612345678"; // Example French number
    final message = "Bonjour, je suis intéressé par votre produit: ${product.name} au prix de ${product.price}€.";
    final url = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Impossible d'ouvrir WhatsApp")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = context.select<ProductService, Product?>(
      (service) => service.getProductById(productId)
    );

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Produit non trouvé')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.pureWhite.withValues(alpha: 0.82),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.midnight),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.midnight.withValues(alpha: 0.10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.midnight.withValues(alpha: 0.06),
                      blurRadius: 26,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${product.price.toStringAsFixed(2)} €',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.midnight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Tags
                    Row(
                      children: [
                        _Tag(text: product.saleType == SaleType.retail ? 'Détail' : 'Gros', color: AppColors.gold),
                        const SizedBox(width: AppSpacing.sm),
                        _Tag(
                          text: product.stock > 0 ? 'En stock (${product.stock})' : 'Rupture',
                          color: product.stock > 0 ? AppColors.success : AppColors.error,
                        ),
                        if (product.stock > 0 && product.stock <= 5) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _Tag(text: 'Stock limité', color: AppColors.terracotta),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                        color: AppColors.charcoal,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () => _launchWhatsApp(context, product),
                        icon: const Icon(Icons.chat_bubble_outline, color: AppColors.pureWhite),
                        label: const Text('Commander via WhatsApp'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whatsApp,
                          foregroundColor: AppColors.pureWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;

  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
