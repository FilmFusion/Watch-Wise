import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:netflix_demo/screens/popular_movies_screen.dart';
import 'package:netflix_demo/screens/top_rated_movies_screen.dart';
import 'package:netflix_demo/screens/search_screen.dart';
import 'package:netflix_demo/screens/user_profile_screen.dart';
import 'package:netflix_demo/screens/popular_tvseries_screen.dart';
import 'package:netflix_demo/screens/top_rated_tvseries_screen.dart';

class HomeScreen extends StatelessWidget {
  final bool darkModeEnabled;
  final Function(bool?) toggleDarkMode;

  HomeScreen({
    required this.darkModeEnabled,
    required this.toggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(
              darkModeEnabled ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              toggleDarkMode(!darkModeEnabled);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.movie),
            title: Text('Popular Movies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PopularMoviesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Top Rated Movies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TopRatedMoviesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.tv),
            title: Text('Popular TV Series'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PopularTVSeriesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Top Rated TV Series'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TopRatedTVSeriesScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(
                    username: 'FrF',
                    email: 'farhanfuad@iut-dhaka.edu',
                    profileImage: 'https://example.com/profile.jpg',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
