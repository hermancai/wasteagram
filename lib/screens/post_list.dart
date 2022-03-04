import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'new_post.dart';
import 'post_single_view.dart';
import '../widgets/camera_button.dart';

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

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return _listViewBuilder(snapshot.requireData);
      }
    );
  }

  Widget _listViewBuilder(QuerySnapshot<Object?> data) {
    return ListView.separated(
      itemCount: data.size,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return Semantics(
          child: ListTile(
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
          ),
          label: "Post tile",
          onTapHint: "Press to see post details",
          enabled: true,
        );
      }
    );
  }

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
        CameraButton(tapEvent: getImage),
      ],
    );
  }
}
