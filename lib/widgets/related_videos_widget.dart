import 'package:blindside_challenge/helpers/fade_page_route.dart';
import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/pages/video_page.dart';
import 'package:blindside_challenge/services/video_manager_service.dart';
import 'package:blindside_challenge/widgets/video_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows related videos of a [parentVideo].
class RelatedVideosWidget extends StatefulWidget {
  const RelatedVideosWidget({
    Key? key,
    required this.videosInfo,
    required this.parentVideo,
  }) : super(key: key);

  final List<VideoInfoModel> videosInfo;
  final VideoInfoModel parentVideo;

  @override
  State<RelatedVideosWidget> createState() => _RelatedVideosWidgetState();
}

class _RelatedVideosWidgetState extends State<RelatedVideosWidget> {
  late final List<VideoControllerModel> controllers;
  late final VideoManagerService _videoManagerService;

  @override
  void initState() {
    _videoManagerService = context.read<VideoManagerService>();
    controllers =
        _videoManagerService.getRelatedVideoFor(widget.parentVideo.id).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
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
                          child: VideoItemWidget(
                            info: widget.videosInfo[itemIndex],
                            controllerModel:
                                _videoManagerService.getReadyControllerFor(
                              widget.videosInfo[itemIndex].id,
                            )!,
                            isExpanded: false,
                            showTitle: false,
                            onTap: (controller) => _onTapRelatedVideo(
                                model: controllers[itemIndex],
                                itemIndex: itemIndex),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      );

  void _onTapRelatedVideo({
    required VideoControllerModel model,
    required int itemIndex,
  }) {
    model.controller.setVolume(1);
    context.read<VideoManagerService>().muteVideo(widget.parentVideo.id);

    Navigator.push(
      context,
      FadePageRoute(
        (BuildContext context) => VideoPage(
          controllerModel: model,
          info: widget.videosInfo[itemIndex],
          previousVideoInfo: widget.parentVideo,
        ),
      ),
    );
  }
}
