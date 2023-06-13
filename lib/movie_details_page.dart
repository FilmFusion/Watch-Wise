import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsPage extends StatefulWidget {
  static const String routeName = '/movie-details';

  final dynamic movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late String? trailerUrl = null;

  @override
  void initState() {
    super.initState();
    fetchTrailer();
  }

  Future<void> fetchTrailer() async {
    final apiKey = '080184f9aad4105504265a00cf70d578';
    final movieId = widget.movie['id'];

    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final results = decodedResponse['results'];

      // Find the first trailer video key
      final trailerKey = results
          .firstWhere((video) => video['type'] == 'Trailer', orElse: () => {})['key'];

      setState(() {
        trailerUrl = 'https://www.youtube.com/watch?v=$trailerKey';
      });
    } else {
      // Handle API error
      print('Failed to fetch trailer: ${response.statusCode}');
    }
  }

  void playTrailer() {
    if (trailerUrl != null) {
      final videoId = YoutubePlayer.convertUrlToId(trailerUrl!);
      if (videoId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            ),
          ),
        );
      } else {
        // Handle invalid trailer URL
        print('Invalid trailer URL');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie['backdrop_path']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.movie['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: playTrailer,
              child: Text('Play Trailer'),
            ),
            SizedBox(height: 8),
            Text(
              'Release Date: ${widget.movie['release_date']}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Overview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              widget.movie['overview'],
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
