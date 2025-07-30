import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {
            context.push('/employment');
          },
        ),
      ),
      body: Center(child: Text('Home Page')),
    );
  }
}
