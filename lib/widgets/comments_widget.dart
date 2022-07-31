import 'package:blindside_challenge/theme/colors.dart';
import 'package:blindside_challenge/widgets/comment_item_widget.dart';
import 'package:flutter/material.dart';

class CommentsWidget extends StatefulWidget {
  const CommentsWidget({
    required this.comments,
    this.onAddComment,
    Key? key,
  }) : super(key: key);

  final List<CommentModel> comments;
  final Function(String)? onAddComment;

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  late final TextEditingController _textEditingController;

  bool isExpanded = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: accentColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: isExpanded ? 1 : 0),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      builder: (
                        BuildContext context,
                        double value,
                        Widget? child,
                      ) =>
                          ClipRRect(
                        child: Align(
                          heightFactor: value,
                          child: _buildComments(widget.comments),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      );

  Widget _buildComments(List<CommentModel> comments) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textEditingController,
              decoration:
                  const InputDecoration(hintText: 'Write you comment here...'),
              onSubmitted: (text) {
                widget.onAddComment?.call(text);
                _textEditingController.clear();
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                comments.length,
                (int itemIndex) => CommentItemWidget(
                  comment: comments[itemIndex],
                ),
              ),
            ),
          ],
        ),
      );
}

class CommentModel {
  CommentModel({
    required this.author,
    required this.message,
    required this.videoId,
  }) : id = UniqueKey().toString();

  final String id;
  final String videoId;
  final String author;
  final String message;
}
