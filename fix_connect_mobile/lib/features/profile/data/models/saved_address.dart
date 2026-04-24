import 'package:flutter/material.dart';

class SavedAddress {
  final String id;
  final String label;
  final IconData icon;
  final String street;
  final String city;
  final String state;
  bool isDefault;

  SavedAddress({
    required this.id,
    required this.label,
    required this.icon,
    required this.street,
    required this.city,
    required this.state,
    required this.isDefault,
  });
}
