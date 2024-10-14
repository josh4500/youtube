import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/themes.dart';

import '../../account_avatar.dart';
import '../../network_image/custom_network_image.dart';
import '../../playable/playable_content.dart';

class ViewablePlaylistContext extends StatelessWidget {
  const ViewablePlaylistContext({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewableStyle theme = context.theme.appStyles.viewableVideoStyle;
    return Column(
      children: [
        SizedBox(
          height: 227,
          child: Column(
            children: [
              for (int i = 3; i > 1; i--)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 1,
                    horizontal: 8.0 * i,
                  ),
                  child: ClipPath(
                    clipper: ClipEdgeClipper(),
                    child: ColoredBox(
                      color: theme.backgroundColor,
                      child: SizedBox(
                        width: double.infinity,
                        height: 4.2.h,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: CustomNetworkImage(
                        'https://picsum.photos/450/900',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 4,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          YTIcons.playlists_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 2.w),
                        const Text(
                          '2',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 4,
              ),
              child: AccountAvatar(size: 36),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Future, Metro BoomIn - Like That (Official Audio)',
                    style: theme.titleStyle,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: 'Future',
                          children: const <InlineSpan>[
                            TextSpan(text: ' · '),
                            TextSpan(text: '1.8M views'),
                            TextSpan(text: ' · '),
                            TextSpan(text: '1 day ago'),
                          ],
                          style: theme.subtitleStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
