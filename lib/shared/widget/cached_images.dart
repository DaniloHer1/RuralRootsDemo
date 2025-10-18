import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



class OptimizedImage extends StatelessWidget {
  final String? imageUrl=null;
  
  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) return const Placeholder();
    
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      placeholder: (_, __) => const CircularProgressIndicator(),
      errorWidget: (_, __, ___) => const Icon(Icons.error),
      memCacheWidth: 300, // Limita resolución en memoria
    );
  }
}