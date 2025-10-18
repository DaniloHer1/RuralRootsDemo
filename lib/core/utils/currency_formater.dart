import 'package:intl/intl.dart';

/// Clase utilitaria para formatear valores monetarios y precios con unidades
/// 
/// Proporciona métodos estáticos para formatear montos en euros (€)
/// y combinar precios con sus unidades de medida (kg, unidad, etc.)
class CurrencyFormatter {
  // Constructor privado para evitar instanciación
  CurrencyFormatter._();

  /// Formateador de moneda en euros
  static final NumberFormat _euroFormatter = NumberFormat.currency(
    locale: 'es_ES',
    symbol: '€',
    decimalDigits: 2,
  );

  /// Formateador simple sin símbolo de moneda
  static final NumberFormat _numberFormatter = NumberFormat(
    '#,##0.00',
    'es_ES',
  );

  /// Formatea un valor numérico como moneda en euros
  /// 
  /// Ejemplos:
  /// ```dart
  /// format(3.50)    // "3,50 €"
  /// format(1250.99) // "1.250,99 €"
  /// format(10)      // "10,00 €"
  /// ```
  /// 
  /// [amount] El monto a formatear
  /// Retorna el monto formateado con símbolo de euro
  static String format(double amount) {
    return _euroFormatter.format(amount);
  }

  /// Formatea un valor numérico con su unidad de medida
  /// 
  /// Ejemplos:
  /// ```dart
  /// formatWithUnit(3.50, 'kg')      // "3,50 €/kg"
  /// formatWithUnit(2.00, 'unidad')  // "2,00 €/ud"
  /// formatWithUnit(4.50, 'docena')  // "4,50 €/docena"
  /// formatWithUnit(15.00, 'L')      // "15,00 €/L"
  /// ```
  /// 
  /// [amount] El precio por unidad
  /// [unit] La unidad de medida
  /// Retorna el precio formateado con su unidad
  static String formatWithUnit(double amount, String unit) {
    final formattedAmount = format(amount);
    final shortUnit = _getShortUnit(unit);
    return '$formattedAmount/$shortUnit';
  }

  /// Formatea un valor numérico sin el símbolo de moneda
  /// 
  /// Útil cuando quieres solo el número formateado
  /// 
  /// Ejemplos:
  /// ```dart
  /// formatNumber(3.50)    // "3,50"
  /// formatNumber(1250.99) // "1.250,99"
  /// ```
  /// 
  /// [amount] El monto a formatear
  /// Retorna el monto formateado sin símbolo
  static String formatNumber(double amount) {
    return _numberFormatter.format(amount);
  }

  /// Formatea un total con descripción
  /// 
  /// Ejemplos:
  /// ```dart
  /// formatTotal(45.50)           // "Total: 45,50 €"
  /// formatTotal(120.00, 'Total') // "Total: 120,00 €"
  /// ```
  /// 
  /// [amount] El monto total
  /// [label] La etiqueta a mostrar (por defecto "Total")
  /// Retorna el total formateado con etiqueta
  static String formatTotal(double amount, {String label = 'Total'}) {
    return '$label: ${format(amount)}';
  }

  /// Formatea un precio de producto completo con cantidad
  /// 
  /// Ejemplos:
  /// ```dart
  /// formatProductPrice(3.50, 2, 'kg')  // "2 kg × 3,50 € = 7,00 €"
  /// formatProductPrice(5.00, 1, 'ud')  // "1 ud × 5,00 € = 5,00 €"
  /// ```
  /// 
  /// [pricePerUnit] Precio por unidad
  /// [quantity] Cantidad de unidades
  /// [unit] Unidad de medida
  /// Retorna el precio formateado con cálculo
  static String formatProductPrice(
    double pricePerUnit,
    int quantity,
    String unit,
  ) {
    final total = pricePerUnit * quantity;
    final shortUnit = _getShortUnit(unit);
    return '$quantity $shortUnit × ${format(pricePerUnit)} = ${format(total)}';
  }

  /// Formatea un descuento o ahorro
  /// 
  /// Ejemplos:
  /// ```dart
  /// formatDiscount(5.50)  // "-5,50 €"
  /// formatSavings(12.00)  // "Ahorras: 12,00 €"
  /// ```
  /// 
  /// [amount] Monto del descuento
  /// Retorna el descuento formateado con signo negativo
  static String formatDiscount(double amount) {
    return '-${format(amount)}';
  }

  /// Formatea un ahorro
  /// 
  /// [amount] Monto ahorrado
  /// Retorna el ahorro formateado con etiqueta
  static String formatSavings(double amount) {
    return 'Ahorras: ${format(amount)}';
  }

  /// Parsea una string de moneda a double
  /// 
  /// Ejemplos:
  /// ```dart
  /// parse("3,50 €")     // 3.50
  /// parse("1.250,99 €") // 1250.99
  /// parse("15")         // 15.00
  /// ```
  /// 
  /// [value] String a parsear
  /// Retorna el valor numérico o 0.0 si no se puede parsear
  static double parse(String value) {
    try {
      // Remover símbolos de moneda y espacios
      final cleaned = value
          .replaceAll('€', '')
          .replaceAll(' ', '')
          .replaceAll('.', '') // Remover separadores de miles
          .replaceAll(',', '.'); // Convertir coma decimal a punto
      
      return double.parse(cleaned);
    } catch (e) {
      return 0.0;
    }
  }

  /// Valida si una string es un monto válido
  /// 
  /// Ejemplos:
  /// ```dart
  /// isValid("3,50")     // true
  /// isValid("1.250,99") // true
  /// isValid("abc")      // false
  /// isValid("")         // false
  /// ```
  /// 
  /// [value] String a validar
  /// Retorna true si es un monto válido
  static bool isValid(String value) {
    if (value.isEmpty) return false;
    try {
      parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Compara dos montos y retorna el mayor
  /// 
  /// [amount1] Primer monto
  /// [amount2] Segundo monto
  /// Retorna el monto mayor formateado
  static String formatMax(double amount1, double amount2) {
    return format(amount1 > amount2 ? amount1 : amount2);
  }

  /// Compara dos montos y retorna el menor
  /// 
  /// [amount1] Primer monto
  /// [amount2] Segundo monto
  /// Retorna el monto menor formateado
  static String formatMin(double amount1, double amount2) {
    return format(amount1 < amount2 ? amount1 : amount2);
  }

  /// Calcula y formatea un porcentaje de descuento
  /// 
  /// Ejemplos:
  /// ```dart
  /// formatPercentageDiscount(100, 85) // "15% de descuento (15,00 €)"
  /// formatPercentageDiscount(50, 40)  // "20% de descuento (10,00 €)"
  /// ```
  /// 
  /// [originalPrice] Precio original
  /// [discountedPrice] Precio con descuento
  /// Retorna el porcentaje y monto ahorrado
  static String formatPercentageDiscount(
    double originalPrice,
    double discountedPrice,
  ) {
    if (originalPrice <= 0) return '';
    
    final savings = originalPrice - discountedPrice;
    final percentage = (savings / originalPrice * 100).round();
    
    return '$percentage% de descuento (${format(savings)})';
  }

  /// Formatea un rango de precios
  /// 
  /// Ejemplos:
  /// ```dart
  /// formatRange(10, 50)  // "10,00 € - 50,00 €"
  /// formatRange(5, 15)   // "5,00 € - 15,00 €"
  /// ```
  /// 
  /// [minPrice] Precio mínimo
  /// [maxPrice] Precio máximo
  /// Retorna el rango de precios formateado
  static String formatRange(double minPrice, double maxPrice) {
    return '${format(minPrice)} - ${format(maxPrice)}';
  }

  /// Convierte unidades largas a abreviaciones
  /// 
  /// Ejemplos:
  /// - "kilogramo" → "kg"
  /// - "unidad" → "ud"
  /// - "litro" → "L"
  /// - "docena" → "docena" (sin cambio)
  static String _getShortUnit(String unit) {
    final unitLower = unit.toLowerCase().trim();
    
    // Mapeo de unidades comunes
    const unitMap = {
      'kilogramo': 'kg',
      'kilogramos': 'kg',
      'kg': 'kg',
      'gramo': 'g',
      'gramos': 'g',
      'g': 'g',
      'litro': 'L',
      'litros': 'L',
      'l': 'L',
      'mililitro': 'ml',
      'mililitros': 'ml',
      'ml': 'ml',
      'unidad': 'ud',
      'unidades': 'ud',
      'ud': 'ud',
      'pieza': 'ud',
      'piezas': 'ud',
      'metro': 'm',
      'metros': 'm',
      'm': 'm',
      'centímetro': 'cm',
      'centímetros': 'cm',
      'cm': 'cm',
      'docena': 'docena',
      'docenas': 'docena',
      'caja': 'caja',
      'cajas': 'caja',
      'bolsa': 'bolsa',
      'bolsas': 'bolsa',
      'manojo': 'manojo',
      'manojos': 'manojo',
      'racimo': 'racimo',
      'racimos': 'racimo',
    };

    return unitMap[unitLower] ?? unit;
  }

  /// Obtiene el símbolo de moneda usado
  /// Retorna "€"
  static String get currencySymbol => '€';

  /// Obtiene el código de moneda
  /// Retorna "EUR"
  static String get currencyCode => 'EUR';

  /// Obtiene el locale usado para formateo
  /// Retorna "es_ES"
  static String get locale => 'es_ES';
}