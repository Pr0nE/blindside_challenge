import 'package:blindside_challenge/model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoItemWidget extends StatefulWidget {
  const VideoItemWidget({
    Key? key,
    required this.info,
    required this.controllerFuture,
    required this.isExpanded,
    required this.onTap,
    this.showTitle = true,
    this.controller,
  }) : super(key: key);

  final VideoModel info;
  final bool isExpanded;
  final Future<VideoPlayerController> controllerFuture;
  final bool showTitle;
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
                  if (widget.showTitle)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        widget.info.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffEEEEEE),
                        ),
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
