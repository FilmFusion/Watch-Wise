import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_page.dart';
import 'settings_page.dart';
import 'movie_page.dart';

void main() {
  runApp(WatchWiseApp());
}

class WatchWiseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watch Wise',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      home: HomePage(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        SettingsPage.routeName: (context) => SettingsPage(),
        MoviesPage.routeName: (context) => MoviesPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> trendingMovies = [];
  List<dynamic> topRatedMovies = [];
  Map<int, String> genresMap = {};

  @override
  void initState() {
    super.initState();
    fetchGenres().then((genres) {
      setState(() {
        genresMap = genres;
      });
    });
    fetchTrendingMovies().then((movies) {
      setState(() {
        trendingMovies = movies;
      });
    });
    fetchTopRatedMovies().then((movies) {
      setState(() {
        topRatedMovies = movies;
      });
    });
  }

  Future<Map<int, String>> fetchGenres() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> genresData = jsonResponse['genres'];

      return Map<int, String>.fromIterable(genresData,
          key: (genre) => genre['id'], value: (genre) => genre['name']);
    } else {
      throw Exception('Failed to load genres');
    }
  }


  Future<List<dynamic>> fetchTrendingMovies() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results'];
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<dynamic>> fetchTopRatedMovies() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['results'];
    } else {
      throw Exception('Failed to load top-rated movies');
    }
  }

  void _showMovieDetails(dynamic movie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.movie,
                      size: 24.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      movie['title'],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.0,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      movie['release_date'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Text(
                  'Genres: ${_getMovieGenres(movie)}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                if (movie['runtime'] != null)
                  Text(
                    'Length: ${movie['runtime']} minutes',
                    style: TextStyle(fontSize: 16.0),
                  ),
                SizedBox(height: 8.0),
                Text(
                  'Overview:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  movie['overview'],
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  String _getMovieGenres(dynamic movie) {
    final genreIds = List<int>.from(movie['genre_ids']);
    final genres = genreIds.map((id) => genresMap[id]).toList();
    return genres.join(', ');
  }


  void navigateToSettingsPage(BuildContext context) {
    Navigator.pushNamed(context, SettingsPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch Wise'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              navigateToSettingsPage(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top part with logo, profile icon, and settings icon
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile icon
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 32.0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  // App logo
                  Image.asset(
                    'assets/app_logo_dark.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  // Settings icon
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      navigateToSettingsPage(context);
                    },
                  ),
                ],
              ),
            ),
            // "Trending" text
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Middle part with trending movies
            SizedBox(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trendingMovies.length,
                itemBuilder: (context, index) {
                  final movie = trendingMovies[index];
                  return GestureDetector(
                    onTap: () {
                      _showMovieDetails(movie);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w200/${movie['poster_path']}',
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Top Rated',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Middle part with top-rated movies
            SizedBox(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topRatedMovies.length,
                itemBuilder: (context, index) {
                  final movie = topRatedMovies[index];
                  return GestureDetector(
                    onTap: () {
                      _showMovieDetails(movie);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w200/${movie['poster_path']}',
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom part with icons and text
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home icon and text
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          // Handle home icon button press
                        },
                      ),
                      Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  // Movies icon and text
                  // Movies icon and text
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.movie,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, MoviesPage.routeName);
                        },
                      ),
                      Text(
                        'Movies',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  // TV shows icon and text
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.tv,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          // Handle TV shows icon button press
                        },
                      ),
                      Text(
                        'TV Shows',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  // Search icon and text
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () {
                          // Handle search icon button press
                        },
                      ),
                      Text(
                        'Search',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
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
