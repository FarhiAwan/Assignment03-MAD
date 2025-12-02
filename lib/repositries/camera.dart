import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:project/main.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 1. Check if we have cameras
    if (cameras.isNotEmpty) {
      // 2. Initialize the first camera (usually the back camera)
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      // 3. Attempt to take a picture
      final image = await _controller!.takePicture();

      // 4. Return the image path to the previous screen
      if (!mounted) return;
      Navigator.pop(context, image.path);

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameras.isEmpty) {
      return const Scaffold(body: Center(child: Text("No Camera Found")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Take Photo')),
      // Wait for the controller to initialize before showing the preview
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}