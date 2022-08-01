import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:flutter/material.dart';

/// Displays information of a single [comment].
class CommentItemWidget extends StatelessWidget {
  final CommentModel comment;
  const CommentItemWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.author,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(comment.message),
              ),
            ),
          ],
        ),
      );
}
