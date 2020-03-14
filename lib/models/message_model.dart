import 'package:chat/models/user_model.dart';

class Message {
  int chatId;
  int senderId;
  String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  String text;
  bool isLiked;
  bool unread;

  Message(this.chatId, this.senderId, this.time, this.text, this.isLiked,
      this.unread);
}

// YOU - current user
final User currentUser =
    User(0, 'Current User', 'assets/images/greg.jpg', false);
