import 'package:flutter/material.dart';

class ViewChangeSnackbar extends StatelessWidget {
  final String title;
  final VoidCallback? onView;

  const ViewChangeSnackbar({super.key, required this.title, this.onView});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              if (onView != null) ...[
                const SizedBox(width: 20),
                TextButton(onPressed: onView, child: const Text('View')),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
