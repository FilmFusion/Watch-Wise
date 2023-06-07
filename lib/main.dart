// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


const String apiKey = '080184f9aad4105504265a00cf70d578';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMDb Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _requestToken = '';
  String _sessionId = '';

  @override
  void initState() {
    super.initState();
    _getRequestToken();
  }

  Future<void> _getRequestToken() async {

    const baseUrl = 'https://api.themoviedb.org/3/authentication/token/new';
    final response = await http.get(Uri.parse('$baseUrl?api_key=$apiKey'));


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _requestToken = data['request_token'];
      });
    } else {
      // Handle error response
      print('Failed to generate request token');
    }
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    const authenticationUrl =
        'https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$apiKey';

    final loginResponse = await http.post(Uri.parse(authenticationUrl),
        body: {
          'username': username,
          'password': password,
          'request_token': _requestToken,
        });

    if (loginResponse.statusCode == 200) {
      final data = jsonDecode(loginResponse.body);
      final loginValidationToken = data['request_token'];

      final sessionResponse = await http.post(Uri.parse(
          'https://api.themoviedb.org/3/authentication/session/new?api_key=$apiKey'),
          body: {
            'request_token': loginValidationToken,
          });

      if (sessionResponse.statusCode == 200) {
        final sessionData = jsonDecode(sessionResponse.body);
        setState(() {
          _sessionId = sessionData['session_id'];
        });

        print('Session created successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WatchlistPage(sessionId: _sessionId),
          ),
        );
      } else {
        // Handle error response

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to create session'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle error response
      print('Login failed');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Login failed'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDb Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Session ID: $_sessionId',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WatchlistPage extends StatefulWidget {
  final String sessionId;

  const WatchlistPage({required this.sessionId});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  late int _accountId;
  TextEditingController searchController = TextEditingController();
  List<Movie> searchResults = [];
  List<Movie> myWatchlist = [];


  @override
  void initState() {
    super.initState();
    _getAccountId();
  }

  Future<void> _getAccountId() async {
    final url = Uri.https('api.themoviedb.org', '/3/account', {
      'api_key': apiKey,
      'session_id': widget.sessionId,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final accountData = jsonDecode(response.body);

      setState(() {
        _accountId = accountData['id'];
      });

      print('Account ID: $_accountId');
    } else {
      throw Exception('Failed to fetch account details');
    }
  }


  Future<void> searchMovies() async {
    const String baseUrl = 'https://api.themoviedb.org/3/search/movie';
    final query = searchController.text;

    final response = await http.get(Uri.parse(
        '$baseUrl?api_key=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];

      List<Movie> movies = [];

      for (var result in results) {
        movies.add(
          Movie(
            id: result['id'],
            title: result['title'],
            releaseDate: result['release_date'],
            posterPath: result['poster_path'],
          ),
        );
      }

      setState(() {
        searchResults = movies;
      });
    }
  }


  Future<void> _addToWatchlist(int movieId) async {

    final url = Uri.https('api.themoviedb.org', '/3/account/$_accountId/watchlist', {
      'api_key': apiKey,
      'session_id': widget.sessionId,
    });

    final response = await http.post(
      url,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': true,
      }),
    );

    if (response.statusCode == 201) {
      print('Movie added to watchlist successfully');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Movie added to watchlist successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle error response
      print('Failed to add movie to watchlist');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to add movie to watchlist'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
      );
    }
  }

  Future<void> _fetchWatchlist() async {
    final url = Uri.https('api.themoviedb.org', '/3/account/$_accountId/watchlist/movies', {
      'api_key': apiKey,
      'session_id': widget.sessionId,
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final watchlistData = jsonDecode(response.body);

      final results = watchlistData['results'];

      List<Movie> movies = [];

      for (var result in results) {
        movies.add(
          Movie(
            id: result['id'],
            title: result['title'],
            releaseDate: result['release_date'],
            posterPath: result['poster_path'],
          ),
        );
      }

      setState(() {
       myWatchlist  = movies;
      });
    print("success!");
    _viewWatchlist();
    } else {
      throw Exception('Failed to fetch watchlist');
    }
  }

  void _viewWatchlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MylistPage(MyWatchList: myWatchlist,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


      return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search Movies'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: searchMovies,
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: _fetchWatchlist,
              child: const Text('View My Watchlist'),
            ),

            const SizedBox(height: 16.0),

            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchResults[index].title),
                    subtitle: Text(searchResults[index].releaseDate),
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w200${searchResults[index].posterPath}',
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    trailing: IconButton(
                      onPressed: () => _addToWatchlist(searchResults[index].id),
                      icon: const Icon(Icons.add),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class MylistPage extends StatefulWidget {
  final List<Movie>MyWatchList;

  MylistPage({required this.MyWatchList});

  @override
  _MylistPageState createState() => _MylistPageState();
}

class _MylistPageState extends State<MylistPage> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watch List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Expanded(
              child: ListView.builder(
                itemCount: widget.MyWatchList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.MyWatchList[index].title),
                    subtitle: Text(widget.MyWatchList[index].releaseDate),
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w200${widget.MyWatchList[index].posterPath}',
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),

                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class Movie {
  final int id;
  final String title;
  final String releaseDate;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.posterPath,
  });
}