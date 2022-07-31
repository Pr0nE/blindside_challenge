import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:blindside_challenge/services/video_initializer_service.dart';
import 'package:collection/collection.dart';

abstract class VideoManagerService {
  Iterable<VideoControllerModel> get initializedVideos;
  Iterable<VideoControllerModel> getRelatedVideoFor(String id);
  Future<VideoControllerModel> getVideo(String id);
  Future<List<VideoControllerModel>> getVideoList(List<String> ids);
  VideoControllerModel? getReadyControllerFor(String videoId);
  Future<void> muteVideo(String videoId);
  Future<void> disposeAllControllers();
}

class VideoManagerServiceImpl implements VideoManagerService {
  VideoManagerServiceImpl(this.videoInitializerService);

  final VideoInitializerService videoInitializerService;

  final Map<String, VideoControllerModel> _controllers = {};

  @override
  Iterable<VideoControllerModel> get initializedVideos => _controllers.values;

  @override
  Future<VideoControllerModel> getVideo(String id) async {
    if (_controllers.containsKey(id)) {
      // Video cached
      return _controllers[id]!;
    } else {
      // Need initialization
      final VideoControllerModel controller =
          await videoInitializerService.initializeVideo(id);
      _controllers[id] = controller;

      return controller;
    }
  }

  @override
  Future<List<VideoControllerModel>> getVideoList(List<String> ids) =>
      Future.wait(ids.map((id) => getVideo(id)));

  @override
  VideoControllerModel? getReadyControllerFor(String videoId) =>
      _controllers.entries
          .firstWhereOrNull((element) => element.key == videoId)
          ?.value;

  @override
  Future<void> muteVideo(String videoId) async => _controllers.entries
      .firstWhereOrNull((entity) => entity.key == videoId)
      ?.value
      .controller
      .setVolume(0);

  @override
  Future<void> disposeAllControllers() async {
    _controllers.entries.map((e) => e.value).forEach(
          (element) => element.controller.dispose(),
        );

    _controllers.clear();
  }

  @override
  Iterable<VideoControllerModel> getRelatedVideoFor(String id) {
    return _controllers.values.where((controller) => controller.videoId != id);
  }
}
