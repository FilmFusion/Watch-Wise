import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    );
  }
}

class MovieDetailsPage extends StatelessWidget {
  static const String routeName = '/movie-details';

  final dynamic movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              movie['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Release Date: ${movie['release_date']}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              movie['overview'],
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
