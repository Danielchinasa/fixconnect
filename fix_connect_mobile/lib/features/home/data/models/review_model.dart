import 'package:flutter/material.dart';

class ReviewModel {
  final String id;
  final String reviewerName;
  final String reviewerInitials;
  final Color avatarColor;
  final double rating;
  final String comment;
  final String timeAgo;

  const ReviewModel({
    required this.id,
    required this.reviewerName,
    required this.reviewerInitials,
    required this.avatarColor,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });
}
