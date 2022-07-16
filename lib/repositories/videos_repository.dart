import 'package:blindside_challenge/model/video_model.dart';

class VideosRepository {
  final List<VideoModel> _videos = const [
    VideoModel(id: '1', title: 'Was ist Blindside?'),
    VideoModel(
      id: '2',
      title: 'Teaser NIKE in Tenerife',
    ),
    VideoModel(id: '3', title: 'Never Settle, Never Done | Nike'),
    VideoModel(id: '4', title: 'No Excuses || Nike || Spec Commercial'),
  ];

  List<VideoModel> fetchVideos() => _videos;
}
