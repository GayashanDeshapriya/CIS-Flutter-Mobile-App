import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final Logger _logger = Logger();
  final List<XFile> _imageList = [];

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _logger.i('Image captured: ${pickedFile.path}');
      await _saveImageToLocalStorage(_image!);
    } else {
      _logger.w('No image selected.');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _logger.i('Image selected: ${pickedFile.path}');
    } else {
      _logger.w('No image selected.');
    }
  }

  Future<void> _saveImageToLocalStorage(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final file = File('$path/$fileName.png');
      await image.copy(file.path);
      _logger.i('Image saved to local storage: ${file.path}');
    } catch (e) {
      _logger.e('Error saving image to local storage: $e');
    }
  }

  Future<void> _uploadImageToServer(File image) async {
    try {
      final url =
          Uri.parse('HTTP://10.11.1.11:4444/v1/test_project/SaveCompletedJob');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        _logger.i('Image uploaded successfully.');
      } else {
        _logger
            .w('Image upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error uploading image to server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: _pickImageFromCamera,
                child: const Text('Capture Image'),
              ),
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: const Text('Select Image from Gallery'),
              ),
              ElevatedButton(
                onPressed:
                    _image != null ? () => _uploadImageToServer(_image!) : null,
                child: const Text('Upload Image'),
              ),
            ],
          ),
          _image == null
              ? const Text('No image selected.')
              : Image.file(_image!,
                  height: 200, width: double.infinity, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: _imageList.length,
              itemBuilder: (context, index) {
                return Image.file(
                  File(_imageList[index].path),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
