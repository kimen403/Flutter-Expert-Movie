import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movies/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';
  final String type; // 'movie' or 'tv'
  SearchPage({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                if (type == 'movie') {
                  context.read<SearchMoviesCubit>().fetchMovieSearch(query);
                } else {
                  context
                      .read<SearchTvSeriesCubit>()
                      .fetchTvSeriesSearch(query);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            if (type == 'movie')
              BlocBuilder<SearchMoviesCubit, SearchMoviesState>(
                builder: (context, data) {
                  if (data.state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.state == RequestState.Loaded) {
                    final result = data.searchResult;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = data.searchResult[index];
                          return MovieCard(movie);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              )
            else
              BlocBuilder<SearchTvSeriesCubit, SearchTvSeriesState>(
                builder: (context, data) {
                  if (data.state == RequestState.Loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.state == RequestState.Loaded) {
                    final result = data.searchResult;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final tvSeries = data.searchResult[index];
                          return TvSeriesCard(tvSeries);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
