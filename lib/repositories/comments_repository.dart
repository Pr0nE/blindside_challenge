import 'package:blindside_challenge/widgets/comments_widget.dart';

/// An abstraction for storing and fetching comments section.
abstract class CommentsRepository {
  Iterable<CommentModel> fetchCommentsFor(String videoId);
  void addNewComment(CommentModel comment);
}

/// A concrete class of [CommentsRepository] which stores comments in a local variable.
class CommentsRepositoryImpl implements CommentsRepository {
  final List<CommentModel> _comments = [
    CommentModel(author: 'David', message: 'Cool stuff!', videoId: '1'),
    CommentModel(
        author: 'James', message: 'Love it, keep it up.', videoId: '2'),
    CommentModel(
        author: 'Elena',
        message: 'Nice, i hope it would get even better in the future.',
        videoId: '3'),
    CommentModel(
        author: 'Jia', message: 'These guys are rocking it!', videoId: '3'),
  ];

  @override
  Iterable<CommentModel> fetchCommentsFor(String videoId) =>
      _comments.where((comment) => comment.id == videoId);

  @override
  void addNewComment(CommentModel comment) => _comments.add(comment);
}
