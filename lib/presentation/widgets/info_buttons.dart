import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import 'gestures/custom_ink_well.dart';

class IncludePromotionButton extends StatelessWidget {
  const IncludePromotionButton({super.key, this.margin});

  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CustomInkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(4),
          child: const ColoredBox(
            color: Colors.black45,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ColoredBox(
                  color: Color(0xFF3EA6FF),
                  child: SizedBox(width: 4, height: 32),
                ),
                SizedBox(width: 8),
                Icon(
                  YTIcons.paid_promotion_outlined,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text(
                  'Includes Paid Promotions',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  YTIcons.chevron_right,
                  size: 16,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlteredVideoButton extends StatelessWidget {
  const AlteredVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CustomInkWell(
        onTap: () {},
        child: const ColoredBox(
          color: Colors.black45,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ColoredBox(
                color: Color(0xFF3EA6FF),
                child: SizedBox(width: 4, height: 32),
              ),
              SizedBox(width: 8),
              Text(
                'Altered or synthetic content',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                YTIcons.chevron_right,
                size: 16,
                color: Colors.white,
              ),
              SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}
