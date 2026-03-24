import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/features/messages/data/models/conversation_model.dart';
import 'package:flutter/material.dart';

class MessagesMockDatasource {
  MessagesMockDatasource._();

  static List<ConversationModel> getConversations() => [
    ConversationModel(
      id: 'c1',
      contactName: 'Emeka Okafor',
      contactSpecialty: 'Master Plumber',
      contactInitials: 'EO',
      contactColor: AppColors.primaryLight,
      lastMessage: 'I will be there by 10 AM tomorrow.',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      unreadCount: 2,
      isOnline: true,
      messages: [
        MessageModel(
          id: 'm1',
          text: 'Hello! I saw your request for pipe repair.',
          isMe: false,
          sentAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        MessageModel(
          id: 'm2',
          text: 'Yes, the kitchen sink has been leaking for 3 days.',
          isMe: true,
          sentAt: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 50),
          ),
        ),
        MessageModel(
          id: 'm3',
          text: 'No problem. I can have it fixed for ₦7,500.',
          isMe: false,
          sentAt: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 45),
          ),
        ),
        MessageModel(
          id: 'm4',
          text: 'That works for me. Can you come tomorrow morning?',
          isMe: true,
          sentAt: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 30),
          ),
        ),
        MessageModel(
          id: 'm5',
          text: 'I will be there by 10 AM tomorrow.',
          isMe: false,
          sentAt: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
      ],
    ),
    ConversationModel(
      id: 'c2',
      contactName: 'Amina Bello',
      contactSpecialty: 'Electrician',
      contactInitials: 'AB',
      contactColor: AppColors.secondary,
      lastMessage: 'The estimate for rewiring is ₦12,000.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 0,
      isOnline: false,
      messages: [
        MessageModel(
          id: 'm1',
          text:
              'Hi Amina, I need help with electrical wiring in my new apartment.',
          isMe: true,
          sentAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        MessageModel(
          id: 'm2',
          text: 'Sure! How many rooms need rewiring?',
          isMe: false,
          sentAt: DateTime.now().subtract(
            const Duration(hours: 4, minutes: 30),
          ),
        ),
        MessageModel(
          id: 'm3',
          text: '3 bedrooms and a living room.',
          isMe: true,
          sentAt: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        MessageModel(
          id: 'm4',
          text: 'The estimate for rewiring is ₦12,000.',
          isMe: false,
          sentAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
    ),
    ConversationModel(
      id: 'c3',
      contactName: 'Fatima Musa',
      contactSpecialty: 'House Cleaner',
      contactInitials: 'FM',
      contactColor: const Color(0xFF8B5CF6),
      lastMessage: 'Thank you! The cleaning was excellent.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      isOnline: true,
      messages: [
        MessageModel(
          id: 'm1',
          text: 'All done! Your apartment is sparkling clean.',
          isMe: false,
          sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        ),
        MessageModel(
          id: 'm2',
          text: 'Thank you! The cleaning was excellent.',
          isMe: true,
          sentAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    ),
  ];
}
