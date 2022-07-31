import 'package:blindside_challenge/helpers/fade_page_route.dart';
import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/services/video_manager_service.dart';
import 'package:blindside_challenge/widgets/video_item_widget.dart';
import 'package:blindside_challenge/pages/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoListWidget extends StatefulWidget {
  const VideoListWidget({
    Key? key,
    required this.information,
  }) : super(key: key);

  final List<VideoInfoModel> information;

  @override
  State<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  late final Future<List<VideoControllerModel>> controllers;
  late final VideoManagerService _videoManagerService;

  @override
  void initState() {
    _videoManagerService = context.read<VideoManagerService>();
    controllers = _videoManagerService
        .getVideoList(widget.information.map((e) => e.id).toList());

    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      FutureBuilder<List<VideoControllerModel>>(
        future: controllers,
        builder: (context, snapshot) => snapshot.hasData
            ? ListView.separated(
                itemCount: widget.information.length,
                itemBuilder: (BuildContext context, int itemIndex) =>
                    VideoItemWidget(
                  controllerModel: snapshot.data![itemIndex],
                  info: widget.information[itemIndex],
                  isExpanded: false,
                  onTap: (controller) => _onTapVideo(
                    model: snapshot.data![itemIndex],
                    itemIndex: itemIndex,
                  ),
                ),
                separatorBuilder: (BuildContext context, int itemIndex) =>
                    const SizedBox(height: 50),
              )
            : const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              ),
      );

  void _onTapVideo({
    required VideoControllerModel model,
    required int itemIndex,
  }) {
    model.controller.setVolume(1);

    Navigator.push(
        context,
        FadePageRoute(
          (BuildContext context) => VideoPage(
            controllerModel: model,
            info: widget.information[itemIndex],
          ),
        ));
    return;
  }
}
