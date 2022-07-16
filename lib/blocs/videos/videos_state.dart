import 'package:blindside_challenge/model/video_model.dart';

abstract class VideosState {}

class VideosLoadingState extends VideosState {}

class VideosLoadedState extends VideosState {
  VideosLoadedState(this.videos);

  final List<VideoModel> videos;

  List<VideoModel> fetchRelatedVideosFor(VideoModel video) =>
      videos.where((element) => element.id != video.id).toList();
}
