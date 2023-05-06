import 'package:appinio_social_share_example/file_utils.dart';
import 'package:appinio_social_share_example/modal_indicator.dart';
import 'package:appinio_social_share_example/modal_item_wrapper.dart';
import 'package:appinio_social_share_example/social_app_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Social Share Example', home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  /// Replace XXXXXXXXXXXXXXXXXX with the data from your Facebook developer account https://developers.facebook.com
  final facebookAppId = 'XXXXXXXXXXXXX';
  final socialShare = AppinioSocialShare();
  bool isLoading = false;
  final imagesAsset = ['sample-1.jpg', 'sample-2.jpg'];
  final videosAsset = ['sample-1.mp4', 'sample-2.mp4'];
  List<String> imagesPath = [], videosPath = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Share Example'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : shareImage,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Share Image"),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : shareVideo,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Share Video"),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : shareMultipleImage,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Share Multiple Image"),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : shareMultipleVideo,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Share Multiple Video"),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : shareAll,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Share Multiple Image and Video"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> prepareImagesPath() async {
    if (imagesPath.length != imagesAsset.length) {
      imagesPath.clear();
      for (final asset in imagesAsset) {
        final String? imagePath =
            await FileUtils.exposeFileFromAsset(assetKey: asset);
        if (imagePath != null) {
          imagesPath.add(imagePath);
        }
      }
    }
  }

  Future<void> prepareVideosPath() async {
    if (videosPath.length != videosAsset.length) {
      videosPath.clear();
      for (final asset in videosAsset) {
        final String? videoPath =
            await FileUtils.exposeFileFromAsset(assetKey: asset);
        if (videoPath != null) {
          videosPath.add(videoPath);
        }
      }
    }
  }

  Future<void> shareImage() async {
    setState(() => isLoading = true);
    await prepareImagesPath();
    await showShareOptions(imagesPath: imagesPath.sublist(0, 1));
    setState(() => isLoading = false);
  }

  Future<void> shareVideo() async {
    setState(() => isLoading = true);
    await prepareVideosPath();
    await showShareOptions(videosPath: videosPath.sublist(0, 1));
    setState(() => isLoading = false);
  }

  Future<void> shareMultipleImage() async {
    setState(() => isLoading = true);
    await prepareImagesPath();
    await showShareOptions(imagesPath: imagesPath);
    setState(() => isLoading = false);
  }

  Future<void> shareMultipleVideo() async {
    setState(() => isLoading = true);
    await prepareVideosPath();
    await showShareOptions(videosPath: videosPath);
    setState(() => isLoading = false);
  }

  Future<void> shareAll() async {
    setState(() => isLoading = true);
    await prepareImagesPath();
    await prepareVideosPath();
    await showShareOptions(imagesPath: imagesPath, videosPath: videosPath);
    setState(() => isLoading = false);
  }

  void showMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  Future<void> _executeSafeFunction(Future Function() function) async {
    try {
      final result = await function();
      showMessage(result);
    } catch (e) {
      showMessage(e.toString());
    }
  }

  Future<void> showShareOptions({
    List<String>? imagesPath,
    List<String>? videosPath,
  }) async {
    try {
      String? imagePath =
          (imagesPath?.isNotEmpty ?? false) ? imagesPath?.first : null;
      String? videoPath =
          (videosPath?.isNotEmpty ?? false) ? videosPath?.first : null;
      final List<ModalItemWrapper> modalItems = [];
      final availableSocialApps =
          SocialAppType.fromMap(await socialShare.getInstalledApps());
      if (availableSocialApps.isNotEmpty) {
        if (imagesPath != null || videosPath != null) {
          for (final socialApp in availableSocialApps) {
            switch (socialApp) {
              case SocialAppType.facebook:
                modalItems.add(ModalItemWrapper(
                  text: 'Facebook',
                  icon: Icons.facebook,
                  callback: () async {
                    _executeSafeFunction(() => socialShare.shareToFacebook(
                        '#appinio_social_share', null,
                        imagesPath: imagesPath, videosPath: videosPath));
                  },
                ));
                break;
              case SocialAppType.facebook_stories:
                modalItems.add(ModalItemWrapper(
                  text: 'Facebook stories',
                  icon: Icons.facebook,
                  callback: () {
                    _executeSafeFunction(() => socialShare.shareToFacebookStory(
                          facebookAppId,
                          backgroundImage: imagePath,
                          backgroundVideo: videoPath,
                          backgroundTopColor: '#e32129',
                          backgroundBottomColor: '#F9F4D9',
                        ));
                  },
                ));
                break;
              case SocialAppType.instagram:
                modalItems.add(ModalItemWrapper(
                    text: 'Instagram',
                    icon: Icons.info_outline,
                    callback: () async {
                      Future Function()? function;
                      if (imagePath != null) {
                        function =
                            () => socialShare.shareToInstagramFeed(imagePath);
                      } else if (videoPath != null) {
                        function =
                            () => socialShare.shareToInstagramReels(videoPath);
                      }
                      if (function != null) {
                        _executeSafeFunction(function);
                      }
                    }));
                break;
              case SocialAppType.instagram_stories:
                modalItems.add(ModalItemWrapper(
                  text: 'Instagram stories',
                  icon: Icons.info_outline,
                  callback: () {
                    _executeSafeFunction(() =>
                        socialShare.shareToInstagramStory(
                            backgroundImage: imagePath,
                            backgroundVideo: videoPath,
                            backgroundTopColor: '#e32129',
                            backgroundBottomColor: '#F9F4D9'));
                  },
                ));
                break;
              case SocialAppType.messenger:
                // Supports only text, makes no sense
                break;
              case SocialAppType.telegram:
                modalItems.add(ModalItemWrapper(
                  text: 'Telegram',
                  icon: Icons.telegram,
                  callback: () {
                    _executeSafeFunction(() => socialShare.shareToTelegram(
                        'Shared using appinio_social_share flutter plugin',
                        filePath: imagePath ?? videoPath));
                  },
                ));
                break;
              case SocialAppType.tiktok:
                modalItems.add(ModalItemWrapper(
                  text: 'Tiktok',
                  icon: Icons.tiktok,
                  callback: () async {
                    _executeSafeFunction(() => socialShare.shareToTiktokPost(
                        null,
                        imagesPath: imagesPath,
                        videosPath: videosPath));
                  },
                ));
                break;
              case SocialAppType.twitter:
                modalItems.add(ModalItemWrapper(
                  text: 'Twitter',
                  icon: Icons.info_outline,
                  callback: () {
                    _executeSafeFunction(() => socialShare.shareToTwitter(
                        'Shared using appinio_social_share flutter plugin',
                        filePath: imagePath ?? videoPath));
                  },
                ));
                break;
              case SocialAppType.whatsapp:
                modalItems.add(ModalItemWrapper(
                  text: 'Whatsapp',
                  icon: Icons.info,
                  callback: () {
                    _executeSafeFunction(() => socialShare.shareToWhatsapp(
                        'Shared using appinio_social_share flutter plugin',
                        filePath: imagePath ?? videoPath));
                  },
                ));
                break;
            }
          }
        }
        showGenericListModal(items: modalItems);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<T?> showGenericListModal<T>({
    required List<ModalItemWrapper> items,
    bool closeModalOnItemTap = false,
    String? title,
  }) {
    assert(items.isNotEmpty, 'showGenericListModal: items must not be empty');
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          final theme = Theme.of(context);
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ModalIndicator(),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, int index) {
                    final item = items[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          left: item.icon == null ? 24 : 72, right: 24),
                      child: const Divider(
                        height: 0,
                      ),
                    );
                  },
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return InkWell(
                      highlightColor:
                          item.callback == null ? Colors.transparent : null,
                      splashColor:
                          item.callback == null ? Colors.transparent : null,
                      onTap: closeModalOnItemTap
                          ? () {
                              Navigator.pop(context);
                              item.callback?.call();
                            }
                          : item.callback ?? () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (item.icon != null) ...[
                              Icon(item.icon,
                                  color: item.isEnabled
                                      ? item.iconColor
                                      : item.disabledColor),
                              const SizedBox(width: 24),
                            ],
                            Expanded(
                              child: Text(
                                item.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: item.isEnabled
                                      ? item.textColor
                                      : item.disabledColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
