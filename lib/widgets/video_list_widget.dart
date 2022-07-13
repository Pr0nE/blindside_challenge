
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

class _VideoListWidgetState extends State<VideoListWidget> {
  late final List<Future<VideoPlayerController>> controllers;

  @override
  void initState() {
    controllers = _buildControllers(widget.information);

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

  List<Future<VideoPlayerController>> _buildControllers(
    List<VideoInfo> information,
  ) {
    // TODO: Here we are initalizing whole videos controller at once, which may cost much if videos count is big. Instead we should only initialize visible videos.
    return information.map((info) async {
      final controller = VideoPlayerController.asset(getVideoUrlFor(info.id),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

      await _initializeController(controller);

      return controller;
    }).toList();
  }

  Future<void> startTrackControllersInitialization(
    List<Future<VideoPlayerController>> controllers,
  ) async =>
      widget.onLoaded(await Future.wait(controllers));

  Future<void> _initializeController(VideoPlayerController controller) async {
    controller.setLooping(true);
    controller.setVolume(0);
    await controller.initialize();

    controller.play();
  }

  String getVideoUrlFor(String id) => 'assets/videos/$id.mp4';
}


