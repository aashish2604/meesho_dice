import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/chatbot/chatbot_chat_screen.dart';

class ChatBotFab extends StatefulWidget {
  final String initMessage;
  final int startingDelayInSeconds;
  final int containerLifeInSeconds;
  final double messageBoxWidth;
  const ChatBotFab(
      {super.key,
      this.messageBoxWidth = 120.0,
      required this.initMessage,
      this.startingDelayInSeconds = 2,
      required this.containerLifeInSeconds});

  @override
  State<ChatBotFab> createState() => _ChatBotFabState();
}

class _ChatBotFabState extends State<ChatBotFab>
    with SingleTickerProviderStateMixin {
  bool showContainer = true;
  double containerOpacity = 0.0; // Initial opacity set to 0 (invisible)
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  final int fadeInDurationInSeconds = 1;
  final int fadeOutDurationInSeconds = 1;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: fadeInDurationInSeconds),
      vsync: this,
    );

    // Set up opacity animation for initial fade-in
    _fadeInAnimation = Tween<double>(
      begin: 0.0, // Initial opacity (invisible)
      end: 1.0, // Final opacity (fully visible)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start the fade-in animation after a short delay
    Future.delayed(Duration(seconds: widget.startingDelayInSeconds), () {
      _controller.forward();
    });

    // Fade in the container by changing its opacity after a small delay
    Timer(Duration(seconds: fadeInDurationInSeconds), () {
      if (!mounted) return;
      setState(() {
        containerOpacity = 1.0; // Fully visible
      });
    });

    // After 3 seconds, hide the container
    Timer(Duration(seconds: widget.containerLifeInSeconds), () {
      if (!mounted) return;
      setState(() {
        showContainer = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize:
              MainAxisSize.min, // Keeps the row as compact as possible
          children: [
            AnimatedSwitcher(
              duration: Duration(seconds: fadeOutDurationInSeconds),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // Fade transition for entering and exiting widgets
                return FadeTransition(opacity: animation, child: child);
              },
              child: showContainer
                  ? FadeTransition(
                      opacity: _fadeInAnimation,
                      child: Card(
                        color: Color(0xFFF6CEFC),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16))),
                        elevation: 5.0,
                        key: ValueKey(1),
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          width: widget.messageBoxWidth,
                          child: Center(
                            child: Text(
                              widget.initMessage,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(
                      key: ValueKey(
                          2), // Key to differentiate between the widgets
                    ),
            ),

            const SizedBox(width: 3), // Add some spacing between buttons
            FloatingActionButton(
              shape: const CircleBorder(
                  side: BorderSide(color: kMeeshoMustard, width: 1.6)),
              backgroundColor: kMeeshoPurple,
              heroTag: 'chatBotFab',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChatBotChatScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Image(image: AssetImage("assets/images/chatbot.png")),
                ),
              ),
            )
          ]),
    );
  }
}
