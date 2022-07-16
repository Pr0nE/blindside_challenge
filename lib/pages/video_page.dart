import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'package:blindside_challenge/blocs/comments/comments_cubit.dart';
import 'package:blindside_challenge/blocs/comments/comments_state.dart';
import 'package:blindside_challenge/blocs/videos/videos_cubit.dart';
import 'package:blindside_challenge/blocs/videos/videos_state.dart';
import 'package:blindside_challenge/extensions/extensions.dart';
import 'package:blindside_challenge/helpers/controller_initializer_mixin.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/repositories/comments_repository.dart';
import 'package:blindside_challenge/theme/colors.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:blindside_challenge/widgets/related_videos_widget.dart';
import 'package:blindside_challenge/widgets/video_item_widget.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({
    Key? key,
    required this.controller,
    required this.info,
    this.previousVideoInfo,
  }) : super(key: key);

  final VideoModel info;
  final VideoModel? previousVideoInfo;

  final VideoPlayerController controller;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with VideoControllerMixin {
  late final CommentsCubit _commentsCubit;

  @override
  void initState() {
    _commentsCubit = CommentsCubit(commentsRepository: CommentsRepository());
    _commentsCubit.fetchCommentsFor(widget.info);

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
                  controllerFuture: Future.value(widget.controller),
                  controller: widget.controller,
                  isExpanded: true,
                  onTap: _onTapVideo,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      BlocBuilder<VideosCubit, VideosState>(
                        builder: (context, state) => RelatedVideosWidget(
                          videosInfo: state
                                  .asOrNull<VideosLoadedState>()
                                  ?.fetchRelatedVideosFor(widget.info) ??
                              [],
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

  void _onTapVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  Future<bool> _onWillPop() {
    widget.controller.play();
    widget.controller.setVolume(0);

    if (widget.previousVideoInfo != null) {
      getControllerFor(widget.previousVideoInfo!)?.setVolume(1);
    }

    return Future.value(true);
  }
}
