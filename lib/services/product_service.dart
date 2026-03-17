import 'package:flutter/material.dart';
import 'package:boutique_fluide/models/product.dart';

class ProductService extends ChangeNotifier {
  // ── Sample catalogue ────────────────────────────────────────────────────────
  final List<Product> _all = [
    Product(
      id: '1',
      name: 'Chemise Lin Homme',
      description: 'Chemise en lin naturel, coupe droite, idéale pour l\'été. Respirante et élégante.',
      price: 49.99,
      stock: 12,
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600',
      category: ProductCategory.men,
      saleType: SaleType.retail,
    ),
    Product(
      id: '2',
      name: 'Jean Slim Homme',
      description: 'Jean slim stretch confortable, coupe moderne. Disponible en bleu et noir.',
      price: 69.99,
      stock: 8,
      imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=600',
      category: ProductCategory.men,
      saleType: SaleType.retail,
    ),
    Product(
      id: '3',
      name: 'Robe Fleurie Femme',
      description: 'Robe légère à motifs fleuris, parfaite pour les journées ensoleillées.',
      price: 59.99,
      stock: 5,
      imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=600',
      category: ProductCategory.women,
      saleType: SaleType.retail,
    ),
    Product(
      id: '4',
      name: 'Blazer Femme Classic',
      description: 'Blazer structuré pour un look professionnel et élégant au quotidien.',
      price: 89.99,
      stock: 3,
      imageUrl: 'https://images.unsplash.com/photo-1594938298603-c8148c4b9691?w=600',
      category: ProductCategory.women,
      saleType: SaleType.wholesale,
    ),
    Product(
      id: '5',
      name: 'T-shirt Enfant Coton',
      description: 'T-shirt 100% coton doux, lavable en machine. Plusieurs coloris disponibles.',
      price: 15.99,
      stock: 20,
      imageUrl: 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=600',
      category: ProductCategory.kids,
      saleType: SaleType.retail,
    ),
    Product(
      id: '6',
      name: 'Pantalon Enfant Sport',
      description: 'Pantalon de sport léger et résistant, avec élastique à la taille.',
      price: 24.99,
      stock: 15,
      imageUrl: 'https://images.unsplash.com/photo-1522771930-78848d9293e8?w=600',
      category: ProductCategory.kids,
      saleType: SaleType.retail,
    ),
    Product(
      id: '7',
      name: 'Polo Homme Premium',
      description: 'Polo en piqué de coton, broderie discrète sur la poitrine. Coupe semi-ajustée.',
      price: 44.99,
      stock: 0,
      imageUrl: 'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=600',
      category: ProductCategory.men,
      saleType: SaleType.wholesale,
    ),
    Product(
      id: '8',
      name: 'Jupe Midi Femme',
      description: 'Jupe midi en tissu fluide, taille élastique. Élégante et confortable.',
      price: 39.99,
      stock: 7,
      imageUrl: 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=600',
      category: ProductCategory.women,
      saleType: SaleType.retail,
    ),
  ];

  // ── State ────────────────────────────────────────────────────────────────────
  String _query = '';
  ProductCategory? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;
  SaleType? _saleTypeFilter;

  // ── Getters ──────────────────────────────────────────────────────────────────
  List<Product> get products => List.unmodifiable(_all);

  ProductCategory? get selectedCategory => _selectedCategory;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  SaleType? get saleTypeFilter => _saleTypeFilter;

  List<Product> get filteredProducts {
    return _all.where((p) {
      if (_selectedCategory != null && p.category != _selectedCategory) return false;
      if (_query.isNotEmpty &&
          !p.name.toLowerCase().contains(_query.toLowerCase()) &&
          !p.description.toLowerCase().contains(_query.toLowerCase())) return false;
      if (_minPrice != null && p.price < _minPrice!) return false;
      if (_maxPrice != null && p.price > _maxPrice!) return false;
      if (_saleTypeFilter != null && p.saleType != _saleTypeFilter) return false;
      return true;
    }).toList();
  }

  Product? getProductById(String id) {
    try {
      return _all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Mutations ────────────────────────────────────────────────────────────────
  void addProduct(Product product) {
    _all.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _all.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _all[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _all.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ── Filters ──────────────────────────────────────────────────────────────────
  void search(String query) {
    _query = query;
    notifyListeners();
  }

  void setCategory(ProductCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setSaleType(SaleType? type) {
    _saleTypeFilter = type;
    notifyListeners();
  }

  void clearFilters() {
    _query = '';
    _selectedCategory = null;
    _minPrice = null;
    _maxPrice = null;
    _saleTypeFilter = null;
    notifyListeners();
  }
}
