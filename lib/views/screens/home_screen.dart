import 'package:depi_project/providers/favorites_provider.dart';
import 'package:depi_project/views/screens/favorites_screen.dart';
import 'package:depi_project/views/screens/prodcut_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Healthy Scan'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Hero Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/4.png',
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Food Knowledge',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'NOVA · Nutri · Eco',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Info Cards
              Row(
                children: [
                  _buildInfoCard(
                    context,
                    emoji: '🥕',
                    title: 'NOVA',
                    subtitle: 'Processing',
                    color: Colors.orange.shade50,
                    dialogTitle: 'NOVA Groups',
                    content: buildNovaContent(),
                  ),
                  const SizedBox(width: 12),
                  _buildInfoCard(
                    context,
                    emoji: '⚖️',
                    title: 'Nutri-Score',
                    subtitle: 'Nutrition',
                    color: Colors.blue.shade50,
                    dialogTitle: 'Nutri-Score',
                    content: _buildNutriContent(),
                  ),
                  const SizedBox(width: 12),
                  _buildInfoCard(
                    context,
                    emoji: '🌍',
                    title: 'Eco-Score',
                    subtitle: 'Environment',
                    color: Colors.green.shade50,
                    dialogTitle: 'Eco-Score',
                    content: _buildEcoContent(),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Products Section (shows favorites if any)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Products',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Favorites List - Dynamic based on provider
              Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  final favorites = favoritesProvider.favorites;
                  
                  if (favorites.isEmpty) {
                    return _buildEmptyFavorites();
                  }
                  
                  // Show up to 3 favorites
                  final displayFavorites = favorites.take(3).toList();
                  
                  return Column(
                    children: [
                      ...displayFavorites.map((product) => _buildFavoriteItem(
                        context,
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductScreenBuilder(barcode: product.code),
                            ),
                          );
                        },
                        onRemove: () {
                          favoritesProvider.removeFavorite(product.code);
                        },
                      )),
                      if (favorites.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '+${favorites.length - 3} more favorites',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(
    BuildContext context, {
    required FavoriteProduct product,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.fastfood,
                                size: 24,
                                color: Colors.grey.shade400,
                              );
                            },
                          )
                        : Icon(
                            Icons.fastfood,
                            size: 24,
                            color: Colors.grey.shade400,
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name.isNotEmpty ? product.name : 'Unknown Product',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (product.brand.isNotEmpty)
                        Text(
                          product.brand,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),

                // Remove Button
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text('⭐', style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text(
            'No favorites yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan products and add them to favorites',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required String dialogTitle,
    required Widget content,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.5)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showInfoDialog(context, dialogTitle, content),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, Widget content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 450),
          child: SingleChildScrollView(child: content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Got it!',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNovaContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '🔬 How processed is the food?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        const InfoRow(
          grade: '1',
          emoji: '🟢',
          label: 'Unprocessed',
          example: 'Fruits, vegetables, eggs',
        ),
        const InfoRow(
          grade: '2',
          emoji: '🟡',
          label: 'Ingredients',
          example: 'Oil, butter, salt',
        ),
        const InfoRow(
          grade: '3',
          emoji: '🟠',
          label: 'Processed',
          example: 'Canned fish, cheese',
        ),
        const InfoRow(
          grade: '4',
          emoji: '🔴',
          label: 'Ultra-processed',
          example: 'Soda, chips, candy',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Text('💡', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Lower numbers are better',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutriContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '🍎 How healthy is the food?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        const InfoRow(
          grade: 'A',
          emoji: '🟢',
          label: 'Excellent',
          example: 'Very healthy',
        ),
        const InfoRow(
          grade: 'B',
          emoji: '🟡',
          label: 'Good',
          example: 'Good balance',
        ),
        const InfoRow(
          grade: 'C',
          emoji: '🟠',
          label: 'Fair',
          example: 'Average nutrition',
        ),
        const InfoRow(
          grade: 'D',
          emoji: '🟧',
          label: 'Poor',
          example: 'High sugar/salt',
        ),
        const InfoRow(
          grade: 'E',
          emoji: '🔴',
          label: 'Very Poor',
          example: 'Very unhealthy',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Text('💡', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Based on sugar, salt, fat, fiber & protein',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEcoContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '🌱 Environmental impact',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        const InfoRow(
          grade: 'A',
          emoji: '🟢',
          label: 'Very Low',
          example: 'Eco-friendly',
        ),
        const InfoRow(
          grade: 'B',
          emoji: '🟡',
          label: 'Low',
          example: 'Low impact',
        ),
        const InfoRow(
          grade: 'C',
          emoji: '🟠',
          label: 'Moderate',
          example: 'Average impact',
        ),
        const InfoRow(
          grade: 'D',
          emoji: '🟧',
          label: 'High',
          example: 'High emissions',
        ),
        const InfoRow(
          grade: 'E',
          emoji: '🔴',
          label: 'Very High',
          example: 'Major damage',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Text('💡', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Based on CO2, packaging & transport',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String grade;
  final String emoji;
  final String label;
  final String example;

  const InfoRow({super.key, 
    required this.grade,
    required this.emoji,
    required this.label,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                grade,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  example,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
