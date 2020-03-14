import 'package:chat/models/chat_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class RecentChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    chats.sort();
    return Expanded(
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
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final Chat chat = chats[index];
              final User user = findUserById(chat.senderId);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        user: user,
                      ),
                    ),
                  );

                  realtimeFirebase.updateUnread(chat.recentMessage);
                  chat.recentMessage.unread = false;
                },
                child: Container(
                  margin: EdgeInsets.only(top: 3.0, bottom: 2.0, right: 10.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: chat.recentMessage.unread
                        ? Color(0xFFFFEFEE)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage: AssetImage(user.imageUrl),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                user.name,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  chat.recentMessage.text,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            chat.recentMessage.time,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          chat.recentMessage.unread
                              ? Container(
                                  width: 40.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Text(''),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  User findUserById(int id) {
    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i].id == id) {
        return allUsers[i];
      }
    }
    return null;
  }
}
