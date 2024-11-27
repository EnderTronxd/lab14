import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS-31: Taras\'s Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const platform = MethodChannel('com.example.lab14/static_message');

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _staticMessage = "";
  String _imagePath = "";

  Future<void> _getStaticMessage(BuildContext context) async {
    String message;
    try {
      final String result = await MyHomePage.platform.invokeMethod('getStaticMessage');
      message = result;
    } on PlatformException catch (e) {
      message = "Failed to get message: '${e.message}'.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Static Message'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // Відкривається камера
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CS-31: Taras\'s Flutter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _getStaticMessage(context),
              child: const Text('Get Static Message'),
            ),
            const SizedBox(height: 20),

            if (_imagePath.isNotEmpty)
              Image.file(
                File(_imagePath),
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
