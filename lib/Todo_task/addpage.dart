import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Addpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Text(
          'This is the Second Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
