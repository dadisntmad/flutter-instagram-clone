import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/services/firestore_service.dart';
import 'package:instagram/utils/pick_image.dart';
import 'package:instagram/utils/show_snackbar.dart';
import 'package:provider/provider.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final _descriptionController = TextEditingController();

  void _uploadPost(
    String uid,
    String username,
    String profileImage,
  ) async {
    setState(() {
      _isLoading = true;
    });

    String res = await FirestoreService().createPost(
      uid,
      username,
      profileImage,
      _file!,
      _descriptionController.text,
    );

    if (res == 'Success') {
      _isLoading = false;
      showSnackbar(context, 'Posted');
      _clearData();
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackbar(context, res);
    }
  }

  _pickImage(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('New'),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
              child: Row(
                children: const [
                  Icon(Icons.image),
                  SizedBox(width: 5),
                  Text('Choose from gallery'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
              child: Row(
                children: const [
                  Icon(Icons.camera),
                  SizedBox(width: 5),
                  Text('Take a photo'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: const [
                  Icon(Icons.close),
                  SizedBox(width: 5),
                  Text('Cancel'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearData() {
    _file = null;
    _descriptionController.clear();

    setState(() {});
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: _file == null
            ? null
            : TextButton(
                onPressed: _clearData,
                child: const Text('Cancel'),
              ),
        leadingWidth: 75,
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          if (_file != null)
            TextButton(
              onPressed: () => _uploadPost(
                user!.uid,
                user.username,
                user.imageUrl,
              ),
              child: const Text('Post'),
            ),
        ],
      ),
      body: _file == null
          ? Center(
              child: IconButton(
                onPressed: () => _pickImage(context),
                icon: const Icon(Icons.file_upload),
                iconSize: 50,
              ),
            )
          : Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 5),
                    Container(
                      height: 100,
                      width: 85,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(_file!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 8,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
