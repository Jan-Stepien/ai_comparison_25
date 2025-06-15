import 'package:flutter/material.dart';
import 'package:gemini/core/extensions/build_context_extension.dart';

class MovieListCard extends StatelessWidget {
  final String title;
  final String rating;
  final VoidCallback onTap;

  const MovieListCard({
    super.key,
    required this.title,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      height: 48.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 16.0),
          Text(
            context.l10n.ratingWithStar(rating),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    ),
  );
}
