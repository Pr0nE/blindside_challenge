import 'package:blindside_challenge/blocs/videos/videos_state.dart';
import 'package:blindside_challenge/repositories/videos_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideosCubit extends Cubit<VideosState> {
  VideosCubit({required this.videosRepository}) : super(VideosLoadingState());

  final VideosRepository videosRepository;

  fetchAllVideos() {
    emit(VideosLoadingState());

    final videos = videosRepository.fetchVideos();

    emit(VideosLoadedState(videos));
  }
}
