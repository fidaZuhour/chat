import 'package:chat/models/chat_model.dart';
import 'package:chat/models/message_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import '../main.dart';

int maxIdC = 0;

class RealtimeFirebase {
  List<Message> recentMessages;

  final DBRef = FirebaseDatabase.instance.reference();
  DatabaseReference chatRef;

  void createUser(User user) {
    DBRef.child("users").child(user.name).set({
      "id": user.id,
      "name": user.name,
      "imageUrl": user.imageUrl,
      "isFavorite": user.isFavorite
    });
  }

  Future<void> createMessage(Message message) async {
    DBRef.child("messages").push().set({
      "chatId": message.chatId,
      "senderId": message.senderId,
      "time": message.time,
      "text": message.text,
      "isLiked": message.isLiked,
      "unread": message.unread
    });
  }

  void createChat(Chat chat) {
    chatRef = DBRef.child("chats").child("chat" + maxIdC.toString());
    chatRef.set({
      "chatId": maxIdC,
      "senderId": chat.senderId,
    });
    maxIdC++;
    createRecentMessage(chat, chat.recentMessage);
  }

  void createRecentMessage(Chat chat, Message recentMessage) {
    DBRef.child("chats")
        .child("chat" + chat.chatId.toString())
        .child("recentMessage")
        .set({
      "chatId": recentMessage.chatId,
      "senderId": recentMessage.senderId,
      "time": recentMessage.time,
      "text": recentMessage.text,
      "isLiked": recentMessage.isLiked,
      "unread": recentMessage.unread
    });
  }

  Future<List<User>> initilizeAllUsersList() async {
    DatabaseReference dataRef = DBRef.child("users");
    await dataRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      allUsers.clear();
      for (var key in KEYS) {
        User user = new User(DATA[key]['id'], DATA[key]['name'],
            DATA[key]['imageUrl'], DATA[key]['isFavorite']);
        allUsers.add(user);
      }
      return allUsers;
    });
  }

  void initilizefavoritesUsersList() {
    favoritesUsers.clear();
    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i].isFavorite) {
        favoritesUsers.add(allUsers[i]);
      }
    }
  }

  Future<List<Message>> initilizeMessagesList() async {
    DatabaseReference usersRef = DBRef.child("messages");
    await usersRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      messages.clear();
      for (var key in KEYS) {
        Message message = new Message(
          DATA[key]['chatId'],
          DATA[key]['senderId'],
          DATA[key]['time'],
          DATA[key]['text'],
          DATA[key]['isLiked'],
          DATA[key]['unread'],
        );
        messages.add(message);
        Chat chat = findChatById(message.chatId);
        chat.messgaes.add(message);
      }
    });
    return messages;
  }

  Future<Message> initilizeRecentMessage(int chatId) async {
    Message message;
    DatabaseReference usersRef = DBRef.child("chats")
        .child("chat" + chatId.toString())
        .child("recentMessage");
    await usersRef.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      message = new Message(
        DATA['chatId'],
        DATA['senderId'],
        DATA['time'],
        DATA['text'],
        DATA['isLiked'],
        DATA['unread'],
      );
      // recentMessages.add(message);
      Chat chat = findChatById(message.chatId);
      chat.messgaes.add(message);
    });
    return message;
  }

  Future<void> initilizeChatsList() async {
    DatabaseReference usersRef = DBRef.child("chats");
    await usersRef.once().then((DataSnapshot snap) async {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      chats.clear();
      for (var key in KEYS) {
        var chatId = DATA[key]['chatId'];
        var senderId = DATA[key]['senderId'];
        var KeyMsg = DATA[key]['recentMessage'];
        var time = KeyMsg['time'];
        var text = KeyMsg['text'];
        var isLiked = KeyMsg['isLiked'];
        var unread = KeyMsg['unread'];
        Message message = new Message(
          chatId,
          senderId,
          time,
          text,
          isLiked,
          unread,
        );
        Chat chat = new Chat(
          chatId,
          senderId,
          message,
        );
        chat.messgaes.add(message);
        chats.add(chat);
      }
    });
  }

  Chat findChatById(int chatId) {
    for (int i = 0; i < chats.length; i++) {
      if (chats[i].chatId == chatId) {
        return chats[i];
      }
    }
  }

  Future<void> updateUnread(Message recentMessage) async {
    await DBRef.child("chats")
        .child("chat" + recentMessage.chatId.toString())
        .child("recentMessage")
        .update({"unread": false});
  }

  Future<void> updateiIsLiked(Message message, bool isLiked) async {
    await DBRef.child("chats")
        .child("chat" + message.chatId.toString())
        .child("recentMessage")
        .update({"isLiked": isLiked});
  }
}
