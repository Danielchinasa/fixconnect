import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CarouselModel extends Equatable {
  // Constructor
  const CarouselModel({
    required this.image,
    required this.title,
    required this.description,
  });

  final Image image;
  final String title;
  final String description;

  // Equatable props for value comparison
  @override
  List<Object?> get props => [image, title, description];
}
