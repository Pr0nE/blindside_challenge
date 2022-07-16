import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';

class CommentsRepository {
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

  List<CommentModel> fetchCommentsFor(VideoModel video) =>
      _comments.where((element) => element.id != video.id).toList();
}
