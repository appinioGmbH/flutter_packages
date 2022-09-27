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
            children: [
              ElevatedButton(
                child: const Text("ShareToWhatsapp"),
                onPressed: () {},
              ),
            ],
          ),
        ));
  }

  shareToWhatsApp(String message, String filePath) async {
    await appinioSocialShare.shareToWhatsapp(message, filePath: filePath);
  }
}
