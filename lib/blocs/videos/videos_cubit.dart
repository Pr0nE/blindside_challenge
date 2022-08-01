import 'package:blindside_challenge/blocs/videos/videos_state.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/repositories/videos_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Handles state of a list of videos.
///
/// It interacts with a [VideosRepository] dependency to fetch videos.
class VideosCubit extends Cubit<VideosState> {
  VideosCubit({required this.videosRepository}) : super(VideosLoadingState());

  /// Instance of repository dependency.
  final VideosRepository videosRepository;

  /// Starts fetching all videos.
  ///
  /// After successful fetch, cubit emits [VideosLoadedState] which contains list of videos.
  void fetchAllVideos() {
    emit(VideosLoadingState());

    final videos = videosRepository.fetchVideos();

    emit(VideosLoadedState(videos));
  }

  /// Gets related videos of [video].
  ///
  /// This method won't emit any new state, its just returns filtered version of existing videos.
  List<VideoInfoModel> getRelatedVideosFor(VideoInfoModel video) {
    if (state is VideosLoadedState) {
      return (state as VideosLoadedState)
          .videos
          .where((element) => element.id != video.id)
          .toList();
    }

    return [];
  }
}
