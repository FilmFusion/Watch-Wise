import 'package:flutter/material.dart';
import 'package:netflix_demo/services/tmdb_api_service.dart';
import 'package:netflix_demo/screens/movie_details_screen.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  TMDBApiService apiService = TMDBApiService();
  List<dynamic> _movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final movies = await apiService.getPopularMovies();
      setState(() {
        _movies = movies;
      });
    } catch (e) {
      print('Error fetching movies: $e');
      // Handle the error gracefully in your app
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          final title = movie['title'];
          final imageUrl = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

          return ListTile(
            leading: imageUrl != null
                ? Image.network(
              imageUrl,
              width: 60,
              height: 90,
              fit: BoxFit.cover,
            )
                : SizedBox.shrink(),
            title: Text(title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(
                    title: movie['title'],
                    imageUrl: imageUrl,
                    description: movie['overview'],
                    releaseDate: movie['release_date'],
                    rating: movie['vote_average'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
