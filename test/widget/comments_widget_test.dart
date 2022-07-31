import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommentsWidget', () {
    testWidgets('Should not show comments at initial state', (tester) async {
      final comments = [
        CommentModel(
          author: 'testAuthor',
          message: 'testMessage',
          videoId: '',
        )
      ];

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: CommentsWidget(comments: comments))));

      Finder firstCommentMessage = find.text(comments.first.message);

      expect(firstCommentMessage.hitTestable(), findsNothing);
    });
    testWidgets('Should show comments after tapping on widget title',
        (tester) async {
      final comments = [
        CommentModel(
          author: 'testAuthor',
          message: 'testMessage',
          videoId: '',
        )
      ];

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CommentsWidget(comments: comments))),
      );

      Finder commentWidget = find.text('Comments');
      Finder firstCommentMessage = find.text(comments.first.message);

      await tester.tap(commentWidget);

      await tester.pumpAndSettle();

      expect(firstCommentMessage.hitTestable(), findsOneWidget);
    });
    testWidgets('Should show textfield when expanded', (tester) async {
      final comments = [
        CommentModel(
          author: 'testAuthor',
          message: 'testMessage',
          videoId: '',
        )
      ];

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CommentsWidget(comments: comments))),
      );

      Finder commentWidget = find.text('Comments');
      Finder textFieldFinder = find.byType(TextField);

      await tester.tap(commentWidget);

      await tester.pumpAndSettle();

      expect(textFieldFinder, findsOneWidget);
    });
  });
}
