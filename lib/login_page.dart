import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

final Uri _url = Uri.parse('https://www.themoviedb.org/signup');
const String apiKey = '080184f9aad4105504265a00cf70d578';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watch Wise',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      home: LoginPage(),
      routes: {
        HomePage.routeName: (context) => HomePage(),
      },
    );
  }
}

class _LoginPageState extends State<LoginPage>{

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _requestToken = '';

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
          var _sessionId = sessionData['session_id'];
          Provider.of<SessionProvider>(context, listen: false).setSessionId(_sessionId);
        });

        print('Session created successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WatchWiseApp(),
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
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // logo
            Image.asset(
              'assets/watch-wise-dark-logo.png',
              scale: 1.5,
            ),

            const SizedBox(height: 30),

            // welcome back, you've been missed!
            Text(
              'Welcome back you\'ve been missed!',
              style: TextStyle(
                color: Colors.white, // Set text color to white
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // username textfield
            MyTextField(
              controller: _usernameController,
              hintText: 'Username',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // password textfield
            MyTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // forgot password?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // sign in button
            MyButton(
              onTap: _login,
            ),

            const SizedBox(height: 50),

            // or continue with

            const SizedBox(height: 50),

            // google + apple sign in buttons

            //const SizedBox(height: 50),



            // not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: _launchUrl,
                  child: Text(
                    'Register now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final Function()? onTap;

  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Sign In",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
