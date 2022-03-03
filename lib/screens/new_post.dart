import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/food_post.dart';

class NewPost extends StatefulWidget {
  final XFile image;

  const NewPost({Key? key, required this.image}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final formKey = GlobalKey<FormState>();
  final dto = FoodPost();
  bool loading = false;

  double _screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  void toggleLoading() {
    setState(() { loading = !loading; });
  }

  Widget _inputForm() {
    return Form(
      key: formKey,
      child: Semantics(
        child: TextFormField(
          autofocus: true,
          style: const TextStyle(fontSize: 30),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            label: Center(child: Text("Number of Wasted Items")),
            labelStyle: TextStyle(fontSize: 30),
            errorStyle: TextStyle(fontSize: 20)
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSaved: (value) { dto.quantity = int.parse(value!); },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "A number is required";
            }
            return null;
          },
        ),
        label: "Number of wasted items",
        textField: true,
        focusable: true,
      ) 
    );
  }

  Future _getLocation() async {
    LocationData data = await Location().getLocation();
    dto.latitude = data.latitude;
    dto.longitude = data.longitude;
  }

  Future _uploadPhoto() async {
    Reference ref =  FirebaseStorage.instance.ref().child("image" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(File(widget.image.path));
    var res = await uploadTask;
    dto.imageURL = await res.ref.getDownloadURL();
  }

  void _savePost() async {
    if (formKey.currentState!.validate()) {
      toggleLoading();

      formKey.currentState!.save();
      await _getLocation();
      await _uploadPhoto();
      dto.date = DateTime.now();

      FirebaseFirestore.instance.collection("posts").add({
        "quantity": dto.quantity,
        "imageURL": dto.imageURL,
        "date": dto.date,
        "latitude": dto.latitude,
        "longitude": dto.longitude
      });
      
      toggleLoading();
      Navigator.of(context).pop();
    }
  }

  Widget _saveButton() {
    return Semantics(
      child: IconButton(
        padding: const EdgeInsets.all(20),
        iconSize: 100,
        color: Colors.white,
        onPressed: loading ? () {} : _savePost, 
        icon: loading 
          ? const CircularProgressIndicator(color: Colors.white) 
          : const Icon(Icons.cloud_upload_outlined)
      ),
      label: "Upload button",
      onTapHint: "Press to save post",
      button: true,
      enabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: _saveButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              child: Image.file(
                File(widget.image.path), 
                height: _screenHeight(context) * 0.4
              ),
              label: "Photo to upload",
              image: true,
            ),
            _inputForm(),
          ],
        ),
      )
    );
  }
}
