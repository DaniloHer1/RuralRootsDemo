// lib/screens/map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rural_roots_demo1/screens/chat/chat_conversation_screen.dart';
import 'package:rural_roots_demo1/screens/cart/cart_screen.dart';
import 'package:rural_roots_demo1/services/cart_service.dart';
import 'package:rural_roots_demo1/services/user_service.dart';
import 'package:rural_roots_demo1/themes/app_buttons_styles.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'dart:async';

import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategory;
  
  final CartService _cartService = CartService();
  final UserService _userService = UserService();

  // Ubicación inicial (Logroño, La Rioja)
  final LatLng _initialPosition = const LatLng(42.4627, -2.4450);

  // Estilo personalizado del mapa
  final String _mapStyle = '''
  [
    {
      "featureType": "poi",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "poi.business",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "transit",
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        {"color": "#f4fbf6"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {"color": "#ffffff"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {"color": "#b8e6c9"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#4a5568"}
      ]
    }
  ]
  ''';

  // Datos de agricultores con productos (simulados)
  final List<Map<String, dynamic>> _farmers = [
    {
      'id': '1',
      'name': 'Granja Los Olivos',
      'location': const LatLng(42.4700, -2.4400),
      'products': [
        {'name': 'Tomates ecológicos', 'price': 2.50, 'category': 'Verduras'},
        {'name': 'Lechugas', 'price': 1.20, 'category': 'Hortalizas'},
      ],
    },
    {
      'id': '2',
      'name': 'Huerto San Miguel',
      'location': const LatLng(42.4600, -2.4500),
      'products': [
        {'name': 'Zanahorias frescas', 'price': 1.80, 'category': 'Verduras'},
        {'name': 'Cebollas', 'price': 1.50, 'category': 'Verduras'},
      ],
    },
    {
      'id': '3',
      'name': 'Finca El Roble',
      'location': const LatLng(42.4550, -2.4350),
      'products': [
        {'name': 'Naranjas valencianas', 'price': 2.00, 'category': 'Frutas'},
        {'name': 'Limones', 'price': 1.80, 'category': 'Frutas'},
      ],
    },
    {
      'id': '4',
      'name': 'Agricultura Verde',
      'location': const LatLng(42.4680, -2.4550),
      'products': [
        {'name': 'Manzanas', 'price': 2.20, 'category': 'Frutas'},
        {'name': 'Peras', 'price': 2.10, 'category': 'Frutas'},
      ],
    },
  ];

  final List<String> _categories = ['Todas', 'Frutas', 'Verduras', 'Hortalizas'];

  @override
  void initState() {
    super.initState();
    _createMarkers();
    _getCurrentLocation();
    
    _cartService.addListener(_onCartChanged);
    _userService.addListener(_onUserChanged);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    _userService.removeListener(_onUserChanged);
    _mapController?.dispose();
    super.dispose();
  }

  void _onCartChanged() {
    setState(() {});
  }

  void _onUserChanged() {
    setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    } catch (e) {     
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createMarkers() async {
    final circles = <Circle>{};
    
    for (var farmer in _farmers) {
      circles.add(
        Circle(
          circleId: CircleId('circle_${farmer['id']}'),
          center: farmer['location'],
          radius: 500,
          fillColor: AppColors.primaryGreen,
          strokeColor: AppColors.primaryGreen,
          strokeWidth: 2,
          visible: true,
          consumeTapEvents: true, 
          onTap: () => _showFarmerProducts(farmer), 
        ),
      );
    }

    if (mounted) {
      setState(() {
        _markers = {}; 
        _circles = circles;
      });      
    }
  }

  void _showFarmerProducts(Map<String, dynamic> farmer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primaryGreen,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  farmer['name'],
                                  style: AppTextStyles.headline,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: AppColors.accentOrange,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '4.8',
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(23 valoraciones)',
                                      style: AppTextStyles.bodySecondary.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: AppColors.textPrimary),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: AppColors.border),
                      const SizedBox(height: 8),
                      Text(
                        'Productos disponibles (${farmer['products'].length})',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: farmer['products'].length,
                    itemBuilder: (context, index) {
                      final product = farmer['products'][index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.lightGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.eco,
                                color: AppColors.primaryGreen,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product['category'],
                                    style: AppTextStyles.bodySecondary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '€${product['price'].toStringAsFixed(2)}/kg',
                                    style: AppTextStyles.subheadline.copyWith(
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatConversationScreen(
                                                userName: farmer['name'],
                                                isOnline: true,
                                              ),
                                            ),
                                          );
                                        },
                                        style: AppButtonStyles.primary.copyWith(
                                          padding: const WidgetStatePropertyAll(
                                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          ),
                                        ),
                                        child: Text(
                                          'Contactar',
                                          style: AppTextStyles.buttonText.copyWith(fontSize: 13),
                                        ),
                                      ),
                                      if (_userService.isBuyer)
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _cartService.addItem(
                                              product: product['name'],
                                             farmerName: farmer['name'],
                                              farmerId: farmer['id'],
                                             
                                            );
                                            
                                            Navigator.pop(context);
                                            
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${product['name']} añadido al carrito',
                                                ),
                                                backgroundColor: AppColors.primaryGreen,
                                                action: SnackBarAction(
                                                  label: 'Ver carrito',
                                                  textColor: AppColors.white,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => CartScreen(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.add_shopping_cart, size: 16),
                                          label: Text('Añadir', style: AppTextStyles.buttonText.copyWith(fontSize: 13)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: AppColors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: AppColors.primaryGreen),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando mapa...',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                        : _initialPosition,
                    zoom: 14,
                  ),
                  markers: _markers,
                  circles: _circles,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                    // ignore: deprecated_member_use
                    _mapController?.setMapStyle(_mapStyle);
                  },
                ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          style: AppTextStyles.body,
                          decoration: InputDecoration(
                            hintText: 'Buscar productos o agricultores...',
                            hintStyle: AppTextStyles.bodySecondary,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.filter_list, color: AppColors.primaryGreen),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = isSelected ? null : category;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryGreen : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            category,
                            style: AppTextStyles.bodySecondary.copyWith(
                              color: isSelected ? AppColors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (_currentPosition != null) {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                          14,
                        ),
                      );
                    } else {
                      _getCurrentLocation();
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.primaryGreen, AppColors.primaryGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(Icons.my_location, color: AppColors.white, size: 24),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.store, color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${_farmers.length} agricultores',
                    style: AppTextStyles.bodySecondary.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_userService.isBuyer)
            Positioned(
              bottom: 90,
              right: 16,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade400, Colors.blue.shade600],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.shopping_cart, color: AppColors.white, size: 24),
                        ),
                      ),
                    ),
                  ),
                  if (_cartService.itemCount > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_cartService.itemCount}',
                          style: AppTextStyles.bodySecondary.copyWith(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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