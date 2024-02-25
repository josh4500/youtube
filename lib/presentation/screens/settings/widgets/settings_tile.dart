// Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)

// All rights reserved.

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimer in the documentation
//       and/or other materials provided with the distribution.
//     * Neither the name of {{ project }} nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
