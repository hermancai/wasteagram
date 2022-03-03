import 'package:flutter/material.dart';
import 'screens/post_list.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Wasteagram", 
            style: TextStyle(fontSize: 24)
          ),
          centerTitle: true,
        ),
        body: const PostList(),
      )
    );
  }
}
