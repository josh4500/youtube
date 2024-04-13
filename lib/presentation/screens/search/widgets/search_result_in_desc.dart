import 'package:flutter/material.dart';

import 'search_result_compound.dart';

class SearchResultInDesc extends StatelessWidget {
  const SearchResultInDesc({super.key});

  @override
  Widget build(BuildContext context) {
    return const SearchResultCompound(
      firstTitle: Row(
        children: [
          Flexible(
            child: Text(
              '...somethings you can find in the description',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      secondTitle: Row(
        children: [
          Flexible(
            child: Text(
              'From the video description',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      trailing: Text(
        'Description',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      child: Text(
        'Best thing will be in the title description, somethings you can find in the description',
      ),
    );
  }
}
