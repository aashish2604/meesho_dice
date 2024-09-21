import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meesho_dice/repository/dialogflow_chatbot_repository.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/app_consts.dart';
import 'package:meesho_dice/utils/chatbot_chats.dart';
import 'package:meesho_dice/widgets/loading.dart';

class ChatBotChatScreen extends StatefulWidget {
  const ChatBotChatScreen({super.key});

  @override
  State<ChatBotChatScreen> createState() => _ChatBotChatScreenState();
}

class _ChatBotChatScreenState extends State<ChatBotChatScreen> {
  late DialogFlowtter dialogFlowtter;
  late DialogflowChatbotRepository chatbotRepository;
  final TextEditingController _controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    dialogFlowtter = DialogFlowtter();
    chatbotRepository =
        DialogflowChatbotRepository(dialogFlowtter: dialogFlowtter);
    _scrollToBottom();
    super.initState();
  }

  Future initalDelayScroll() async {
    await Future.delayed(Duration(seconds: 2));
    _scrollToBottom(duration: Duration(seconds: 3));
  }

  void _scrollToBottom(
      {Duration duration = const Duration(milliseconds: 300)}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: duration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Chatbot",
              style: appBarTextStyle,
            ),
          ),
          body: Column(
            children: [
              MessageArea(
                scrollController: scrollController,
              ),
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25)),
                            hintText: 'Type your message here..',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 50,
                        child: FloatingActionButton(
                          backgroundColor: Colors.purple,
                          onPressed: () async {
                            if (_controller.text.isNotEmpty) {
                              FocusScope.of(context).unfocus();
                              String message = _controller.text;
                              _controller.clear();
                              setState(() {
                                chatbotRepository.addMessage(
                                    Message(text: DialogText(text: [message])),
                                    true);
                                _scrollToBottom();
                              });
                              final response = await chatbotRepository
                                  .getDialogFlowResponse(message);
                              if (response.message != null) {
                                setState(() {
                                  chatbotRepository.removeUserMessageFlag();
                                  chatbotRepository
                                      .addMessage(response.message!);
                                  _scrollToBottom();
                                });
                              } else {
                                setState(() {
                                  chatbotRepository.removeUserMessageFlag();
                                  _scrollToBottom();
                                  Fluttertoast.showToast(
                                      msg:
                                          "Some error occured. Check your internet and retry");
                                });
                              }
                            } else {
                              Fluttertoast.showToast(msg: "Type something...");
                            }
                          },
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}

class MessageArea extends StatelessWidget {
  final ScrollController scrollController;
  const MessageArea({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return chatbotChats.isEmpty
        ? Expanded(
            child: const Center(
              child: Text("Ask Something"),
            ),
          )
        : Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: chatbotChats.length,
                itemBuilder: (context, index) {
                  // return Text(chatbotChats[index]["message"].text?.text?.first);
                  bool isMe = chatbotChats[index]["isUserMessage"];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      !isMe
                          ? Padding(
                              padding: EdgeInsets.only(left: 6, top: 10),
                              child: CircleAvatar(
                                radius: 20.0,
                                backgroundImage:
                                    AssetImage("assets/images/chatbot.png"),
                              ),
                            )
                          : SizedBox(
                              height: 0,
                              width: 0,
                            ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(maxWidth: 300),
                        decoration: BoxDecoration(
                          borderRadius: isMe
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15))
                              : const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                          color: isMe
                              ? Colors.purple
                              : Colors.purple.shade100.withOpacity(0.5),
                        ),
                        child: ChatBubbleContent(
                            isMe: isMe,
                            message: chatbotChats[index]["message"]
                                .text
                                ?.text
                                ?.first),
                      )
                    ],
                  );
                }),
          );
  }
}

class ChatBubbleContent extends StatelessWidget {
  final bool isMe;
  final String message;
  const ChatBubbleContent(
      {super.key, required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message == kUserMessageFlagInBotChatPage) {
      return const Center(
          child: SpinKitThreeBounce(
        color: Colors.black54,
        size: 20,
        duration: Duration(seconds: 1),
      ));
    }
    return Text(
      message,
      style: TextStyle(fontSize: 17, color: isMe ? Colors.white : Colors.black),
    );
  }
}
