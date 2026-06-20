import 'package:flutter/material.dart';

class AppActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AppActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius:
            BorderRadius.circular(20),
        onTap: onTap,
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(icon,size:32),

                const SizedBox(height:12),

                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}