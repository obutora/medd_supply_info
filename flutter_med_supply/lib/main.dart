import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';
import 'package:zxing2/zxing2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Hello Worlds'),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    print(file.path);

                    var image = img.decodePng(file.readAsBytesSync())!;

                    print(image.width);

                    LuminanceSource source = RGBLuminanceSource(
                        image.width,
                        image.height,
                        image
                            .convert(numChannels: 4)
                            .getBytes(order: img.ChannelOrder.abgr)
                            .buffer
                            .asInt32List());
                    var bitmap = BinaryBitmap(GlobalHistogramBinarizer(source));

                    var reader = QRCodeReader();
                    var decode = reader.decode(bitmap);
                    print(decode.text);
                  } else {
                    print('no file');
                  }
                },
                child: const Text('Scan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
