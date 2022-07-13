import 'dart:ui';

import 'package:blindside_challenge/video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoInfo> videos = [
    VideoInfo(id: '1', title: 'Was ist Blindside?'),
    VideoInfo(
      id: '2',
      title: 'Teaser NIKE in Tenerife',
    )
    // VideoInfo(id: '3', title: 'Video 3'),
    // VideoInfo(id: '4', title: 'Video 4'),
    // VideoInfo(id: '5', title: 'Video 5'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        //backgroundColor: Colors.black12,
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

class VideoItemWidget extends StatefulWidget {
  const VideoItemWidget({
    Key? key,
    required this.info,
    required this.controllerFuture,
    required this.isExpanded,
    required this.onTap,
    this.controller,
  }) : super(key: key);

  final VideoInfo info;
  final bool isExpanded;
  final Future<VideoPlayerController> controllerFuture;
  final void Function(VideoPlayerController) onTap;

  final VideoPlayerController? controller;

  @override
  State<VideoItemWidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  @override
  Widget build(BuildContext context) => FutureBuilder<VideoPlayerController>(
      future: widget.controllerFuture,
      builder: (context, snapData) {
        return Hero(
            tag: widget.info.id,
            child: Material(
              type: MaterialType.transparency,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      widget.info.title,
                      style: TextStyle(fontSize: 28, ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(widget.isExpanded ? 0 : 8)),
                    child: GestureDetector(
                      onTap: () {
                        if (snapData.hasData) {
                          widget.onTap(snapData.data!);
                        }
                      },
                      child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: widget.controller != null
                              ? VideoPlayer(widget.controller!)
                              : snapData.hasData
                                  ? VideoPlayer(snapData.data!)
                                  : Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.black,
                                      ),
                                    )),
                    ),
                  ),
                ],
              ),
            ));
      });
}

class VideoInfo {
  VideoInfo({
    required this.id,
    required this.title,
  });

  String id;
  String title;
}

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute(this.builder);
  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => '';

  final Widget Function(BuildContext) builder;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);
}
