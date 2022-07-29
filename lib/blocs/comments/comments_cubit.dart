import 'package:blindside_challenge/blocs/comments/comments_state.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/repositories/comments_repository.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit({required this.commentsRepository})
      : super(CommentsLoadingState());

  final CommentsRepository commentsRepository;

  fetchCommentsFor(VideoInfoModel video) {
    emit(CommentsLoadingState());

    final comments = commentsRepository.fetchCommentsFor(video);

    emit(
      CommentsLoadedState(
        comments.where((comment) => comment.videoId == video.id).toList(),
      ),
    );
  }

  addComment(CommentModel newComment) {
    if (state is CommentsLoadedState) {
      final previousComments = (state as CommentsLoadedState).comments;
      emit(CommentsUpdatedState([newComment, ...previousComments]));
    }
  }
}
