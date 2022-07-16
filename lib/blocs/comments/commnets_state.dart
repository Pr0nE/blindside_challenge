import 'package:blindside_challenge/widgets/comments_widget.dart';

abstract class CommentsState {}

class CommentsLoadingState extends CommentsState {}

class CommentsLoadedState extends CommentsState {
  CommentsLoadedState(this.comments);

  final List<CommentModel> comments;
}

class CommentsUpdatedState extends CommentsLoadedState {
  CommentsUpdatedState(super.comments);
}
