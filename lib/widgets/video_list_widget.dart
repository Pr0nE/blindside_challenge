import 'package:blindside_challenge/helpers/controller_initializer_mixin.dart';
import 'package:blindside_challenge/helpers/fade_page_route.dart';
import 'package:blindside_challenge/model/video_info_model.dart';
import 'package:blindside_challenge/widgets/video_item_widget.dart';
import 'package:blindside_challenge/pages/video_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoListWidget extends StatefulWidget {
  const VideoListWidget({
    Key? key,
    required this.information,
    required this.onLoaded,
  }) : super(key: key);

  final List<VideoInfo> information;

  final void Function(List<VideoPlayerController>) onLoaded;

  @override
  State<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget>
    with ControllerInitializerMixin {
  late final List<Future<VideoPlayerController>> controllers;

  @override
  void initState() {
    controllers = buildControllers(widget.information);

    startTrackControllersInitialization(controllers);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView.separated(
        itemCount: widget.information.length,
        itemBuilder: (BuildContext context, int itemIndex) => VideoItemWidget(
            info: widget.information[itemIndex],
            controllerFuture: controllers[itemIndex],
            isExpanded: false,
            onTap: (VideoPlayerController controller) {
              controller.setVolume(1);

              Navigator.push(
                  context,
                  FadePageRoute(
                    (BuildContext context) => VideoPage(
                      controller: controller,
                      info: widget.information[itemIndex],
                    ),
                  ));
              return;
            }),
        separatorBuilder: (BuildContext context, int itemIndex) =>
            SizedBox(height: 50),
      );

  Future<void> startTrackControllersInitialization(
    List<Future<VideoPlayerController>> controllers,
  ) async =>
      widget.onLoaded(await Future.wait(controllers));
}
