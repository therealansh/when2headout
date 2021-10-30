import 'package:flutter/material.dart';

class Group {
  final String? name;
  final List<dynamic>? members;
  final List<dynamic>? days;
  final List<dynamic>? available;

  Group({required this.name, required this.members, required this.days, required this.available});

  static Group fromMap(Map<String, dynamic> data) {
    return Group(
      name: data['name'] as String,
      members: (data['members']),
      days: (data['days'] ),
      available: (data['available']),
    );
  }
}