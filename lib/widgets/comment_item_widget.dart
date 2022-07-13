import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:flutter/material.dart';

class CommentItemWidget extends StatelessWidget {
  final CommentModel comment;
  const CommentItemWidget({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('${comment.author}: ',style: TextStyle(fontWeight: FontWeight.bold),),
            Align(
                alignment: Alignment.centerLeft, child: Text(comment.message)),
          ],
        ),
      );
}