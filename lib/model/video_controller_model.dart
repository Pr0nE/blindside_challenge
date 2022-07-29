import 'package:video_player/video_player.dart';

class VideoControllerModel {
  final String videoId;
  final VideoPlayerController controller;

  VideoControllerModel({
    required this.controller,
    required this.videoId,
  });

  bool get isInitialized => controller.value.isInitialized;
}
