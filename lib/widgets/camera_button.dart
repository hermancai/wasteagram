import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  final Function tapEvent;

  const CameraButton({Key? key, required this.tapEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: ElevatedButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () { tapEvent(); },
      ),
      label: "New post button",
      onTapHint: "Press to create a new post",
      button: true,
      enabled: true,
    );
  }
}
