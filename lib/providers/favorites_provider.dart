import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A simple model to store favorite product data
class FavoriteProduct {
  final String code;
  final String name;
  final String brand;
  final String? imageUrl;
  final String nutriscoreGrade;
  final DateTime addedAt;

  FavoriteProduct({
    required this.code,
    required this.name,
    required this.brand,
    this.imageUrl,
    required this.nutriscoreGrade,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'brand': brand,
    'imageUrl': imageUrl,
    'nutriscoreGrade': nutriscoreGrade,
    'addedAt': addedAt.toIso8601String(),
  };

  factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      imageUrl: json['imageUrl'],
      nutriscoreGrade: json['nutriscoreGrade'] ?? '',
      addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class FavoritesProvider extends ChangeNotifier {
  final Map<String, FavoriteProduct> _favorites = {};
  String? _currentUserId;

  /// Get all favorites as a list
  List<FavoriteProduct> get favorites => _favorites.values.toList();

  /// Get favorites count
  int get favoritesCount => _favorites.length;

  /// Check if a product is in favorites
  bool isFavorite(String productCode) {
    return _favorites.containsKey(productCode);
  }

  /// Get storage key for user
  String _getStorageKey(String? userId) {
    return 'favorites_${userId ?? 'guest'}';
  }

  /// Load favorites from local storage for a specific user
  Future<void> loadFavorites(String? userId) async {
    _currentUserId = userId;
    _favorites.clear();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getStorageKey(userId);
      final String? favoritesJson = prefs.getString(key);
      
      if (favoritesJson != null) {
        final List<dynamic> favoritesList = jsonDecode(favoritesJson);
        for (var item in favoritesList) {
          final product = FavoriteProduct.fromJson(item);
          _favorites[product.code] = product;
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      notifyListeners();
    }
  }

  /// Save favorites to local storage
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getStorageKey(_currentUserId);
      final favoritesList = _favorites.values.map((f) => f.toJson()).toList();
      await prefs.setString(key, jsonEncode(favoritesList));
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  /// Add a product to favorites
  void addFavorite({
    required String code,
    required String name,
    required String brand,
    String? imageUrl,
    required String nutriscoreGrade,
  }) {
    if (!_favorites.containsKey(code)) {
      _favorites[code] = FavoriteProduct(
        code: code,
        name: name,
        brand: brand,
        imageUrl: imageUrl,
        nutriscoreGrade: nutriscoreGrade,
        addedAt: DateTime.now(),
      );
      notifyListeners();
      _saveFavorites();
    }
  }

  /// Remove a product from favorites
  void removeFavorite(String productCode) {
    if (_favorites.containsKey(productCode)) {
      _favorites.remove(productCode);
      notifyListeners();
      _saveFavorites();
    }
  }

  /// Toggle favorite status
  void toggleFavorite({
    required String code,
    required String name,
    required String brand,
    String? imageUrl,
    required String nutriscoreGrade,
  }) {
    if (_favorites.containsKey(code)) {
      removeFavorite(code);
    } else {
      addFavorite(
        code: code,
        name: name,
        brand: brand,
        imageUrl: imageUrl,
        nutriscoreGrade: nutriscoreGrade,
      );
    }
  }

  /// Clear all favorites
  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
    _saveFavorites();
  }

  /// Clear favorites when user logs out
  void onUserLogout() {
    _favorites.clear();
    _currentUserId = null;
    notifyListeners();
  }
}
