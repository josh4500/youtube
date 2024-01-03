import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';

class AccountSection extends StatelessWidget {
  final VoidCallback? onTapChannelInfo;
  final VoidCallback? onTapSwitchAccount;
  final VoidCallback? onTapGoogleAccount;
  final VoidCallback? onTapIncognito;

  const AccountSection({
    super.key,
    this.onTapChannelInfo,
    this.onTapSwitchAccount,
    this.onTapGoogleAccount,
    this.onTapIncognito,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapChannelInfo,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(64),
                    child: Image.network(
                      'https://ui-avatars.com/api/?background=3d3d3d&color=fff',
                      height: 84,
                      width: 84,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Josh',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '@josh4500',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 6.0,
                            ),
                            child: Text(
                              '·',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            'View channel',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 10,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 30,
            child: ScrollConfiguration(
              behavior: const OverScrollGlowBehavior(enabled: false),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  CustomActionChip(
                    title: 'Switch account',
                    onTap: onTapSwitchAccount,
                    icon: const Icon(Icons.switch_account, size: 16),
                    backgroundColor: const Color(0xFF3D3D3D),
                  ),
                  const SizedBox(width: 8),
                  CustomActionChip(
                    title: 'Google Account',
                    onTap: onTapGoogleAccount,
                    icon: const Icon(Icons.account_circle, size: 16),
                    backgroundColor: const Color(0xFF3D3D3D),
                  ),
                  const SizedBox(width: 8),
                  CustomActionChip(
                    title: 'Turn on incognito',
                    onTap: onTapIncognito,
                    icon: const Icon(Icons.privacy_tip, size: 16),
                    backgroundColor: const Color(0xFF3D3D3D),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
