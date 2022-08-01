import 'package:blindside_challenge/blocs/comments/comments_cubit.dart';
import 'package:blindside_challenge/blocs/comments/comments_state.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/repositories/comments_repository.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeCommentsRepository extends Mock implements CommentsRepository {}

void main() {
  late final CommentsRepository commentsRepository;
  late final VideoInfoModel fakeInfo;
  late final CommentModel fakeComment;

  setUpAll(() {
    commentsRepository = FakeCommentsRepository();
    fakeInfo = const VideoInfoModel(id: '0', title: '');
    fakeComment = CommentModel(author: '', message: '', videoId: '');

    registerFallbackValue(fakeInfo);
    registerFallbackValue(fakeComment);

    when(() => commentsRepository.fetchCommentsFor(any()))
        .thenAnswer((invocation) => []);
  });

  blocTest(
    'Should emit right states after calling fetchComments',
    build: () => CommentsCubit(commentsRepository: commentsRepository),
    act: (CommentsCubit cubit) => cubit.fetchCommentsFor(fakeInfo.id),
    expect: () => [
      isA<CommentsLoadingState>(),
      isA<CommentsLoadedState>(),
    ],
    verify: (cubit) =>
        verify(() => commentsRepository.fetchCommentsFor(any())).called(1),
  );
  blocTest<CommentsCubit, CommentsState>(
    'Should emit right states after calling addComment',
    build: () => CommentsCubit(commentsRepository: commentsRepository),
    act: (CommentsCubit cubit) => cubit.addComment(fakeComment),
    seed: () => CommentsLoadedState([]),
    expect: () => [
      isA<CommentsLoadedState>(),
    ],
  );
}
