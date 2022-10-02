import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shazam/clases/request_http.dart';

class Provide_Music with ChangeNotifier {
  final record = Record();
  List<Map<String, dynamic>>? Elements;
  String? path;
  var requestHttp = RequestHttp(url: "https://api.audd.io/");

  bool glow = false;

  void addFavorite(Map<String, dynamic> song) {
    if (Elements == null) {
      Elements = [];
    }
    Elements?.add(song);
    notifyListeners();
  }

  bool check_favorite(Map<String, dynamic> song) {
    if (Elements == null) {
      return false;
    } else {
      for (int i = 0; i < Elements!.length; i++) {
        Map<String, dynamic> check_Elements = Elements![i];
        if (check_Elements["title"] == song["title"]) {
          return true;
        }
      }
      return false;
    }
  }

  void eliminar(Map<String, dynamic> artist) {
    for (int i = 0; i < Elements!.length; i++) {
      Map<String, dynamic> check_Elements = Elements![i];
      if (check_Elements["title"] == artist["title"]) {
        Elements!.removeAt(i);
      }
    }
    print(Elements);
    notifyListeners();
  }

  void escuchando_glow() {
    glow = true;
    notifyListeners();
  }

  void dejo_de_escuchar_glow() {
    glow = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> escuchar() async {
    Directory? filepath = await getExternalStorageDirectory();

    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: '${filepath?.path}/${DateTime.now().millisecondsSinceEpoch}.m4a',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );
    }
    bool isRecording = await record.isRecording();
    if (isRecording) {
      await Future.delayed(Duration(seconds: 9), stop_record);
    }
    final path = await record.stop();
    File songFile = File(path!);
    Uint8List fileInBytes = songFile.readAsBytesSync();
    String base64String = base64Encode(fileInBytes);
    await dotenv.load();
    String? API_key = dotenv.env['API_KEY'];
    return await requestHttp.post_request(base64String, API_key);
  }

  void stop_record() async {
    path = await record.stop();
  }
}
