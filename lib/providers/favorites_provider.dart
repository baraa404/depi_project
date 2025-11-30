import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all favorites as a list
  List<FavoriteProduct> get favorites => _favorites.values.toList();

  /// Get favorites count
  int get favoritesCount => _favorites.length;

  /// Check if a product is in favorites
  bool isFavorite(String productCode) {
    return _favorites.containsKey(productCode);
  }

  /// Load favorites from Firestore for a specific user
  Future<void> loadFavorites(String? userId) async {
    print("FavoritesProvider: Loading favorites for user: $userId");
    _currentUserId = userId;
    _favorites.clear();

    if (userId == null) {
      notifyListeners();
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      print("FavoritesProvider: Found ${snapshot.docs.length} favorites");
      for (var doc in snapshot.docs) {
        final product = FavoriteProduct.fromJson(doc.data());
        _favorites[product.code] = product;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      notifyListeners();
    }
  }

  /// Add a product to favorites
  Future<void> addFavorite({
    required String code,
    required String name,
    required String brand,
    String? imageUrl,
    required String nutriscoreGrade,
  }) async {
    if (!_favorites.containsKey(code)) {
      final product = FavoriteProduct(
        code: code,
        name: name,
        brand: brand,
        imageUrl: imageUrl,
        nutriscoreGrade: nutriscoreGrade,
        addedAt: DateTime.now(),
      );

      _favorites[code] = product;
      notifyListeners();

      print(
        "FavoritesProvider: Adding favorite $code. UserID: $_currentUserId",
      );
      if (_currentUserId != null) {
        try {
          await _firestore
              .collection('users')
              .doc(_currentUserId)
              .collection('favorites')
              .doc(code)
              .set(product.toJson());
          print("FavoritesProvider: Saved favorite to Firestore");
        } catch (e) {
          debugPrint('Error adding favorite: $e');
        }
      } else {
        print("FavoritesProvider: UserID is null, NOT saving to Firestore");
      }
    }
  }

  /// Remove a product from favorites
  Future<void> removeFavorite(String productCode) async {
    if (_favorites.containsKey(productCode)) {
      _favorites.remove(productCode);
      notifyListeners();

      if (_currentUserId != null) {
        try {
          await _firestore
              .collection('users')
              .doc(_currentUserId)
              .collection('favorites')
              .doc(productCode)
              .delete();
        } catch (e) {
          debugPrint('Error removing favorite: $e');
        }
      }
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite({
    required String code,
    required String name,
    required String brand,
    String? imageUrl,
    required String nutriscoreGrade,
  }) async {
    if (_favorites.containsKey(code)) {
      await removeFavorite(code);
    } else {
      await addFavorite(
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
    // Note: We don't delete from Firestore here to avoid accidental data loss
    // or complex batch deletes unless explicitly requested.
  }

  /// Clear favorites when user logs out
  void onUserLogout() {
    _favorites.clear();
    _currentUserId = null;
    notifyListeners();
  }
}
