import 'package:blindside_challenge/model/video_info_model.dart';
import 'package:video_player/video_player.dart';
import 'package:collection/collection.dart';

mixin ControllerInitializerMixin {
  static final Map<String, Future<VideoPlayerController>> _controllers = {};
  static final Map<String, VideoPlayerController> _loadedControllers = {};

  List<Future<VideoPlayerController>> buildControllers(
    List<VideoInfo> information,
  ) {
    List<Future<VideoPlayerController>> result = [];

    for (VideoInfo videoInfo in information) {
      if (_controllers.containsKey(videoInfo.id)) {
        // Video cached
        result.add(_controllers[videoInfo.id]!);
      } else {
        // Need initialization
        final Future<VideoPlayerController> controller =
            _initControllerFor(videoInfo);

        _controllers.addAll({videoInfo.id: controller});
        controller
            .then((value) => _loadedControllers.addAll({videoInfo.id: value}));

        result.add(controller);
      }
    }

    return result;
  }

  VideoPlayerController? getControllerFor(VideoInfo info) =>
      _loadedControllers.entries
          .firstWhereOrNull((element) => element.key == info.id)
          ?.value;

  Future<VideoPlayerController> _initControllerFor(VideoInfo info) async {
    final controller = VideoPlayerController.asset(_getVideoUrlFor(info.id),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    await _initializeController(controller);

    return controller;
  }

  Future<void> _initializeController(VideoPlayerController controller) async {
    controller.setLooping(true);
    controller.setVolume(0);
    await controller.initialize();

    controller.play();
  }

  String _getVideoUrlFor(String id) => 'assets/videos/$id.mp4';
}
