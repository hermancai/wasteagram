import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PostSingleView extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> data;

  const PostSingleView({Key? key, required this.data}) : super(key: key);

  double _fractionScreenHeight(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.height * fraction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Wasteagram", 
            style: TextStyle(fontSize: 24)
          ),
        centerTitle: true,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat.yMMMMEEEEd().format(data.get("date").toDate()),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: _fractionScreenHeight(context, 0.4),
              child: Semantics(
                child: Image.network(data.get("imageURL")),
                label: "Picture of post",
                image: true,
              )
            ),
            const SizedBox(height: 40),
            Text(
              "Items: " + data.get("quantity").toString(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("Location:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text(
              data.get("latitude").toString() + ", " + data.get("longitude").toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      )
    );
  }
}
