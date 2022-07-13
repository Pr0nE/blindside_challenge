import 'package:blindside_challenge/pages/home_page.dart';
import 'package:blindside_challenge/model/video_info_model.dart';
import 'package:blindside_challenge/widgets/video_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({Key? key, required this.controller, required this.info})
      : super(key: key);

  final VideoInfo info;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () {
          controller.play();
          controller.setVolume(0);
          
          return Future.value(true);
        },
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                VideoItemWidget(
                  info: info,
                  controllerFuture: Future.value(controller),
                  controller: controller,
                  isExpanded: true,
                  onTap: (VideoPlayerController controller) {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
}
