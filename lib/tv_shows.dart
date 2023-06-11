import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TVShowsPage extends StatefulWidget {
  static const routeName = '/tvshows';

  @override
  _TVShowsPageState createState() => _TVShowsPageState();
}

class _TVShowsPageState extends State<TVShowsPage> {
  List<dynamic> trendingTVShows = [];
  List<dynamic> airingTodayTVShows = [];
  List<dynamic> onTVTVShows = [];
  List<dynamic> popularTVShows = [];
  List<dynamic> topRatedTVShows = [];

  @override
  void initState() {
    super.initState();
    fetchTrendingTVShows();
    fetchAiringTodayTVShows();
    fetchOnTVTVShows();
    fetchPopularTVShows();
    fetchTopRatedTVShows();
  }

  Future<void> fetchTrendingTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        trendingTVShows = jsonResponse['results'];
      });
    } else {
      throw Exception('Failed to load trending TV shows');
    }
  }

  Future<void> fetchAiringTodayTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/airing_today?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        airingTodayTVShows = jsonResponse['results'];
      });
    } else {
      throw Exception('Failed to load airing today TV shows');
    }
  }

  Future<void> fetchOnTVTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        onTVTVShows = jsonResponse['results'];
      });
    } else {
      throw Exception('Failed to load "On TV" TV shows');
    }
  }

  Future<void> fetchPopularTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        popularTVShows = jsonResponse['results'];
      });
    } else {
      throw Exception('Failed to load popular TV shows');
    }
  }

  Future<void> fetchTopRatedTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        topRatedTVShows = jsonResponse['results'];
      });
    } else {
      throw Exception('Failed to load top-rated TV shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Trending',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (var show in trendingTVShows)
                    GestureDetector(
                      onTap: () {
                        // Handle TV show item tap
                      },
                      child: Container(
                        width: 150.0,
                        height: 200.0,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w200${show['poster_path']}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Airing Today',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (var show in airingTodayTVShows)
                    GestureDetector(
                      onTap: () {
                        // Handle TV show item tap
                      },
                      child: Container(
                        width: 150.0,
                        height: 200.0,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w200${show['poster_path']}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'On TV',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (var show in onTVTVShows)
                    GestureDetector(
                      onTap: () {
                        // Handle TV show item tap
                      },
                      child: Container(
                        width: 150.0,
                        height: 200.0,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w200${show['poster_path']}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Popular',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (var show in popularTVShows)
                    GestureDetector(
                      onTap: () {
                        // Handle TV show item tap
                      },
                      child: Container(
                        width: 150.0,
                        height: 200.0,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w200${show['poster_path']}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Top Rated',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (var show in topRatedTVShows)
                    GestureDetector(
                      onTap: () {
                        // Handle TV show item tap
                      },
                      child: Container(
                        width: 150.0,
                        height: 200.0,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w200${show['poster_path']}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
