import 'package:depi_project/modules/product.module.dart';
import 'package:depi_project/service/product.service.dart';
import 'package:depi_project/views/widgets/product_header.dart';
import 'package:flutter/material.dart';

class ProductScreenBuilder extends StatefulWidget {
  final String barcode;

  const ProductScreenBuilder({super.key, required this.barcode});

  @override
  State<ProductScreenBuilder> createState() => _ProductScreenBuilderState();
}

class _ProductScreenBuilderState extends State<ProductScreenBuilder> {
  late final Future<ProductsModel> future;

  @override
  void initState() {
    super.initState();
    future = ProductService().getProduct(barcode: widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductsModel>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data!;
          return ProductScreen(product: product);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});
  final ProductsModel product;

  @override
  Widget build(BuildContext context) {
    final calories = product.product?.nutriments?.energyKcal100G ?? 0;
    final fat = product.product?.nutriments?.fat100G ?? 0;
    final carbs = product.product?.nutriments?.carbohydrates100G ?? 0;
    final sugar = product.product?.nutriments?.sugars100G ?? 0;
    final protein = product.product?.nutriments?.proteins100G ?? 0;
    final salt = product.product?.nutriments?.salt100G ?? 0;
    final sodium = product.product?.nutriments?.sodium100G ?? 0;
    final image = product.product?.imageUrl;
    final allergens = product.product?.allergensTags ?? [];
    final brand = product.product?.brands ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          // Simply pop to return to the previous screen on the navigation stack.
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.black,
        ),
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //@widget product header
              ProductHeader(image: image, product: product, brand: brand),

              // Favorite Button
              SizedBox(height: 20),
              //@widget product details
              IngredientsWidget(product: product),
              //@widget nutrition information
              SizedBox(height: 10),
              Nutrition(
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                sugar: sugar,
                salt: salt,
                sodium: sodium,
              ),
              SizedBox(height: 10),

              Allergeis(allergens: allergens),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientsWidget extends StatelessWidget {
  const IngredientsWidget({super.key, required this.product});

  final ProductsModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list, color: Colors.green, size: 24),
              SizedBox(width: 12),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Text(
                product.product?.ingredientsText ??
                    'No ingredients information available',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Nutrition extends StatelessWidget {
  const Nutrition({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.sugar,
    required this.salt,
    required this.sodium,
  });

  final num calories;
  final num protein;
  final num carbs;
  final num fat;
  final num sugar;
  final num salt;
  final num sodium;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant, color: Colors.orange, size: 24),
              SizedBox(width: 12),
              Text(
                'Nutritional Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Column(
            children: [
              _NutritionBar(
                label: 'Calories',
                value: calories.toDouble(),
                maxValue: 1100,
                unit: 'c',
              ),
              _NutritionBar(
                label: 'Protein',
                value: protein.toDouble(),
                maxValue: 100,
              ),
              _NutritionBar(
                label: 'Carbs',
                value: carbs.toDouble(),
                maxValue: 100,
              ),
              _NutritionBar(label: 'Fat', value: fat.toDouble(), maxValue: 100),
              _NutritionBar(
                label: 'Fiber',
                value: (carbs - sugar).toDouble().clamp(0, 100),
                maxValue: 100,
              ),
              _NutritionBar(
                label: 'Sugar',
                value: sugar.toDouble(),
                maxValue: 100,
              ),
              _NutritionBar(
                label: 'Salt',
                value: salt.toDouble(),
                maxValue: 100,
              ),
              _NutritionBar(
                label: 'Sodium',
                value: sodium.toDouble(),
                maxValue: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutritionBar extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final String? unit;

  const _NutritionBar({
    required this.label,
    required this.value,
    required this.maxValue,
    this.unit = 'g',
  });

  @override
  Widget build(BuildContext context) {
    final percentage = value / maxValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 20,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getColorForNutrient(label),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            '${value.toStringAsFixed(1)} $unit',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForNutrient(String nutrient) {
    switch (nutrient) {
      case 'Calories':
        return Colors.amber;
      case 'Protein':
        return Colors.green;
      case 'Carbs':
        return Colors.orange;
      case 'Fat':
        return Colors.red;
      case 'Fiber':
        return Colors.purple;
      case 'Sugar':
        return Colors.pink;
      case 'Salt':
        return Colors.brown;
      case 'Sodium':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }
}

class Allergeis extends StatelessWidget {
  const Allergeis({super.key, required this.allergens});

  final List<String> allergens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
              SizedBox(width: 12),
              Text(
                'Allergen Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          allergens.isEmpty
              ? Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No known allergens detected',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allergens.map((allergen) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            border: Border.all(
                              color: Colors.red[300]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close, color: Colors.red, size: 16),
                              SizedBox(width: 6),
                              Text(
                                allergen
                                    .replaceFirst(RegExp(r'^en:'), '')
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
