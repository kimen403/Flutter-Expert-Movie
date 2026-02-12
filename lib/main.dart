import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ditonton/injection.dart' as di;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Movies
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesHomeCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesHomeCubit>()),
        BlocProvider(create: (_) => di.locator<MovieDetailCubit>()),
        BlocProvider(create: (_) => di.locator<SearchMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieCubit>()),
        // TV Series
        BlocProvider(create: (_) => di.locator<NowPlayingTvSeriesCubit>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesHomeCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesHomeCubit>()),
        BlocProvider(create: (_) => di.locator<TvSeriesDetailCubit>()),
        BlocProvider(create: (_) => di.locator<SearchTvSeriesCubit>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvSeriesCubit>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              final type = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => SearchPage(type: type),
                settings: settings,
              );
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
