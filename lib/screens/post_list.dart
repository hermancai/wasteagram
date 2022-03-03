import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'new_post.dart';
import 'post_single_view.dart';

class PostList extends StatefulWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  Widget listOfPosts() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("posts").orderBy("date", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        return data.size == 0 
          ? const Center(
              child: Text(
                "No posts!", 
                style: TextStyle(fontSize: 30, color: Colors.green),
              )
            )
          : ListView.separated(
              itemCount: data.size,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    DateFormat.yMMMMEEEEd().format(data.docs[index].get("date").toDate()),
                    style: const TextStyle(fontSize: 22),
                  ),
                  trailing: Text(
                    data.docs[index].get("quantity").toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => PostSingleView(data: data.docs[index])
                      )
                    );
                  },
                );
            }
          );
      }
    );
  }

  Future getImage() async {
    var picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: ((context) => NewPost(image: image)))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: listOfPosts()),
        ElevatedButton(
          child: const Icon(Icons.camera_alt),
          onPressed: () { getImage(); },
        )
      ],
    );
  }
}
