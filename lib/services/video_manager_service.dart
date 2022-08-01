import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:blindside_challenge/services/video_initializer_service.dart';
import 'package:collection/collection.dart';

/// Responsible for managing initialized videos.
///
/// It also decides when we should initialize a video, by using a dependency service.
abstract class VideoManagerService {
  /// Gets all initialized videos.
  Iterable<VideoControllerModel> get initializedVideos;

  /// Gets related videos of a particular video.
  Iterable<VideoControllerModel> getRelatedVideoFor(String id);

  /// Gets an initialized version of the given video by its [id].
  Future<VideoControllerModel> getVideo(String id);

  /// Gets initialized versions of the given videos by their [ids].
  Future<List<VideoControllerModel>> getVideoList(List<String> ids);

  /// Gets an initialized version of the given video, only if its already has been initialized.
  ///
  /// Otherwise, it returns `null`.
  VideoControllerModel? getReadyControllerFor(String videoId);

  /// Mutes audio of the provided [videoId].
  Future<void> muteVideo(String videoId);

  /// Disposes all initialized controllers.
  Future<void> disposeAllControllers();
}

/// A concrete class of [VideoManagerService] which uses a [VideoInitializerService] dependency to initialize videos if needed.
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
