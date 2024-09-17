import 'package:flutter/material.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "Game Zone",
          style: appBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Center(
              child: CircleAvatar(
                radius: 80,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              "Aashish",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const LeaderboardContainer(),
            const SizedBox(
              height: 10.0,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "Games",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 140),
                children: [
                  Card(
                    child: ListTile(
                      onTap: () {
                        launchUrl(Uri.parse('https://flappy-bird.co/'),
                            mode: LaunchMode.inAppWebView);
                      },
                      title: const GameListTileContent(
                          name: "Flappy Bird", imageUrl: "imageUrl"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        launchUrl(Uri.parse('https://wordleunlimited.org/'),
                            mode: LaunchMode.inAppWebView);
                      },
                      title: const GameListTileContent(
                          name: "Wordle", imageUrl: "imageUrl"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        launchUrl(Uri.parse('https://pacman.live/play.html'),
                            mode: LaunchMode.inAppWebView);
                      },
                      title: const GameListTileContent(
                          name: "Pacman", imageUrl: "imageUrl"),
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
                      title: const GameListTileContent(
                          name: "Tetris", imageUrl: "imageUrl"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

class LeaderboardContainer extends StatelessWidget {
  const LeaderboardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(224, 242, 147, 255).withOpacity(0.3),
      padding: const EdgeInsets.all(10.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 12.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Leaderboard",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 12.0,
              // ),
              DataTable(
                  // Datatable widget that have the property columns and rows.
                  columns: [
                    // Set the name of the column
                    DataColumn(
                      label: Text('Game'),
                    ),
                    DataColumn(
                      label: Text('Username'),
                    ),
                    DataColumn(
                      label: Text('Score'),
                    ),
                  ],
                  rows: [
                    // Set the values to the columns
                    DataRow(cells: [
                      DataCell(Text("Flappy Birds")),
                      DataCell(Text("Aashish")),
                      DataCell(Text("82")),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Wordle")),
                      DataCell(Text("Ankit")),
                      DataCell(Text("8")),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Pacman")),
                      DataCell(Text("Muskan")),
                      DataCell(Text("6")),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("Tetris")),
                      DataCell(Text("Aashish")),
                      DataCell(Text("12")),
                    ]),
                  ]),
            ],
          )),
    );
  }
}

class GameListTileContent extends StatelessWidget {
  final String name;
  final String imageUrl;
  const GameListTileContent(
      {super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 12.0,
            ),
          )
        ],
      ),
    );
  }
}
