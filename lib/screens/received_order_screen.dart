// lib/screens/received_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class ReceivedOrdersScreen extends StatefulWidget {
  const ReceivedOrdersScreen({super.key});

  @override
  State<ReceivedOrdersScreen> createState() => _ReceivedOrdersScreenState();
}

class _ReceivedOrdersScreenState extends State<ReceivedOrdersScreen> {
  String _selectedFilter = 'Todos';

  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'PED-001',
      'buyerName': 'Juan Martínez',
      'buyerPhone': '+34 612 345 678',
      'date': DateTime.now().subtract(const Duration(hours: 1)),
      'status': 'Nuevo',
      'total': 7.50,
      'items': [
        {'name': 'Tomates ecológicos', 'quantity': 3, 'unit': 'kg', 'price': 2.50},
      ],
      'paymentMethod': 'Efectivo en mano',
      'address': 'Calle Mayor 15, Logroño',
      'notes': 'Por favor, que estén bien maduros',
    },
    {
      'id': 'PED-002',
      'buyerName': 'María López',
      'buyerPhone': '+34 623 456 789',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'Aceptado',
      'total': 12.50,
      'items': [
        {'name': 'Tomates ecológicos', 'quantity': 3, 'unit': 'kg', 'price': 2.50},
        {'name': 'Lechugas', 'quantity': 4, 'unit': 'unidad', 'price': 1.20},
      ],
      'paymentMethod': 'Transferencia',
      'address': 'Avenida de la Paz 42, Logroño',
      'notes': '',
    },
    {
      'id': 'PED-003',
      'buyerName': 'Carlos Ruiz',
      'buyerPhone': '+34 634 567 890',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Completado',
      'total': 6.00,
      'items': [
        {'name': 'Lechugas', 'quantity': 5, 'unit': 'unidad', 'price': 1.20},
      ],
      'paymentMethod': 'Efectivo en mano',
      'address': 'Plaza del Mercado 8, Logroño',
      'notes': '',
    },
    {
      'id': 'PED-004',
      'buyerName': 'Ana García',
      'buyerPhone': '+34 645 678 901',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'Rechazado',
      'total': 5.00,
      'items': [
        {'name': 'Tomates ecológicos', 'quantity': 2, 'unit': 'kg', 'price': 2.50},
      ],
      'paymentMethod': 'Efectivo en mano',
      'address': 'Calle San Juan 23, Logroño',
      'notes': 'Necesito para el domingo',
    },
  ];

  final List<String> _filters = ['Todos', 'Nuevo', 'Aceptado', 'Completado', 'Rechazado'];

  List<Map<String, dynamic>> get filteredOrders {
    if (_selectedFilter == 'Todos') return _orders;
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Nuevo': return AppColors.accentOrange;
      case 'Aceptado': return Colors.blue;
      case 'Completado': return AppColors.primaryGreen;
      case 'Rechazado': return Colors.red;
      default: return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Nuevo': return Icons.notifications_active;
      case 'Aceptado': return Icons.check_circle_outline;
      case 'Completado': return Icons.task_alt;
      case 'Rechazado': return Icons.cancel_outlined;
      default: return Icons.info_outline;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inHours < 1) return 'Hace ${difference.inMinutes} minutos';
    if (difference.inHours < 24) return 'Hace ${difference.inHours} horas';
    if (difference.inDays < 7) return 'Hace ${difference.inDays} días';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
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
                              Text('Pedido ${order['id']}', style: AppTextStyles.headline),
                              const SizedBox(height: 4),
                              Text(_formatDate(order['date']), style: AppTextStyles.bodySecondary),
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
                                Icon(_getStatusIcon(order['status']), size: 16, color: _getStatusColor(order['status'])),
                                const SizedBox(width: 4),
                                Text(order['status'], style: AppTextStyles.bodySecondary.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(order['status']),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person, color: Colors.blue),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(order['buyerName'], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(order['buyerPhone'], style: AppTextStyles.bodySecondary),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.phone, color: Colors.blue),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Llamar a ${order['buyerName']}'), backgroundColor: Colors.blue),
                                    );
                                  },
                                ),
                              ],
                            ),
                            if (order['address'] != null && order['address'].isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 18, color: AppColors.textSecondary),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(order['address'], style: AppTextStyles.bodySecondary)),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Productos solicitados', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
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
                                    Text(item['name'], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text('${item['quantity']} ${item['unit']} × €${item['price'].toStringAsFixed(2)}', style: AppTextStyles.bodySecondary),
                                  ],
                                ),
                              ),
                              Text('€${(item['quantity'] * item['price']).toStringAsFixed(2)}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
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
                            Text('Total', style: AppTextStyles.subheadline),
                            Text('€${order['total'].toStringAsFixed(2)}', style: AppTextStyles.headline.copyWith(fontSize: 22, color: AppColors.primaryGreen)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.payment, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Pago: ${order['paymentMethod']}', style: AppTextStyles.bodySecondary),
                        ],
                      ),
                      if (order['notes'] != null && order['notes'].isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.note, size: 18, color: Colors.amber.shade700),
                                  const SizedBox(width: 8),
                                  Text('Notas del cliente:', style: AppTextStyles.bodySecondary.copyWith(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(order['notes'], style: AppTextStyles.bodySecondary.copyWith(color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ],
                      if (order['status'] == 'Nuevo') ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _rejectOrder(order);
                                },
                                icon: const Icon(Icons.close),
                                label: Text('Rechazar', style: AppTextStyles.body.copyWith(color: Colors.red)),
                                style: AppButtonStyles.secondary.copyWith(
                                  side: const WidgetStatePropertyAll(BorderSide(color: Colors.red)),
                                  foregroundColor: const WidgetStatePropertyAll(Colors.red),
                                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _acceptOrder(order);
                                },
                                icon: const Icon(Icons.check),
                                label: Text('Aceptar', style: AppTextStyles.buttonText),
                                style: AppButtonStyles.primary.copyWith(
                                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (order['status'] == 'Aceptado') ...[
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _completeOrder(order);
                            },
                            icon: const Icon(Icons.task_alt),
                            label: Text('Marcar como completado', style: AppTextStyles.buttonText),
                            style: AppButtonStyles.primary.copyWith(
                              padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14)),
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

  void _acceptOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aceptar pedido', style: AppTextStyles.subheadline),
        content: Text('¿Confirmas que aceptas el pedido de ${order['buyerName']}?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => order['status'] = 'Aceptado');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ Pedido aceptado. El cliente será notificado.'), backgroundColor: AppColors.primaryGreen),
              );
            },
            style: AppButtonStyles.primary,
            child: Text('Aceptar pedido', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }

  void _rejectOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rechazar pedido', style: AppTextStyles.subheadline),
        content: Text('¿Seguro que quieres rechazar el pedido de ${order['buyerName']}?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => order['status'] = 'Rechazado');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pedido rechazado. El cliente será notificado.'), backgroundColor: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: AppColors.white),
            child: Text('Rechazar', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }

  void _completeOrder(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Completar pedido', style: AppTextStyles.subheadline),
        content: Text('¿El pedido ha sido entregado al cliente?', style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => order['status'] = 'Completado');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ Pedido marcado como completado'), backgroundColor: AppColors.primaryGreen),
              );
            },
            style: AppButtonStyles.primary,
            child: Text('Sí, completado', style: AppTextStyles.buttonText),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newOrdersCount = _orders.where((o) => o['status'] == 'Nuevo').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pedidos Recibidos', style: AppTextStyles.subheadline),
        centerTitle: true,
        actions: [
          if (newOrdersCount > 0)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_active, color: AppColors.accentOrange),
                  onPressed: () => setState(() => _selectedFilter = 'Nuevo'),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('$newOrdersCount', style: AppTextStyles.bodySecondary.copyWith(color: AppColors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
        ],
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
                final count = filter == 'Todos' ? _orders.length : _orders.where((o) => o['status'] == filter).length;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          Text(filter, style: AppTextStyles.bodySecondary.copyWith(color: isSelected ? AppColors.white : AppColors.textPrimary, fontWeight: FontWeight.w600)),
                          if (count > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.white : AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('$count', style: AppTextStyles.bodySecondary.copyWith(
                                color: isSelected ? AppColors.primaryGreen : AppColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              )),
                            ),
                          ],
                        ],
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
                        Icon(Icons.inbox_outlined, size: 80, color: AppColors.textSecondary),
                        const SizedBox(height: 16),
                        Text('No hay pedidos', style: AppTextStyles.subheadline.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text(_selectedFilter == 'Todos' ? 'Aún no has recibido ningún pedido' : 'No tienes pedidos con estado "$_selectedFilter"', style: AppTextStyles.bodySecondary),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) => _buildOrderCard(filteredOrders[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final isNew = order['status'] == 'Nuevo';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: isNew ? Border.all(color: AppColors.accentOrange, width: 2) : null,
        boxShadow: [BoxShadow(color: AppColors.border.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
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
                        Text(order['id'], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_formatDate(order['date']), style: AppTextStyles.bodySecondary.copyWith(fontSize: 12)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          if (isNew)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: const BoxDecoration(color: AppColors.accentOrange, shape: BoxShape.circle),
                            ),
                          Text(order['status'], style: AppTextStyles.bodySecondary.copyWith(fontWeight: FontWeight.bold, color: _getStatusColor(order['status']), fontSize: 12)),
                        ],
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
                      decoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
                      child: const Icon(Icons.person, color: Colors.blue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(order['buyerName'], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600))),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),
                Text('${order['items'].length} producto(s)', style: AppTextStyles.bodySecondary),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    Text('€${order['total'].toStringAsFixed(2)}', style: AppTextStyles.subheadline.copyWith(color: AppColors.primaryGreen)),
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