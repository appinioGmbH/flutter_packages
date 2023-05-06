// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:appinio_social_share_example/iterable_extension.dart';

enum SocialAppType {
  facebook,
  facebook_stories,
  instagram,
  instagram_stories,
  messenger,
  telegram,
  tiktok,
  twitter,
  whatsapp,
  ;

  static List<SocialAppType> fromMap(Map? map) {
    if (map == null) return [];
    final List<SocialAppType> list = [];
    final List<String> keyList = map.entries
        .mapWhere(
            (entry) => entry.key.toString(), (entry) => entry.value == true)
        .toList();
    if (Platform.isIOS) {
      // This is because TikTok is not supported by appinio_social_share: 0.2.2
      keyList.remove(SocialAppType.tiktok.name);
    }
    for (final socialApp in SocialAppType.values) {
      if (keyList.contains(socialApp.name)) {
        list.add(socialApp);
      }
    }
    return list;
  }
}
