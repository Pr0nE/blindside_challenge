import 'package:blindside_challenge/blocs/comments/comments_state.dart';
import 'package:blindside_challenge/repositories/comments_repository.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Handles state of the comment section for a single video.
///
/// It interacts with a [CommentsRepository] dependency to fetch related comments.
class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit({required this.commentsRepository})
      : super(CommentsLoadingState());

  /// Instance of repository dependency.
  final CommentsRepository commentsRepository;

  /// Starts fetching comments of provided [videoId].
  ///
  /// After successful fetch, cubit emits [CommentsLoadedState] which contains list of comments.
  void fetchCommentsFor(String videoId) {
    emit(CommentsLoadingState());

    final comments = commentsRepository.fetchCommentsFor(videoId);

    emit(
      CommentsLoadedState(comments.toList()),
    );
  }

  /// Adds the provided [newComment] to comments repository.
  void addComment(CommentModel newComment) {
    if (state is CommentsLoadedState) {
      commentsRepository.addNewComment(newComment);

      final comments = commentsRepository.fetchCommentsFor(newComment.videoId);

      emit(CommentsLoadedState(comments.toList()));
    }
  }
}
