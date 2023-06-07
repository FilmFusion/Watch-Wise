import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netflix_demo/services/tmdb_api_service.dart';
import 'package:netflix_demo/screens/tvseries_details_screen.dart';

class PopularTVSeriesScreen extends StatefulWidget {
  @override
  _PopularTVSeriesScreenState createState() => _PopularTVSeriesScreenState();
}

class _PopularTVSeriesScreenState extends State<PopularTVSeriesScreen> {
  TMDBApiService apiService = TMDBApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Series'),
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: apiService.getPopularTVSeries(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final tvSeriesList = snapshot.data!;
            return ListView.builder(
              itemCount: tvSeriesList.length,
              itemBuilder: (context, index) {
                final tvSeries = tvSeriesList[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: 'https://image.tmdb.org/t/p/w200${tvSeries['poster_path']}',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(tvSeries['name'] ?? ''),
                  subtitle: Text('Rating: ${tvSeries['vote_average']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TVSeriesDetailsScreen(
                          title: tvSeries['name'] ?? '',
                          imageUrl: 'https://image.tmdb.org/t/p/w200${tvSeries['poster_path']}',
                          description: tvSeries['overview'] ?? '',
                          releaseDate: tvSeries['first_air_date'] ?? '',
                          rating: tvSeries['vote_average'] ?? 0.0,
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
