import 'package:chat/models/chat_model.dart';
import 'package:chat/screens/start_screen.dart';
import 'package:chat/services/realtime_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/message_model.dart';
import 'models/user_model.dart';

RealtimeFirebase realtimeFirebase = new RealtimeFirebase();
List<User> allUsers = new List();
List<User> favoritesUsers = new List();
List<Message> messages = new List();
List<Chat> chats = new List();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('ar'), // Arabic
      ],
      title: 'Flutter Chat'
          '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Color(0xFFFEF9EB),
      ),
      home: StartChating(),
    );
  }
}
