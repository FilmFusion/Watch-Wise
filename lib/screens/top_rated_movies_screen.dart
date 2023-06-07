import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netflix_demo/services/tmdb_api_service.dart';
import 'package:netflix_demo/screens/movie_details_screen.dart';

class TopRatedMoviesScreen extends StatefulWidget {
  @override
  _TopRatedMoviesScreenState createState() => _TopRatedMoviesScreenState();
}

class _TopRatedMoviesScreenState extends State<TopRatedMoviesScreen> {
  TMDBApiService apiService = TMDBApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: apiService.getTopRatedMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final moviesList = snapshot.data!;
            return ListView.builder(
              itemCount: moviesList.length,
              itemBuilder: (context, index) {
                final movie = moviesList[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(movie['title'] ?? ''),
                  subtitle: Text('Rating: ${movie['vote_average']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(
                          title: movie['title'] ?? '',
                          imageUrl: 'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                          description: movie['overview'] ?? '',
                          releaseDate: movie['release_date'] ?? '',
                          rating: movie['vote_average'] ?? 0.0,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
