// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/builders/auth_state_builder.dart';

import '../../../widgets/builders/network_builder.dart';
import '../view_models/pref_option.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? summary;
  final String? Function(PrefOption prefOption)? onGenerateSummary;
  final bool networkRequired;
  final bool accountRequired;
  final bool disableOnNoNetwork;
  final bool selected;
  final bool? enabled;
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
    this.enabled,
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
      } else if (prefOption!.type == PrefOptionType.radio) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Radio(
            value: prefOption!.value,
            groupValue: prefOption!.groupValue,
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
    return AuthStateBuilder(builder: (context, state) {
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
          enabled: enabled ?? (disableOnNoNetwork ? state.isConnected : true),
        );
      });
    });
  }
}
