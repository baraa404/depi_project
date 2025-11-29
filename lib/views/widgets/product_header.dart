import 'package:depi_project/modules/product.module.dart';
import 'package:depi_project/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({
    super.key,
    required this.image,
    required this.product,
    required this.brand,
  });

  final String? image;
  final ProductsModel product;
  final String brand;

  @override
  Widget build(BuildContext context) {
    final nutriscoreGrade = product.product?.nutriscoreGrade ?? '';
    final ecoscoreGrade = product.product?.ecoscoreGrade ?? '';
    final novaGroup = product.product?.novaGroup ?? 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Image + Info + Favorite
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Hero(
                  tag: 'product_${product.code}',
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: image != null && image!.isNotEmpty
                          ? Image.network(
                              image!,
                              fit: BoxFit.fitHeight,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                        strokeWidth: 3,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.fastfood,
                                    size: 50,
                                    color: Colors.grey.shade400,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.fastfood,
                                size: 50,
                                color: Colors.grey.shade400,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand Badge
                      const SizedBox(height: 8),
                      Text(
                        product.product?.productName ?? 'Unknown Product',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[900],
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Quantity
                      if (product.product?.quantity.isNotEmpty ?? false)
                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.product?.quantity ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      if (brand.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            brand.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Favorite Button
                Consumer<FavoritesProvider>(
                  builder: (context, favoritesProvider, child) {
                    final isFavorite = favoritesProvider.isFavorite(product.code);
                    return Container(
                      decoration: BoxDecoration(
                        color: isFavorite ? Colors.red.shade50 : Colors.grey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          favoritesProvider.toggleFavorite(
                            code: product.code,
                            name: product.product?.productName ?? 'Unknown Product',
                            brand: brand,
                            imageUrl: image,
                            nutriscoreGrade: product.product?.nutriscoreGrade ?? '',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Removed from favorites'
                                    : 'Added to favorites',
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        color: Colors.red.shade400,
                        iconSize: 22,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Scores Section with Linear Indicators
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                // Nutri-Score
                if (nutriscoreGrade.isNotEmpty)
                  _LinearScoreIndicator(
                    label: 'Nutri-Score',
                    emoji: '⚖️',
                    grade: nutriscoreGrade.toUpperCase(),
                    color: _getNutriscoreColor(nutriscoreGrade),
                    type: ScoreType.letter,
                  ),
                if (nutriscoreGrade.isNotEmpty && ecoscoreGrade.isNotEmpty)
                  const SizedBox(height: 12),

                // Eco-Score
                if (ecoscoreGrade.isNotEmpty)
                  _LinearScoreIndicator(
                    label: 'Eco-Score',
                    emoji: '🌍',
                    grade: ecoscoreGrade.toUpperCase(),
                    color: _getEcoscoreColor(ecoscoreGrade),
                    type: ScoreType.letter,
                  ),
                if (ecoscoreGrade.isNotEmpty && novaGroup > 0)
                  const SizedBox(height: 12),
                // NOVA Group
                if (novaGroup > 0)
                  _LinearScoreIndicator(
                    label: 'NOVA Group',
                    emoji: '🥕',
                    grade: novaGroup.toString(),
                    color: _getNovaColor(novaGroup.toInt()),
                    type: ScoreType.number,
                    maxValue: 4,
                    currentValue: novaGroup.toInt(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getNutriscoreColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'a':
        return const Color(0xFF038141);
      case 'b':
        return const Color(0xFF85BB2F);
      case 'c':
        return const Color(0xFFFECB02);
      case 'd':
        return const Color(0xFFEE8100);
      case 'e':
        return const Color(0xFFE63E11);
      default:
        return Colors.grey;
    }
  }

  Color _getEcoscoreColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'a':
        return const Color(0xFF008059);
      case 'b':
        return const Color(0xFF51AA1E);
      case 'c':
        return const Color(0xFFFECB02);
      case 'd':
        return const Color(0xFFEE8100);
      case 'e':
        return const Color(0xFFE63E11);
      default:
        return Colors.grey;
    }
  }

  Color _getNovaColor(int group) {
    switch (group) {
      case 1:
        return const Color(0xFF4CAF50);
      case 2:
        return const Color(0xFFFBC02D);
      case 3:
        return const Color(0xFFFF9800);
      case 4:
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }
}

enum ScoreType { letter, number }

class _LinearScoreIndicator extends StatelessWidget {
  final String label;
  final String emoji;
  final String grade;
  final Color color;
  final ScoreType type;
  final int? maxValue;
  final int? currentValue;

  const _LinearScoreIndicator({
    required this.label,
    required this.emoji,
    required this.grade,
    required this.color,
    required this.type,
    this.maxValue,
    this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          // Emoji & Label
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),

          // Linear Progress Bar
          Expanded(
            child: type == ScoreType.letter
                ? _buildLetterBar()
                : _buildNumberBar(),
          ),

          const SizedBox(width: 12),

          // Score Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              grade,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterBar() {
    final letters = ['A', 'B', 'C', 'D', 'E'];
    final colors = [
      const Color(0xFF038141),
      const Color(0xFF85BB2F),
      const Color(0xFFFECB02),
      const Color(0xFFEE8100),
      const Color(0xFFE63E11),
    ];

    final currentIndex = letters.indexOf(grade);

    return Row(
      children: List.generate(5, (index) {
        final isActive = index == currentIndex;
        return Expanded(
          child: Container(
            height: 8,
            margin: EdgeInsets.only(right: index < 4 ? 2 : 0),
            decoration: BoxDecoration(
              color: isActive ? colors[index] : colors[index].withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNumberBar() {
    if (maxValue == null || currentValue == null) return const SizedBox();

    final progress = currentValue! / maxValue!;

    return Stack(
      children: [
        // Background
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        // Progress
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}
