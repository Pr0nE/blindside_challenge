import 'package:blindside_challenge/helpers/controller_initializer_mixin.dart';
import 'package:blindside_challenge/helpers/fade_page_route.dart';
import 'package:blindside_challenge/model/video_info_model.dart';
import 'package:blindside_challenge/pages/video_page.dart';
import 'package:blindside_challenge/widgets/video_item_widget.dart';
import 'package:blindside_challenge/widgets/video_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class RelatedVideosWidget extends StatefulWidget {
  const RelatedVideosWidget({Key? key, required this.videosInfo})
      : super(key: key);

  final List<VideoInfo> videosInfo;

  @override
  State<RelatedVideosWidget> createState() => _RelatedVideosWidgetState();
}

class _RelatedVideosWidgetState extends State<RelatedVideosWidget>
    with ControllerInitializerMixin {
  late final List<Future<VideoPlayerController>> controllers;

  @override
  void initState() {
    controllers = buildControllers(widget.videosInfo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Related Videos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    controllers.length,
                    (itemIndex) => SizedBox(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder<VideoPlayerController>(
                          future: controllers[itemIndex],
                          builder: (BuildContext context,
                                  AsyncSnapshot<VideoPlayerController>
                                      snapshot) =>
                              VideoItemWidget(
                                  info: widget.videosInfo[itemIndex],
                                  controllerFuture: controllers[itemIndex],
                                  controller: getControllerFor(
                                      widget.videosInfo[itemIndex]),
                                  isExpanded: false,
                                  showTitle: false,
                                  onTap: (VideoPlayerController controller) {
                                    controller.setVolume(1);

                                    Navigator.push(
                                        context,
                                        FadePageRoute(
                                          (BuildContext context) => VideoPage(
                                            controller: controller,
                                            info: widget.videosInfo[itemIndex],
                                          ),
                                        ));
                                    return;
                                  }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
