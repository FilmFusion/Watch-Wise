import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'search_page.dart';
import 'settings_page.dart';
import 'main.dart';
import 'tv_shows.dart';
import 'movie_details_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoviesPage extends StatefulWidget {
  static const String routeName = '/movies';
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  List<dynamic> trendingMovies = [];
  List<dynamic> nowPlayingMovies = [];
  List<dynamic> upcomingMovies = [];
  List<dynamic> popularMovies = [];
  List<dynamic> topRatedMovies = [];

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies().then((movies) {
      setState(() {
        trendingMovies = movies;
      });
    });
    fetchNowPlayingMovies().then((movies) {
      setState(() {
        nowPlayingMovies = movies;
      });
    });
    fetchUpcomingMovies().then((movies) {
      setState(() {
        upcomingMovies = movies;
      });
    });
    fetchPopularMovies().then((movies) {
      setState(() {
        popularMovies = movies;
      });
    });
    fetchTopRatedMovies().then((movies) {
      setState(() {
        topRatedMovies = movies;
      });
    });
  }

  Future<List<dynamic>> fetchTrendingMovies() async {
    final apiKey = '080184f9aad4105504265a00cf70d578'; // Replace with your TMDB API key
    final url = 'https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results'];
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<dynamic>> fetchNowPlayingMovies() async {
    final apiKey = '080184f9aad4105504265a00cf70d578'; // Replace with your TMDB API key
    final url = 'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results'];
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<List<dynamic>> fetchUpcomingMovies() async {
    final apiKey = '080184f9aad4105504265a00cf70d578'; // Replace with your TMDB API key
    final url = 'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results'];
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<dynamic>> fetchPopularMovies() async {
    final apiKey = '080184f9aad4105504265a00cf70d578'; // Replace with your TMDB API key
    final url = 'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results'];
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<dynamic>> fetchTopRatedMovies() async {
    final apiKey = '080184f9aad4105504265a00cf70d578'; // Replace with your TMDB API key
    final url = 'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results'];
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  void navigateToMovieDetailsPage(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  Widget buildMovieItem(dynamic movie) {
    return GestureDetector(
      onTap: () {
        navigateToMovieDetailsPage(movie);
      },
      child: Container(
        width: 120,
        margin: EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              movie['title'],
              maxLines: 2,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              'Release Date: ${movie['release_date']}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMovieList(String title, List<dynamic> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 220,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return buildMovieItem(movie);
            },
          ),
        ),
      ],
    );
  }

  void navigateToSettingsPage(BuildContext context) {
    Navigator.pushNamed(context, SettingsPage.routeName);
  }

  void navigateToSearchPage(BuildContext context) {
    Navigator.pushNamed(context, SearchPage.routeName);
  }

  void navigateToTVShowsPage(BuildContext context) {
    Navigator.pushNamed(context, TVShowsPage.routeName);
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.routeName);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMovieList('Trending Movies', trendingMovies),
            buildMovieList('Now Playing', nowPlayingMovies),
            buildMovieList('Upcoming Movies', upcomingMovies),
            buildMovieList('Popular Movies', popularMovies),
            buildMovieList('Top Rated Movies', topRatedMovies),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        fixedColor: Colors.red,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.movie,
              color: Colors.white,
            ),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.tv,
              color: Colors.white,
            ),
            label: 'TV Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            label: 'Search',
          ),
        ],
        onTap: (int index){
          switch(index) {
            case 0:
              navigateToHomePage(context);
              break;
            case 1:
              break;
            case 2:
              navigateToTVShowsPage(context);
              break;
            case 3:
              navigateToSearchPage(context);
              break;
          }
        },
      ),
    );
  }
}


