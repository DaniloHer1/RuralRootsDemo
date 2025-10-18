extension DateTimeExtension on DateTime {
  String toRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '$day/${month.toString().padLeft(2, '0')}/${year}';
    }
  }

  String toFormattedDate() {
    return '$day/${month.toString().padLeft(2, '0')}/${year}';
  }

  String toFormattedDateTime() {
    return '$day/${month.toString().padLeft(2, '0')}/${year} ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
