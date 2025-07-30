import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmploymentInfoPage extends StatelessWidget {
  const EmploymentInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(child: Text('Employment Page')),
    );
  }
}
