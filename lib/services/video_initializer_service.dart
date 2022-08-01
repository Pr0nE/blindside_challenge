import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:video_player/video_player.dart';

/// Responsible for Initializing videos.
///
/// By initializing a video, we mean getting it ready to be played and its mostly time consuming.
/// For example when we're initializing an asset video, we need to fetch its binary data from assets, then convert them to playable buffers.
abstract class VideoInitializerService {
  /// Initializes a video by its [id].
  Future<VideoControllerModel> initializeVideo(String id);
}

/// A concrete class of [VideoInitializerService] which uses third-party package(video_player) to initialize videos.
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
