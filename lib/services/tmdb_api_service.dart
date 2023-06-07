import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApiService {
  static const String _apiKey = '080184f9aad4105504265a00cf70d578';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<dynamic> _get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint?api_key=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to retrieve data from TMDB API: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getPopularMovies() async {
    try {
      final endpoint = '/movie/popular';
      final result = await _get(endpoint);
      return result['results'];
    } catch (e) {
      throw Exception('Error fetching popular movies: $e');
    }
  }

  Future<List<dynamic>> getTopRatedMovies() async {
    try {
      final endpoint = '/movie/top_rated';
      final result = await _get(endpoint);
      return result['results'];
    } catch (e) {
      throw Exception('Error fetching top rated movies: $e');
    }
  }

  Future<List<dynamic>> getTrendingMovies() async {
    try {
      final endpoint = '/trending/movie/week';
      final result = await _get(endpoint);
      return result['results'];
    } catch (e) {
      throw Exception('Error fetching trending movies: $e');
    }
  }

  Future<List<dynamic>> searchMovies(String query) async {
    try {
      final endpoint = '/search/movie?query=$query';
      final result = await _get(endpoint);
      return result['results'];
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  Future<List<dynamic>> getPopularTVSeries() async {
    try {
      final endpoint = '/tv/popular';
      final result = await _get(endpoint);
      return result['results'];
    } catch (e) {
      throw Exception('Error fetching popular TV series: $e');
    }
  }

  Future<List<dynamic>> getTopRatedTVSeries() async {
    try {
      final endpoint = '/tv/top_rated';
      final result = await _get(endpoint);
      return result['results'];
    } catch (e) {
      throw Exception('Error fetching top rated TV series: $e');
    }
  }

  Future<List<dynamic>> getTrendingTVSeries() async {
    try {
      final endpoint = '/trending/tv/week';
      final result = await _get(endpoint);
      return result['results'];
    } catch (e) {
      throw Exception('Error fetching trending TV series: $e');
    }
  }

  Future<List<dynamic>> searchTVSeries(String query) async {
    try {
      final endpoint = '/search/tv?query=$query';
      final result = await _get(endpoint);
      return result['results'];
    } catch (e) {
      throw Exception('Error searching TV series: $e');
    }
  }
}
