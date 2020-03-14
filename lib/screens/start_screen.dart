import 'package:chat/loading.dart';
import 'package:chat/screens/home_screen.dart';
import 'package:chat/services/realtime_firebase.dart';
import 'package:flutter/material.dart';

class StartChating extends StatefulWidget {
  @override
  _StartChatingState createState() => _StartChatingState();
}

class _StartChatingState extends State<StartChating> {
  @override
  RealtimeFirebase realtimeFirebase = new RealtimeFirebase();
  bool loading = false;

  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              child: RaisedButton(
                child: Text("Start chat"),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  // read all data from firebase
                  await realtimeFirebase.initilizeAllUsersList();
                  await realtimeFirebase.initilizeChatsList();
                  await realtimeFirebase.initilizeMessagesList();
                  realtimeFirebase.initilizefavoritesUsersList();

                  setState(() {
                    loading = false;
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
            ),
          );
  }
}
