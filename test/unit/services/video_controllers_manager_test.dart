import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:blindside_challenge/services/video_initializer_service.dart';
import 'package:blindside_challenge/services/video_manager_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_player/video_player.dart';

class FakeVideoInitializerService extends Mock
    implements VideoInitializerService {}

void main() {
  late final VideoManagerService sut;
  late final VideoInitializerService initializerService;
  const String defaultVideoId = '0';

  setUpAll(() {
    initializerService = FakeVideoInitializerService();
    sut = VideoManagerServiceImpl(initializerService);

    when(() => initializerService.initializeVideo('0')).thenAnswer(
      (invocation) => Future.value(
        VideoControllerModel(
          videoId: '0',
          controller: VideoPlayerController.asset(''),
        ),
      ),
    );
    when(() => initializerService.initializeVideo('1')).thenAnswer(
      (invocation) => Future.value(
        VideoControllerModel(
          videoId: '1',
          controller: VideoPlayerController.asset(''),
        ),
      ),
    );
  });

  group('InitializeVideo function', () {
    test(
        'Should initialize new video if provided id has not been initialized before',
        () async {
      await sut.getVideo(defaultVideoId);

      verify(() => initializerService.initializeVideo(any())).called(1);
    });

    test(
        'Should NOT initialize new video if provided id has been initialized before',
        () async {
      await sut.getVideo(defaultVideoId);

      verifyNever(() => initializerService.initializeVideo(any())).called(0);
    });
  });
  test(
      'Should return new video controller model for all list of requested video ids',
      () async {
    const List<String> requestedVideoIds = ['0', '1'];

    final List<VideoControllerModel> result =
        await sut.getVideoList(requestedVideoIds);

    final List<String> responseVideoIds = result.map((e) => e.videoId).toList();

    bool areListsEqual =
        const IterableEquality().equals(responseVideoIds, requestedVideoIds);

    expect(areListsEqual, true);
  });

  group('getReadyControllerFor', () {
    const String initializedVideoID = '0';
    const String unInitializedVideoID = '9';
    setUp(() async {
      when(() => initializerService.initializeVideo(initializedVideoID))
          .thenAnswer(
        (invocation) => Future.value(
          VideoControllerModel(
            videoId: initializedVideoID,
            controller: VideoPlayerController.asset(''),
          ),
        ),
      );

      await sut.getVideo(defaultVideoId);
    });

    test('Should return the controller if there is any', () async {
      final VideoControllerModel? result =
          sut.getReadyControllerFor(initializedVideoID);

      expect(result, isNotNull);
    });
    test('Should return null if there is nor corresponding controller',
        () async {
      final VideoControllerModel? result =
          sut.getReadyControllerFor(unInitializedVideoID);

      expect(result, isNull);
    });
  });

  test('Should clear all resources after dispose', () async {
    await sut.disposeAllControllers();

    expect(sut.initializedVideos, isEmpty);
  });
}
