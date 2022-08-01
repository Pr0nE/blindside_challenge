import 'package:blindside_challenge/model/video_controller_model.dart';
import 'package:blindside_challenge/services/video_manager_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blindside_challenge/blocs/comments/comments_cubit.dart';
import 'package:blindside_challenge/blocs/comments/comments_state.dart';
import 'package:blindside_challenge/blocs/videos/videos_cubit.dart';
import 'package:blindside_challenge/blocs/videos/videos_state.dart';
import 'package:blindside_challenge/extensions/extensions.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/repositories/comments_repository.dart';
import 'package:blindside_challenge/theme/colors.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:blindside_challenge/widgets/related_videos_widget.dart';
import 'package:blindside_challenge/widgets/video_item_widget.dart';

/// Shows details of a video.
///
/// You may need to pass [previousVideoInfo], if this page get pushed by another instance of a [VideoPage].
class VideoPage extends StatefulWidget {
  const VideoPage({
    Key? key,
    required this.controllerModel,
    required this.info,
    this.previousVideoInfo,
  }) : super(key: key);

  /// Information of the video which this page going to show.
  final VideoInfoModel info;

  /// Information of previous [VideoPage]'s video, is there is any.
  final VideoInfoModel? previousVideoInfo;

  /// Controller of the video.
  ///
  /// We're sure that this controller is initialized as all instances of [VideoControllerModel] has an initialized controller.
  final VideoControllerModel controllerModel;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final CommentsCubit _commentsCubit;
  late final VideosCubit _videosCubit;

  @override
  void initState() {
    _commentsCubit = CommentsCubit(commentsRepository: context.read<CommentsRepository>());
    _videosCubit = context.read<VideosCubit>();
    _commentsCubit.fetchCommentsFor(widget.info.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _commentsCubit,
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: primaryColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              elevation: 0,
            ),
            body: Column(
              children: [
                VideoItemWidget(
                  info: widget.info,
                  controllerModel: widget.controllerModel,
                  isExpanded: true,
                  onTap: _onTapVideo,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      BlocBuilder<VideosCubit, VideosState>(
                        builder: (context, state) => RelatedVideosWidget(
                          videosInfo:
                              _videosCubit.getRelatedVideosFor(widget.info),
                          parentVideo: widget.info,
                        ),
                      ),
                      BlocBuilder<CommentsCubit, CommentsState>(
                        bloc: _commentsCubit,
                        builder: (context, state) => CommentsWidget(
                          comments:
                              state.asOrNull<CommentsLoadedState>()?.comments ??
                                  [],
                          onAddComment: onAddComment,
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  onAddComment(String commentMessage) {
    final currentUser = FirebaseAuth.instance.currentUser?.email;

    _commentsCubit.addComment(
      CommentModel(
        author: currentUser ?? 'Me',
        message: commentMessage,
        videoId: widget.info.id,
      ),
    );
  }

  void _onTapVideo(VideoControllerModel model) {
    if (model.controller.value.isPlaying) {
      model.controller.pause();
    } else {
      model.controller.play();
    }
  }

  Future<bool> _onWillPop() {
    widget.controllerModel.controller.play();
    widget.controllerModel.controller.setVolume(0);

    if (widget.previousVideoInfo != null) {
      context
          .read<VideoManagerService>()
          .getReadyControllerFor(widget.previousVideoInfo!.id)
          ?.controller
          .setVolume(1);
    }

    return Future.value(true);
  }
}
