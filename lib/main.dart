import 'package:blindside_challenge/blocs/videos/videos_cubit.dart';
import 'package:blindside_challenge/firebase_options.dart';
import 'package:blindside_challenge/pages/auth_page.dart';
import 'package:blindside_challenge/repositories/comments_repository.dart';
import 'package:blindside_challenge/repositories/videos_repository.dart';
import 'package:blindside_challenge/services/video_initializer_service.dart';
import 'package:blindside_challenge/services/video_manager_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (c) => VideosRepositoryImpl()),
          RepositoryProvider(create: (c) => CommentsRepositoryImpl()),
          RepositoryProvider<VideoManagerService>(
            create: (c) => VideoManagerServiceImpl(
              VideoInitializerServiceImpl(),
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<VideosCubit>(
              create: (context) => VideosCubit(
                videosRepository: context.read<VideosRepository>(),
              ),
            ),
          ],
          child: MaterialApp(
            theme: ThemeData(brightness: Brightness.dark),
            debugShowCheckedModeBanner: false,
            home: const AuthPage(),
          ),
        ),
      );
}
