import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: SpinKitHourGlass(
          color: Colors.amber[100],
          size: 50.0,
        ),
      ),
    );
  }
}
