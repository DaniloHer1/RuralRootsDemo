// lib/screens/chat/chat_screen.dart
import 'package:flutter/material.dart';

import 'chat_conversation_screen.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';

/// Pantalla principal del chat que muestra la lista de conversaciones
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Lista de conversaciones de ejemplo
  final List<Map<String, dynamic>> _chats = [
    {
      'id': '1',
      'name': 'Granja Los Olivos',
      'message': '¿Aún tienes tomates ecológicos?',
      'time': '10:32',
      'unread': true,
      'online': true,
      'avatar': '',
    },
    {
      'id': '2',
      'name': 'Huerto San Miguel',
      'message': 'Perfecto, te preparo el pedido',
      'time': 'Ayer',
      'unread': false,
      'online': false,
      'avatar': '',
    },
    {
      'id': '3',
      'name': 'Finca El Roble',
      'message': '¿Quieres probar nuestras naranjas?',
      'time': 'Lunes',
      'unread': true,
      'online': false,
      'avatar': '',
    },
    {
      'id': '4',
      'name': 'Agricultura Verde',
      'message': 'Tengo zanahorias muy frescas',
      'time': 'Domingo',
      'unread': false,
      'online': false,
      'avatar': '',
    },
    {
      'id': '5',
      'name': 'Viñedos del Valle',
      'message': 'Las uvas están listas para recoger',
      'time': 'Hace 2 días',
      'unread': false,
      'online': true,
      'avatar': '',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filtra las conversaciones según la búsqueda
  List<Map<String, dynamic>> get _filteredChats {
    if (_searchQuery.isEmpty) {
      return _chats;
    }
    return _chats.where((chat) {
      final name = (chat['name'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Mensajes',
          style: AppTextStyles.subheadline,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square, color: AppColors.primaryGreen),
            onPressed: () {
              // TODO: Crear nueva conversación
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nuevo mensaje - En desarrollo'),
                ),
              );
            },
            tooltip: 'Nuevo mensaje',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Buscar conversaciones...',
                hintStyle: AppTextStyles.bodySecondary,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Lista de conversaciones
          Expanded(
            child: _filteredChats.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredChats.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      indent: 76,
                      color: AppColors.border.withOpacity(0.5),
                    ),
                    itemBuilder: (context, index) {
                      final chat = _filteredChats[index];
                      return _buildChatItem(chat);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Widget de estado vacío cuando no hay resultados de búsqueda
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron conversaciones',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }

  /// Construye un item de la lista de chats
  Widget _buildChatItem(Map<String, dynamic> chat) {
    final isUnread = chat['unread'] as bool;
    final isOnline = chat['online'] as bool;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      // Avatar
      leading: Stack(
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
              size: 24,
            ),
          ),
          // Indicador de online
          if (isOnline)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      // Nombre y último mensaje
      title: Text(
        chat['name'] as String,
        style: AppTextStyles.body.copyWith(
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Row(
        children: [
          // Indicador de mensaje no leído
          if (isUnread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                color: AppColors.accentOrange,
                shape: BoxShape.circle,
              ),
            ),
          // Último mensaje
          Expanded(
            child: Text(
              chat['message'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 13,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
      // Hora y badge de no leído
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat['time'] as String,
            style: AppTextStyles.bodySecondary.copyWith(
              fontSize: 12,
              color: isUnread
                  ? AppColors.primaryGreen
                  : AppColors.textSecondary,
              fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isUnread) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '1',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      // Acción al tocar
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatConversationScreen(
              userName: chat['name'] as String,
              userAvatar: chat['avatar'] as String,
              isOnline: isOnline,
            ),
          ),
        );
      },
      // Acciones deslizables (opcional)
      onLongPress: () {
        _showChatOptions(context, chat);
      },
    );
  }

  /// Muestra opciones para una conversación
  void _showChatOptions(BuildContext context, Map<String, dynamic> chat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle para arrastrar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.push_pin_outlined,
                color: AppColors.primaryGreen,
              ),
              title: Text('Fijar conversación', style: AppTextStyles.body),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Conversación fijada'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.mark_chat_read_outlined,
                color: Colors.blue,
              ),
              title: Text('Marcar como leído', style: AppTextStyles.body),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  chat['unread'] = false;
                });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications_off_outlined,
                color: AppColors.accentOrange,
              ),
              title: Text('Silenciar', style: AppTextStyles.body),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Conversación silenciada'),
                    backgroundColor: AppColors.accentOrange,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text('Eliminar chat', style: AppTextStyles.body),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, chat);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  /// Muestra confirmación para eliminar chat
  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> chat,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar chat', style: AppTextStyles.subheadline),
        content: Text(
          '¿Estás seguro de que quieres eliminar esta conversación?',
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
              Navigator.pop(context);
              setState(() {
                _chats.remove(chat);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Conversación eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Eliminar',
              style: AppTextStyles.body.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}