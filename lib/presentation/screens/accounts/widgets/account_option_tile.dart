import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/builders/network_listenable_builder.dart';

class AccountOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? summary;
  final bool networkRequired;
  final VoidCallback? onTap;

  const AccountOptionTile({
    super.key,
    required this.title,
    required this.icon,
    this.networkRequired = false,
    this.summary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (networkRequired) {
      return NetworkListenableBuilder(
        builder: (context, state) {
          return ListTile(
            leading: Icon(icon),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            selectedColor: Colors.white,
            selectedTileColor: Colors.grey,
            title: Text(title),
            subtitle: summary != null
                ? Text(
                    summary!,
                    style: const TextStyle(
                      color: Color(0xFFAAAAAA),
                    ),
                  )
                : null,
            onTap: onTap,
            enabled: state.isConnected,
          );
        },
      );
    }

    return ListTile(
      leading: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      selectedColor: Colors.white,
      selectedTileColor: Colors.grey,
      title: Text(title),
      subtitle: summary != null
          ? Text(
              summary!,
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
