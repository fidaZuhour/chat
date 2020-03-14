import 'package:chat/models/chat_model.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/services/realtime_firebase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  User user;

  ChatScreen({this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
Chat chat;
Chat findChadById(int id) {
  for (int i = 0; i < chats.length; i++) {
    if (chats[i].senderId == id) return chats[i];
  }
}

class _ChatScreenState extends State<ChatScreen> {
  var _firebaseRef = FirebaseDatabase().reference().child('chats');
  RealtimeFirebase realtimeFirebase = RealtimeFirebase();
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  _sendMessage(Message message) async {
    if (messageController.text.length > 0) {
      await realtimeFirebase.createMessage(message);
      await realtimeFirebase.createRecentMessage(chat, message);
    }
    messageController.clear();
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: message.isLiked
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: message.isLiked
              ? Theme.of(context).primaryColor
              : Colors.blueGrey,
          onPressed: () {
            bool isLiked = message.isLiked;
            setState(() {
              message.isLiked = !isLiked;
            });

            realtimeFirebase.updateiIsLiked(message, isLiked);
          },
        )
      ],
    );
  }

  _buildMessageComposer() {
    chat = findChadById(widget.user.id);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              // todo
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            // todo
            onPressed: () {
              var time = new DateFormat("hh:mm a").format(DateTime.now());
              Message message = Message(chat.chatId, currentUser.id, time,
                  messageController.text, false, true);
              chat.messgaes.add(message);
              chat.recentMessage = message;
              _sendMessage(message);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Chat chat = findChadById(widget.user.id);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          widget.user.name,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: StreamBuilder(
                        stream: _firebaseRef.onValue,
                        builder: (context, snap) {
                          return ListView.builder(
                            controller: scrollController,
                            // reverse: true,
                            padding: EdgeInsets.only(top: 15.0),
                            itemCount: chat.messgaes.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Message message = chat.messgaes[index];
                              final bool isMe =
                                  message.senderId == currentUser.id;
                              return _buildMessage(message, isMe);
                            },
                          );
                        })),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
