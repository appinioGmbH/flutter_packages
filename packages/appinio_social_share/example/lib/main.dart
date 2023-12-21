import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:appinio_social_share/appinio_social_share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppinioSocialShare appinioSocialShare = AppinioSocialShare();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Share Feature",
        home: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("ShareToWhatsapp"),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(type: FileType.image, allowMultiple: true);
                  if (result != null) {
                    shareToWhatsApp(
                        "message", result.files.map((e) => e.path!).toList());
                  }
                },
              ),
            ],
          ),
        ));
  }

  shareToWhatsApp(String message, List<String> filePaths) async {
    await appinioSocialShare.shareToSMS(message, filePaths: filePaths);
  }
}
