// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:rural_roots_demo1/screens/chat_conversation_screen.dart';
import 'package:rural_roots_demo1/themes/app_colors.dart';
import 'package:rural_roots_demo1/themes/app_text_styles.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        'name': 'Granja Los Olivos',
        'message': '¿Aún tienes tomates ecológicos?',
        'time': '10:32',
        'unread': true,
        'online': true,
      },
      {
        'name': 'Huerto San Miguel',
        'message': 'Perfecto, te preparo el pedido',
        'time': 'Ayer',
        'unread': false,
        'online': false,
      },
      {
        'name': 'Finca El Roble',
        'message': '¿Quieres probar nuestras naranjas?',
        'time': 'Lunes',
        'unread': true,
        'online': false,
      },
      {
        'name': 'Agricultura Verde',
        'message': 'Tengo zanahorias muy frescas',
        'time': 'Domingo',
        'unread': false,
        'online': false,
      },
    ];

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
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
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
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Buscar agricultores...',
                hintStyle: AppTextStyles.bodySecondary,
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
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
                  borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Lista de chats
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chats.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: 76,
                color: AppColors.border,
              ),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                          Icons.person,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      if (chat['online'] == true)
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    chat['name'] as String,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: chat['unread'] == true
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      if (chat['unread'] == true)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.accentOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          chat['message'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySecondary.copyWith(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat['time'] as String,
                        style: AppTextStyles.bodySecondary.copyWith(
                          fontSize: 12,
                        ),
                      ),
                      if (chat['unread'] == true) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatConversationScreen(
                          userName: chat['name'] as String,
                          isOnline: chat['online'] as bool,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}