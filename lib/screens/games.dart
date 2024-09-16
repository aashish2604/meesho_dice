import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recreation center"),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                launchUrl(Uri.parse('https://pacman.live/play.html'),
                    mode: LaunchMode.inAppWebView);
              },
              title: Text("Pac Man"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                launchUrl(
                    Uri.parse(
                        'https://tetris.com/games-content/play-tetris-content/index-mobile.php'),
                    mode: LaunchMode.inAppWebView);
              },
              title: Text("Tetris"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                launchUrl(Uri.parse('https://flappy-bird.co/'),
                    mode: LaunchMode.inAppWebView);
              },
              title: Text("Flappy Birds"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                launchUrl(Uri.parse('https://wordleunlimited.org/'),
                    mode: LaunchMode.inAppWebView);
              },
              title: Text("Wordle"),
            ),
          ),
        ],
      ),
    );
  }
}
