import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:netflix_demo/screens/movie_details_screen.dart';
import 'package:netflix_demo/screens/tvseries_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  String _selectedCategory = 'all'; // Default category is 'all'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMoviesAndTVSeries(String query, String category, String sortBy, String releaseDate, String certification) async {
    final String apiKey = "080184f9aad4105504265a00cf70d578"; // Replace with your TMDB API key
    final String baseUrl = 'https://api.themoviedb.org/3';

    String searchUrl = '$baseUrl/search/multi?api_key=$apiKey&query=$query';

    if (category != 'all') {
      searchUrl += '&with_genres=$category';
    }

    if (sortBy.isNotEmpty) {
      searchUrl += '&sort_by=$sortBy';
    }

    if (releaseDate.isNotEmpty) {
      searchUrl += '&primary_release_date.gte=$releaseDate';
    }

    if (certification.isNotEmpty) {
      searchUrl += '&certification=$certification';
    }

    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final searchData = jsonDecode(response.body);

      setState(() {
        _searchResults = searchData['results'];
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search movies or TV series',
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              _searchMoviesAndTVSeries(query, _selectedCategory, '', '', '');
            } else {
              setState(() {
                _searchResults = [];
              });
            }
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedCategory = value;
              });
              _searchMoviesAndTVSeries(
                _searchController.text,
                _selectedCategory,
                value == 'popularity' ? 'popularity.desc' : '',
                value == 'latest' ? '2021-01-01' : '',
                value == 'pg13' ? 'pg-13' : '',
              );
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'all',
                child: Text('All'),
              ),
              PopupMenuItem<String>(
                value: '28',
                child: Text('Action'),
              ),
              PopupMenuItem<String>(
                value: '35',
                child: Text('Comedy'),
              ),
              PopupMenuItem<String>(
                value: '18',
                child: Text('Drama'),
              ),
              PopupMenuItem<String>(
                value: 'popularity',
                child: Text('Sort by Popularity'),
              ),
              PopupMenuItem<String>(
                value: 'latest',
                child: Text('Sort by Latest Release'),
              ),
              PopupMenuItem<String>(
                value: 'pg13',
                child: Text('Certification: PG-13'),
              ),
              // Add more categories and search options as needed
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final item = _searchResults[index];
          final title = item['title'] ?? item['name'];
          final imageUrl = 'https://image.tmdb.org/t/p/w500${item['poster_path']}';
          final isMovie = item['media_type'] == 'movie';

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
                  builder: (context) => isMovie
                      ? MovieDetailsScreen(
                    title: title,
                    imageUrl: imageUrl,
                    description: item['overview'],
                    releaseDate: item['release_date'],
                    rating: item['vote_average'],
                  )
                      : TVSeriesDetailsScreen(
                    title: title,
                    imageUrl: imageUrl,
                    description: item['overview'],
                    releaseDate: item['first_air_date'],
                    rating: item['vote_average'],
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
