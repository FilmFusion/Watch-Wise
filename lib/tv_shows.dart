import 'package:WatchWise/main.dart';
import 'package:WatchWise/search_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'movie_page.dart';

const String apiKey = '080184f9aad4105504265a00cf70d578';

class TVShowsPage extends StatefulWidget {
  static const routeName = '/tvshows';

  @override
  _TVShowsPageState createState() => _TVShowsPageState();
}

class _TVShowsPageState extends State<TVShowsPage> {
  List<Map<String, dynamic>> trendingTVShows = [];
  List<Map<String, dynamic>> airingTodayTVShows = [];
  List<Map<String, dynamic>> onTVTVShows = [];
  List<Map<String, dynamic>> popularTVShows = [];
  List<Map<String, dynamic>> topRatedTVShows = [];

  @override
  void initState() {
    super.initState();
    fetchTVShows();
  }

  Future<void> fetchTVShows() async {
    await fetchTrendingTVShows();
    await fetchAiringTodayTVShows();
    await fetchOnTVTVShows();
    await fetchPopularTVShows();
    await fetchTopRatedTVShows();
  }

  Future<void> fetchTrendingTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/trending/tv/week?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        trendingTVShows = results
            .map((show) => {
          'name': show['name'],
          'poster_path': show['poster_path'],
          'first_air_date': show['first_air_date'],
          'genre': '',
          'overview': show['overview'],
        })
            .toList();
      });
    } else {
      // Error handling
    }
  }

  Future<void> fetchAiringTodayTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/airing_today?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        airingTodayTVShows = results
            .map((show) => {
          'name': show['name'],
          'poster_path': show['poster_path'],
          'first_air_date': show['first_air_date'],
          'genre': '',
          'overview': show['overview'],
        })
            .toList();
      });
    } else {
      // Error handling
    }
  }

  Future<void> fetchOnTVTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apiKey';


    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        onTVTVShows = results
            .map((show) => {
          'name': show['name'],
          'poster_path': show['poster_path'],
          'first_air_date': show['first_air_date'],
          'genre': '',
          'overview': show['overview'],
        })
            .toList();
      });
    } else {
      // Error handling
    }
  }

  Future<void> fetchPopularTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        popularTVShows = results
            .map((show) => {
          'name': show['name'],
          'poster_path': show['poster_path'],
          'first_air_date': show['first_air_date'],
          'genre': '',
          'overview': show['overview'],
        })
            .toList();
      });
    } else {
      // Error handling
    }
  }

  Future<void> fetchTopRatedTVShows() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final url = 'https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey';


    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        topRatedTVShows = results
            .map((show) => {
          'name': show['name'],
          'poster_path': show['poster_path'],
          'first_air_date': show['first_air_date'],
          'genre': show['genre'],
          'overview': show['overview'],
        })
            .toList();
      });
    } else {
      // Error handling
    }
  }
  void navigateToHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.routeName);
  }

  void navigateToSearchPage(BuildContext context) {
    Navigator.pushNamed(context, SearchPage.routeName);
  }

  void navigateToTVShowsPage(BuildContext context) {
    Navigator.pushNamed(context, TVShowsPage.routeName);
  }

  void navigateToMoviesPage(BuildContext context) {
    Navigator.pushNamed(context, MoviesPage.routeName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Trending', trendingTVShows),
            _buildSection('Airing Today', airingTodayTVShows),
            _buildSection('On TV', onTVTVShows),
            _buildSection('Popular', popularTVShows),
            _buildSection('Top Rated', topRatedTVShows),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
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
              navigateToMoviesPage(context);
              break;
            case 2:
              break;
            case 3:
              navigateToSearchPage(context);
              break;
          }
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> shows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: shows.length,
            itemBuilder: (ctx, index) {
              final show = shows[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TVShowDetailsPage(show: show),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500/${show['poster_path']}',
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        show['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TVShowDetailsPage extends StatelessWidget {
  final Map<String, dynamic> show;

  const TVShowDetailsPage({Key? key, required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(show['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500/${show['poster_path']}',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Release Date: ${show['first_air_date']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Overview:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    show['overview'],
                    style: TextStyle(fontSize: 16),
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