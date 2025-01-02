import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;

  EmptyStateWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}
