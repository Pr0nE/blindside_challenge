import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Responsible for displaying a single video.
///
/// This widget has also an inner video payer.
class VideoItemWidget extends StatefulWidget {
  const VideoItemWidget({
    Key? key,
    required this.info,
    required this.isExpanded,
    required this.controllerModel,
    required this.onTap,
    this.showTitle = true,
  }) : super(key: key);

  final VideoInfoModel info;
  final bool isExpanded;
  final bool showTitle;
  final void Function(VideoControllerModel) onTap;

  final VideoControllerModel controllerModel;

  @override
  State<VideoItemWidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  @override
  Widget build(BuildContext context) => Hero(
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
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Text(
                    widget.info.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.isExpanded ? 0 : 8),
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.onTap(widget.controllerModel);
                  },
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayer(widget.controllerModel.controller),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
