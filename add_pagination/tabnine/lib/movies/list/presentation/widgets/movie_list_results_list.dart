import 'package:flutter/material.dart';
import 'package:tabnine/movies/details/presentation/pages/movie_details_page.dart';
import 'package:tabnine/movies/list/domain/models/movie_list_item.dart';
import 'package:tabnine/movies/list/presentation/widgets/movie_list_card.dart';

class MovieListResultsList extends StatelessWidget {
  const MovieListResultsList({super.key, required this.movieList});

  final List<MovieListItem> movieList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        height: 1.0,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) => MovieListCard(
        title: movieList[index].title,
        rating: '${(movieList[index].voteAverage * 10).toInt()}',
        onTap: () => Navigator.pushNamed(
          context,
          MovieDetailsPage.routePath,
          arguments: movieList[index].id,
        ),
      ),
      itemCount: movieList.length,
    );
  }
}
