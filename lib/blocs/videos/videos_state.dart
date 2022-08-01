import 'package:blindside_challenge/model/video_model.dart';

/// Holds state of a video list.
abstract class VideosState {}

/// Indicates a loading state for a video list.
class VideosLoadingState extends VideosState {}

/// Holds loaded comments for a comment section.
class VideosLoadedState extends VideosState {
  VideosLoadedState(this.videos);

  /// Loaded videos.
  final List<VideoInfoModel> videos;
}
