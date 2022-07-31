import 'package:blindside_challenge/blocs/videos/videos_cubit.dart';
import 'package:blindside_challenge/blocs/videos/videos_state.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/repositories/videos_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeVideosRepository extends Mock implements VideosRepository {}

void main() {
  late final VideosRepository videosRepository;
  late final VideoInfoModel fakeInfo;

  setUpAll(() {
    videosRepository = FakeVideosRepository();
    fakeInfo = const VideoInfoModel(id: '0', title: '');

    registerFallbackValue(fakeInfo);

    when(() => videosRepository.fetchVideos()).thenAnswer((invocation) => []);
  });

  blocTest(
    'Should emit right states after calling fetchAllVideos',
    build: () => VideosCubit(videosRepository: videosRepository),
    act: (VideosCubit cubit) => cubit.fetchAllVideos(),
    expect: () => [
      isA<VideosLoadingState>(),
      isA<VideosLoadedState>(),
    ],
    verify: (cubit) => verify(() => videosRepository.fetchVideos()).called(1),
  );
}
