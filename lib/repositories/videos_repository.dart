import 'package:blindside_challenge/model/video_model.dart';

class VideosRepository {
  final List<VideoInfoModel> _videos = const [
    VideoInfoModel(id: '1', title: 'Was ist Blindside?'),
    VideoInfoModel(
      id: '2',
      title: 'Teaser NIKE in Tenerife',
    ),
    VideoInfoModel(id: '3', title: 'Never Settle, Never Done | Nike'),
    VideoInfoModel(id: '4', title: 'No Excuses || Nike || Spec Commercial'),
  ];

  List<VideoInfoModel> fetchVideos() => _videos;
}
