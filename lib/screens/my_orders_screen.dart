// lib/screens/my_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  String _selectedFilter = 'Todos';
  
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'PED-001',
      'farmerName': 'Granja Los Olivos',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'Pendiente',
      'total': 12.50,
      'items': [
        {'name': 'Tomates ecológicos', 'quantity': 3, 'unit': 'kg', 'price': 2.50},
        {'name': 'Lechugas', 'quantity': 5, 'unit': 'unidad', 'price': 1.20},
      ],
      'paymentMethod': 'Efectivo en mano',
    },
    {
      'id': 'PED-002',
      'farmerName': 'Huerto San Miguel',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Confirmado',
      'total': 8.40,
      'items': [
        {'name': 'Zanahorias frescas', 'quantity': 2, 'unit': 'kg', 'price': 1.80},
        {'name': 'Cebollas', 'quantity': 3, 'unit': 'kg', 'price': 1.50},
      ],
      'paymentMethod': 'Transferencia',
    },
    {
      'id': 'PED-003',
      'farmerName': 'Finca El Roble',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'Entregado',
      'total': 10.00,
      'items': [
        {'name': 'Naranjas valencianas', 'quantity': 5, 'unit': 'kg', 'price': 2.00},
      ],
      'paymentMethod': 'Efectivo en mano',
      'rating': 5,
    },
    {
      'id': 'PED-004',
      'farmerName': 'Agricultura Verde',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'status': 'Cancelado',
      'total': 8.60,
      'items': [
        {'name': 'Manzanas', 'quantity': 2, 'unit': 'kg', 'price': 2.20},
        {'name': 'Peras', 'quantity': 2, 'unit': 'kg', 'price': 2.10},
      ],
      'paymentMethod': 'Efectivo en mano',
    },
  ];

  final List<String> _filters = ['Todos', 'Pendiente', 'Confirmado', 'Entregado', 'Cancelado'];

  List<Map<String, dynamic>> get filteredOrders {
    if (_selectedFilter == 'Todos') {
      return _orders;
    }
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pendiente':
        return AppColors.accentOrange;
      case 'Confirmado':
        return Colors.blue;
      case 'Entregado':
        return AppColors.primaryGreen;
      case 'Cancelado':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pendiente':
        return Icons.schedule;
      case 'Confirmado':
        return Icons.check_circle_outline;
      case 'Entregado':
        return Icons.task_alt;
      case 'Cancelado':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 24) {
      if (difference.inHours < 1) {
        return 'Hace ${difference.inMinutes} minutos';
      }
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pedido ${order['id']}',
                                style: AppTextStyles.headline,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(order['date']),
                                style: AppTextStyles.bodySecondary,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getStatusIcon(order['status']),
                                  size: 16,
                                  color: _getStatusColor(order['status']),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  order['status'],
                                  style: AppTextStyles.bodySecondary.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(order['status']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.lightGreen.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.store,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order['farmerName'],
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Agricultor local',
                                    style: AppTextStyles.bodySecondary,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline),
                              color: AppColors.primaryGreen,
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Abrir chat con el agricultor'),
                                    backgroundColor: AppColors.primaryGreen,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Productos',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...order['items'].map<Widget>((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item['quantity']} ${item['unit']} × €${item['price'].toStringAsFixed(2)}',
                                      style: AppTextStyles.bodySecondary,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '€${(item['quantity'] * item['price']).toStringAsFixed(2)}',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: AppTextStyles.subheadline,
                            ),
                            Text(
                              '€${order['total'].toStringAsFixed(2)}',
                              style: AppTextStyles.headline.copyWith(
                                fontSize: 22,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.payment, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            'Pago: ${order['paymentMethod']}',
                            style: AppTextStyles.bodySecondary,
                          ),
                        ],
                      ),
                      if (order['status'] == 'Entregado' && order['rating'] == null) ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showRatingDialog(order);
                            },
                            icon: const Icon(Icons.star_outline),
                            label: Text('Valorar pedido', style: AppTextStyles.buttonText),
                            style: AppButtonStyles.primary.copyWith(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (order['status'] == 'Pendiente') ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _cancelOrder(order);
                            },
                            style: AppButtonStyles.secondary.copyWith(
                              side: const WidgetStatePropertyAll(BorderSide(color: Colors.red)),
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                            child: Text(
                              'Cancelar pedido',
                              style: AppTextStyles.body.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRatingDialog(Map<String, dynamic> order) {
    int rating = 0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Valorar pedido', style: AppTextStyles.subheadline),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  order['farmerName'],
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: AppColors.accentOrange,
                        size: 32,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          rating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'Escribe un comentario (opcional)',
                    hintStyle: AppTextStyles.bodySecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                    ),
                  ),
                ),
              ],
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
              ElevatedButton(
                onPressed: rating > 0
                    ? () {
                        Navigator.pop(context);
                        setState(() {
                          order['rating'] = rating;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Gracias por tu valoración!'),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                      }
                    : null,
                style: AppButtonStyles.primary,
                child: Text('Enviar', style: AppTextStyles.buttonText),
              ),
            ],
          );
        },
      ),
    );
  }

  void _cancelOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancelar pedido', style: AppTextStyles.subheadline),
        content: Text(
          '¿Estás seguro de que quieres cancelar este pedido?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                order['status'] = 'Cancelado';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pedido cancelado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Sí, cancelar',
              style: AppTextStyles.body.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Mis Pedidos',
          style: AppTextStyles.subheadline,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: AppColors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: AppTextStyles.bodySecondary.copyWith(
                          color: isSelected ? AppColors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 80,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay pedidos',
                          style: AppTextStyles.subheadline.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedFilter == 'Todos'
                              ? 'Aún no has hecho ningún pedido'
                              : 'No tienes pedidos con estado "$_selectedFilter"',
                          style: AppTextStyles.bodySecondary,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return _buildOrderCard(order);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showOrderDetails(order),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['id'],
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(order['date']),
                          style: AppTextStyles.bodySecondary.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order['status'],
                        style: AppTextStyles.bodySecondary.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(order['status']),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.store,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        order['farmerName'],
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                Text(
                  '${order['items'].length} producto(s)',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '€${order['total'].toStringAsFixed(2)}',
                      style: AppTextStyles.subheadline.copyWith(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}