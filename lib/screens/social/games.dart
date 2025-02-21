import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/app_consts.dart';
import 'package:meesho_dice/widgets/chatbot/chatbot_fab.dart';
import 'package:url_launcher/url_launcher.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  Map<String, dynamic>? userDetails;

  Future getUserData() async {
    final userData = await FirebaseServices().getUserDetails();
    setState(() {
      userDetails = userData;
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ChatBotFab(
          initMessage:
              "Be on the top of the leaderboard to win exclusive rewards",
          containerLifeInSeconds: 6),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
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
                backgroundImage: userDetails == null
                    ? null
                    : CachedNetworkImageProvider(userDetails!["image"]),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              userDetails == null ? "" : userDetails!["username"],
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                          name: "Flappy Bird",
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Fic_launcher%20(2).png?alt=media&token=4ba3bfde-cd50-4f0f-80bd-c550af7603ee"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        launchUrl(Uri.parse('https://wordleunlimited.org/'),
                            mode: LaunchMode.inAppWebView);
                      },
                      title: const GameListTileContent(
                          name: "Wordle",
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Foutput-onlinepngtools-fotor-20240921132321.png?alt=media&token=8486f723-efe9-4ae6-801f-2b5594994b65"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        launchUrl(Uri.parse('https://pacman.live/play.html'),
                            mode: LaunchMode.inAppWebView);
                      },
                      title: const GameListTileContent(
                          name: "Pacman",
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Fic_launcher%20(4).png?alt=media&token=39b2cf70-9270-4e4e-8c02-a62dd3fa1e09"),
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
                          name: "Tetris",
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Fic_launcher%20(6).png?alt=media&token=f5f8f194-07e4-4cab-9440-4bbb7685a511"),
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
                  columns: const [
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
            backgroundImage: CachedNetworkImageProvider(imageUrl),
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
