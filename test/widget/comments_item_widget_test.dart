import 'package:blindside_challenge/widgets/comment_item_widget.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommentItemWidget', () {
    testWidgets('Should show info of the comment', (tester) async {
      const String testAuthor = 'testAuthor';
      const String testMessage = 'testMessage';

      await tester.pumpWidget(
        MaterialApp(
          home: CommentItemWidget(
            comment: CommentModel(
              author: testAuthor,
              message: testMessage,
              videoId: '',
            ),
          ),
        ),
      );

      Finder authorFinder = find.text(testAuthor);
      Finder messageFinder = find.text(testMessage);

      expect(authorFinder, findsOneWidget);
      expect(messageFinder, findsOneWidget);
    });
  });
}
