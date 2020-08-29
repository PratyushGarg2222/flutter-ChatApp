import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          onPressed: _pickImage,
          label: Text('Add Image'),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
