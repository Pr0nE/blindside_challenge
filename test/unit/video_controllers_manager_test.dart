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
  });

  group('Video manager ', () {
    test(
        'Should initialize new video if provided id has not been initialized before',
        () async {
      const String videoId = '0';

      final VideoControllerModel result = await sut.getVideo(videoId);

      verify(() => initializerService.initializeVideo(any())).called(1);
    });

    test(
        'Should NOT initialize new video if provided id has been initialized before',
        () async {
      const String videoId = '0';

      final VideoControllerModel result = await sut.getVideo(videoId);

      verifyNever(() => initializerService.initializeVideo(any())).called(0);
    });
  });
}
