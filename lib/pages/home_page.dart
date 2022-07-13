import 'package:blindside_challenge/model/video_info_model.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:blindside_challenge/widgets/video_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

List<VideoInfo> videos = [
  VideoInfo(id: '1', title: 'Was ist Blindside?'),
  VideoInfo(
    id: '2',
    title: 'Teaser NIKE in Tenerife',
  ),
  VideoInfo(id: '3', title: 'Never Settle, Never Done | Nike'),
  VideoInfo(id: '4', title: 'No Excuses || Nike || Spec Commercial'),
];

List<CommentModel> comments = [
  CommentModel(
      author: 'David',
      message: 'Cool stuff!',
      videoId: '1'),
  CommentModel(
      author: 'James',
      message: 'Love it, keep it up.',
      videoId: '2'),
  CommentModel(
      author: 'Elena',
      message: 'Nice, i hope it would get even better in the future.',
      videoId: '3'),
  CommentModel(
      author: 'Jia',
      message: 'These guys are rocking it!',
      videoId: '3'),
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xff222831),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: VideoListWidget(
                  information: videos,
                  onLoaded: (List<VideoPlayerController> controllers) =>
                      print(controllers),
                ),
              ),
            ),
          ],
        ),
      );
}
