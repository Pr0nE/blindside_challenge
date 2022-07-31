import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:video_player/video_player.dart';

abstract class VideoInitializerService {
  Future<VideoControllerModel> initializeVideo(String id);
}

class VideoInitializerServiceImpl implements VideoInitializerService {
  @override
  Future<VideoControllerModel> initializeVideo(String id) async {
    String url = _getVideoUrlFor(id);
    final controller = VideoPlayerController.asset(
      url,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    controller.setLooping(true);
    controller.setVolume(0);
    await controller.initialize();
    controller.play();

    return VideoControllerModel(
      controller: controller,
      videoId: id,
    );
  }

  String _getVideoUrlFor(String id) => 'assets/videos/$id.mp4';
}
