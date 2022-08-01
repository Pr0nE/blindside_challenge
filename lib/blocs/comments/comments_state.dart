import 'package:blindside_challenge/widgets/comments_widget.dart';

/// Holds state of a comment section.
abstract class CommentsState {}

/// Indicates a loading state for a comment section.
class CommentsLoadingState extends CommentsState {}

/// Holds loaded comments for a comment section.
class CommentsLoadedState extends CommentsState {
  CommentsLoadedState(this.comments);

  /// Loaded comments.
  final List<CommentModel> comments;
}
