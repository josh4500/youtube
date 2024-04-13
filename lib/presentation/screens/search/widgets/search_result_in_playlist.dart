import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'search_result_compound.dart';

class SearchResultInPlaylist extends StatelessWidget {
  const SearchResultInPlaylist({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchResultCompound(
      firstTitle: Row(
        children: [
          Container(
            height: 18,
            width: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              image: const DecorationImage(
                image: CustomNetworkImage('https://picsum.photos/200/200'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Flexible(
            child: Text(
              'Melody Playing with Baby number 2',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      secondTitle: const Row(
        children: [
          Flexible(
            child: Text(
              '6 videos in playlist',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      trailing: const Text(
        '20 videos',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      itemBuilder: (BuildContext context, int index) {
        return CustomInkWell(
          onTap: () {},
          child: const PlayableVideoContent(
            width: 150,
            direction: Axis.vertical,
            margin: EdgeInsets.all(4),
          ),
        );
      },
      itemCount: 20,
    );
  }
}
