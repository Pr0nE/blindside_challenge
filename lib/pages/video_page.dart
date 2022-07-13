import 'package:blindside_challenge/pages/home_page.dart';
import 'package:blindside_challenge/model/video_info_model.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:blindside_challenge/widgets/related_videos_widget.dart';
import 'package:blindside_challenge/widgets/video_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key, required this.controller, required this.info})
      : super(key: key);

  final VideoInfo info;
  final VideoPlayerController controller;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () {
          widget.controller.play();
          widget.controller.setVolume(0);

          return Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xff222831),
            body: Column(
              children: [
                VideoItemWidget(
                  info: widget.info,
                  controllerFuture: Future.value(widget.controller),
                  controller: widget.controller,
                  isExpanded: true,
                  onTap: (VideoPlayerController controller) {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      RelatedVideosWidget(
                        videosInfo: videos
                            .where((element) => element.id != widget.info.id)
                            .toList(),
                      ),
                      CommentsWidget(
                        comments: comments
                            .where(
                                (element) => element.videoId == widget.info.id)
                            .toList(),
                        onAddComment: (comment) {
                          setState(() {
                            comments.insert(
                              0,
                              CommentModel(
                                author: 'Me',
                                message: comment,
                                videoId: widget.info.id,
                              ),
                            );
                          });
                        },
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
