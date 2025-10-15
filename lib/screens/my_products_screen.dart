import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/screens/add_product_screen.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<Map<String, dynamic>> products = [
    {
      'id': '1',
      'name': 'Tomates ecológicos',
      'category': 'Verduras',
      'price': 2.50,
      'unit': 'kg',
      'stock': 50,
      'image': 'assets/images/logo.png',
      'isActive': true,
      'views': 45,
      'messages': 12,
    },
    {
      'id': '2',
      'name': 'Zanahorias frescas',
      'category': 'Verduras',
      'price': 1.80,
      'unit': 'kg',
      'stock': 0,
      'image': 'assets/images/logo.png',
      'isActive': false,
      'views': 32,
      'messages': 8,
    },
    {
      'id': '3',
      'name': 'Lechugas romanas',
      'category': 'Hortalizas',
      'price': 1.20,
      'unit': 'unidad',
      'stock': 30,
      'image': 'assets/images/logo.png',
      'isActive': true,
      'views': 67,
      'messages': 15,
    },
    {
      'id': '4',
      'name': 'Naranjas valencianas',
      'category': 'Frutas',
      'price': 2.00,
      'unit': 'kg',
      'stock': 100,
      'image': 'assets/images/logo.png',
      'isActive': true,
      'views': 89,
      'messages': 23,
    },
  ];

  String _selectedFilter = 'Todos';

  List<Map<String, dynamic>> get filteredProducts {
    if (_selectedFilter == 'Activos') {
      return products.where((p) => p['isActive'] == true && p['stock'] > 0).toList();
    } else if (_selectedFilter == 'Pausados') {
      return products.where((p) => p['isActive'] == false || p['stock'] == 0).toList();
    }
    return products;
  }

  void _toggleProductStatus(String productId) {
    setState(() {
      final product = products.firstWhere((p) => p['id'] == productId);
      product['isActive'] = !product['isActive'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          products.firstWhere((p) => p['id'] == productId)['isActive']
              ? 'Producto activado'
              : 'Producto pausado',
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _deleteProduct(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar producto', style: AppTextStyles.subheadline),
        content: Text(
          '¿Estás seguro de que quieres eliminar este producto?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                products.removeWhere((p) => p['id'] == productId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Producto eliminado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Eliminar',
              style: AppTextStyles.body.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editProduct(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de edición en desarrollo'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = products.where((p) => p['isActive'] == true && p['stock'] > 0).length;
    final pausedCount = products.where((p) => p['isActive'] == false || p['stock'] == 0).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mis Productos',
          style: AppTextStyles.subheadline,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total',
                        '${products.length}',
                        AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Activos',
                        '$activeCount',
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Pausados',
                        '$pausedCount',
                        AppColors.accentOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildFilterChip('Todos'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Activos'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pausados'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay productos',
                          style: AppTextStyles.subheadline.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Publica tu primer producto',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _buildProductCard(product);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add),
        label: Text(
          'Nuevo producto',
          style: AppTextStyles.buttonText,
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headline.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySecondary.copyWith(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final isActive = product['isActive'] == true && product['stock'] > 0;
    final isOutOfStock = product['stock'] == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(product['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (!isActive)
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            isOutOfStock ? 'Agotado' : 'Pausado',
                            style: AppTextStyles.bodySecondary.copyWith(
                              color: AppColors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product['name'],
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primaryGreen.withOpacity(0.1)
                                  : AppColors.accentOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isActive ? 'Activo' : (isOutOfStock ? 'Agotado' : 'Pausado'),
                              style: AppTextStyles.bodySecondary.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isActive ? AppColors.primaryGreen : AppColors.accentOrange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['category'],
                        style: AppTextStyles.bodySecondary,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '€${product['price'].toStringAsFixed(2)}',
                            style: AppTextStyles.subheadline.copyWith(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          Text(
                            ' /${product['unit']}',
                            style: AppTextStyles.bodySecondary,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${product['stock']} ${product['unit']}',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.visibility_outlined,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${product['views']} vistas',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.message_outlined,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${product['messages']} mensajes',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _editProduct(product),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Editar',
                            style: AppTextStyles.bodySecondary.copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _toggleProductStatus(product['id']),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                            size: 18,
                            color: AppColors.accentOrange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isActive ? 'Pausar' : 'Activar',
                            style: AppTextStyles.bodySecondary.copyWith(
                              color: AppColors.accentOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _deleteProduct(product['id']),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Eliminar',
                            style: AppTextStyles.bodySecondary.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}