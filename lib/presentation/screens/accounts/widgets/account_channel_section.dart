import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/custom_action_chip.dart';
import 'package:youtube_clone/presentation/widgets/over_scroll_glow_behavior.dart';
import 'package:youtube_clone/presentation/widgets/tappable_area.dart';

class AccountChannelSection extends StatelessWidget {
  final VoidCallback moreChannel;

  const AccountChannelSection({
    super.key,
    required this.moreChannel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: Image.network(
                    'https://ui-avatars.com/api/?background=3d3d3d&color=fff',
                    height: 86,
                    width: 86,
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
                    SizedBox(height: 4),
                    Text(
                      '@josh4500',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '1 subscriber',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TappableArea(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Text(
                    'More about this channel',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomActionChip(
                    alignment: Alignment.center,
                    backgroundColor: Color(0xff2c2c2c),
                    padding: EdgeInsets.all(16),
                    title: 'Manage videos',
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CustomActionChip(
                  alignment: Alignment.center,
                  icon: Icon(
                    Icons.analytics_outlined,
                  ),
                  padding: EdgeInsets.all(8),
                  backgroundColor: Color(0xff2c2c2c),
                ),
                SizedBox(width: 8),
                CustomActionChip(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  icon: Icon(
                    Icons.mode_edit_outline_outlined,
                  ),
                  backgroundColor: Color(0xff2c2c2c),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
