import 'package:flutter/material.dart';

// 📚 CONCEPT: Composing models — ConversationModel contains a list of MessageModel.
// This mirrors real API structures where a chat thread contains its messages.
// In a real app you'd load messages lazily (pagination), but for mock data we keep it simple.

class MessageModel {
  final String id;
  final String text;
  final bool isMe; // true = sent by the current user, false = received
  final DateTime sentAt;

  const MessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.sentAt,
  });
}

class ConversationModel {
  final String id;
  final String contactName;
  final String contactSpecialty;
  final String contactInitials;
  final Color contactColor;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final List<MessageModel> messages;

  const ConversationModel({
    required this.id,
    required this.contactName,
    required this.contactSpecialty,
    required this.contactInitials,
    required this.contactColor,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
    required this.messages,
  });
}
