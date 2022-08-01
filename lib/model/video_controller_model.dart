import 'package:video_player/video_player.dart';

/// Holds information of a initialized video.
class VideoControllerModel {
  final String videoId;
  final VideoPlayerController controller;

  VideoControllerModel({
    required this.controller,
    required this.videoId,
  });

  bool get isInitialized => controller.value.isInitialized;
}
