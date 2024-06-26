import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'search_result_compound.dart';

class SearchResultInConcepts extends StatelessWidget {
  const SearchResultInConcepts({super.key});

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
          const SizedBox(width: 8),
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
          const SizedBox(width: 8),
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
          const SizedBox(width: 8),
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
          const SizedBox(width: 8),
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
        ],
      ),
      secondTitle: const Row(
        children: [
          Flexible(
            child: Text(
              '6 auto-generated concepts',
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
        '6 key concepts',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      itemBuilder: (BuildContext context, int index) {
        return CustomInkWell(
          onTap: () {},
          child: const PlayableTimedVideoContent(
            width: 150,
            margin: EdgeInsets.all(4),
          ),
        );
      },
      itemCount: 6,
    );
  }
}
