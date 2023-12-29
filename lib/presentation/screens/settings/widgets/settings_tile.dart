import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/account_builder.dart';

import '../../../widgets/network_builder.dart';
import '../view_models/pref_option.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? summary;
  final String? Function(PrefOption prefOption)? onGenerateSummary;
  final bool networkRequired;
  final bool accountRequired;
  final bool disableOnNoNetwork;
  final bool selected;
  final PrefOption? prefOption;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.title,
    this.summary,
    this.onGenerateSummary,
    this.networkRequired = false,
    this.accountRequired = false,
    this.disableOnNoNetwork = false,
    this.selected = false,
    this.prefOption,
    this.onTap,
  });

  Widget? _buildTrailing(bool isConnected) {
    if (prefOption != null) {
      if (prefOption!.type == PrefOptionType.toggleWithOptions ||
          prefOption!.type == PrefOptionType.toggle) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Switch(
            value: prefOption!.value,
            onChanged: (_) {
              if ((networkRequired && isConnected) || !networkRequired) {
                prefOption!.onToggle!();
              }
            },
          ),
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AccountBuilder(builder: (context, state) {
      if (state.isNotAuthenticated && accountRequired) {
        return const SizedBox();
      }

      return NetworkBuilder(builder: (context, state) {
        if (networkRequired && !disableOnNoNetwork && state.isNotConnected) {
          return const SizedBox();
        }

        String? effectiveSummary;
        if (onGenerateSummary != null && prefOption != null) {
          effectiveSummary = onGenerateSummary!(prefOption!);
        } else if (summary != null) {
          effectiveSummary = summary;
        }

        return ListTile(
          selected: selected,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 1,
          ),
          selectedColor: Colors.white,
          selectedTileColor: Colors.grey,
          title: Text(title),
          subtitle: effectiveSummary != null
              ? Text(
                  effectiveSummary,
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                  ),
                )
              : null,
          trailing: _buildTrailing(state.isConnected),
          onTap: onTap,
          enabled: disableOnNoNetwork ? state.isConnected : true,
        );
      });
    });
  }
}
