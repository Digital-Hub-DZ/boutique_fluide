import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:boutique_fluide/services/product_service.dart';
import 'package:boutique_fluide/models/product.dart';
import 'package:boutique_fluide/theme.dart';

class EditProductPage extends StatefulWidget {
  final String? productId; // null for Add, set for Edit

  const EditProductPage({super.key, this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  
  late String _name;
  late String _description;
  late double _price;
  late int _stock;
  late String _imageUrl;
  late ProductCategory _category;
  late SaleType _saleType;

  @override
  void initState() {
    super.initState();
    final service = context.read<ProductService>();
    if (widget.productId != null) {
      final product = service.getProductById(widget.productId!);
      if (product != null) {
        _name = product.name;
        _description = product.description;
        _price = product.price;
        _stock = product.stock;
        _imageUrl = product.imageUrl;
        _category = product.category;
        _saleType = product.saleType;
      } else {
        // Fallback or error
        _initDefaults();
      }
    } else {
      _initDefaults();
    }
  }

  void _initDefaults() {
    _name = '';
    _description = '';
    _price = 0.0;
    _stock = 0;
    _imageUrl = 'https://via.placeholder.com/300';
    _category = ProductCategory.women;
    _saleType = SaleType.retail;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final service = context.read<ProductService>();
      
      final product = Product(
        id: widget.productId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        description: _description,
        price: _price,
        stock: _stock,
        imageUrl: _imageUrl,
        category: _category,
        saleType: _saleType,
      );

      if (widget.productId != null) {
        service.updateProduct(product);
      } else {
        service.addProduct(product);
      }
      
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productId != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier le produit' : 'Ajouter un produit'),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'Sauvegarder',
              style: TextStyle(
                color: AppColors.midnight,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Nom du produit'),
              validator: (v) => v!.isEmpty ? 'Requis' : null,
              onSaved: (v) => _name = v!,
            ),
            const SizedBox(height: AppSpacing.md),
            
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Requis' : null,
              onSaved: (v) => _description = v!,
            ),
            const SizedBox(height: AppSpacing.md),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _price.toString(),
                    decoration: const InputDecoration(labelText: 'Prix (€)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => double.tryParse(v!) == null ? 'Invalide' : null,
                    onSaved: (v) => _price = double.parse(v!),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    initialValue: _stock.toString(),
                    decoration: const InputDecoration(labelText: 'Stock'),
                    keyboardType: TextInputType.number,
                    validator: (v) => int.tryParse(v!) == null ? 'Invalide' : null,
                    onSaved: (v) => _stock = int.parse(v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            
            TextFormField(
              initialValue: _imageUrl,
              decoration: const InputDecoration(labelText: "URL de l'image"),
              onSaved: (v) => _imageUrl = v!.isEmpty ? 'https://via.placeholder.com/300' : v,
            ),
            const SizedBox(height: AppSpacing.md),
            
            DropdownButtonFormField<ProductCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Catégorie'),
              items: ProductCategory.values.map((c) {
                final label = switch (c) {
                  ProductCategory.men => 'Hommes',
                  ProductCategory.women => 'Femmes',
                  ProductCategory.kids => 'Enfants',
                };
                return DropdownMenuItem(
                  value: c,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: AppSpacing.md),
            
            DropdownButtonFormField<SaleType>(
              value: _saleType,
              decoration: const InputDecoration(labelText: 'Type de Vente'),
              items: SaleType.values.map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Text(t == SaleType.retail ? 'Détail' : 'Gros'),
                );
              }).toList(),
              onChanged: (v) => setState(() => _saleType = v!),
            ),
          ],
        ),
      ),
    );
  }
}
