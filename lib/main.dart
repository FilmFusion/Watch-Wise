import 'package:flutter/material.dart';

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
    );
  }
}

class HomePage extends StatelessWidget {
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
              // Handle settings icon button press
            },
          ),
        ],
      ),
      body: Column(
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
                    // Handle profile icon button press
                  },
                ),
                // App logo
                Image.asset(
                  'assets/app_logo.png',
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
                    // Handle settings icon button press
                  },
                ),
              ],
            ),
          ),
          // Middle part with ListView
          Expanded(
            child: ListView(
              children: [
                // Replace these containers with your desired scrollable content
                Container(
                  height: 200,
                  color: Colors.red,
                  margin: EdgeInsets.all(16.0),
                ),
                Container(
                  height: 200,
                  color: Colors.blue,
                  margin: EdgeInsets.all(16.0),
                ),
                Container(
                  height: 200,
                  color: Colors.green,
                  margin: EdgeInsets.all(16.0),
                ),
                Container(
                  height: 200,
                  color: Colors.yellow,
                  margin: EdgeInsets.all(16.0),
                ),
              ],
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
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.movie,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      onPressed: () {
                        // Handle movies icon button press
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
    );
  }
}
