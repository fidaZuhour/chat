import 'package:chat/models/message_model.dart';

class Chat extends Comparable {
  int chatId;
  int senderId;
  Message recentMessage;
  List<Message> messgaes = [];

  Chat(this.chatId, this.senderId, this.recentMessage);

  @override
  int compareTo(other) {
    int nameComp = this.recentMessage.time.compareTo(other.recentMessage.time);
    if (nameComp == 0) {
      return this
          .recentMessage
          .time
          .compareTo(other.recentMessage.time); // '-' for descending
    }
    return nameComp;
  }
}
