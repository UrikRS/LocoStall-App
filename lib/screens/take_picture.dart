import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locostall/bloc/drawer_bloc.dart';
import 'package:locostall/screens/elements/shop_detail.dart';
import 'package:locostall/services/api.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Stack(
              children: <Widget>[
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: CameraPreview(_controller),
                ),
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: 1,
                    mini: true,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ImageSelectionPage(),
                      ));
                    },
                    child: const Icon(Icons.photo_outlined),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: 2,
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        final image = await _controller.takePicture();
                        int pred = await ApiClient().predict(image);
                        drawerBloc.add(ItemTappedEvent(TabPage.shops));
                        if (context.mounted) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) =>
                                ShopDetailDialog(shopId: pred),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Icon(Icons.camera),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class ImageSelectionPage extends StatefulWidget {
  const ImageSelectionPage({super.key});

  @override
  State<ImageSelectionPage> createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      final url = 'YOUR_API_ENDPOINT_HERE';
      var request = MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        MultipartFile(
          'image',
          _selectedImage!.readAsBytes().asStream(),
          _selectedImage!.lengthSync(),
          filename: _selectedImage!.path.split('/').last,
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        // Handle successful upload
        print('Image uploaded successfully');
      } else {
        // Handle upload failure
        print('Image upload failed');
      }
    } else {
      // Handle no image selected
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Selection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Image.file(_selectedImage!)
            else
              Icon(Icons.image, size: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image to API'),
            ),
          ],
        ),
      ),
    );
  }
}
