// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "title": "اذاعة النرويج بالعربية",
  "general": "منوعات",
  "onBoard": "تحقيقات",
  "NightMode": "وضع الليلي",
  "Play_In_Background": "تشغيل بالخلفية",
  "Language": "اللغة"
};
static const Map<String,dynamic> en = {
  "title": "Arabic Norway FM",
  "general": "General",
  "onBoard": "on board",
  "NightMode": "Night Mode",
  "Play_In_Background": "Play In Background",
  "Language": "Language"
};
static const Map<String,dynamic> no = {
  "title": "Arabic Norway FM",
  "general": "generell",
  "onBoard": "om bord",
  "NightMode": "Night Mode",
  "Play_In_Background": "Play In Background",
  "Language": "Language"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en, "no": no};
}
