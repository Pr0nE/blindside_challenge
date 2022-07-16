import 'package:blindside_challenge/blocs/videos/videos_cubit.dart';
import 'package:blindside_challenge/firebase_options.dart';
import 'package:blindside_challenge/pages/auth_page.dart';
import 'package:blindside_challenge/repositories/videos_repository.dart';
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
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<VideosCubit>(
            create: (context) =>
                VideosCubit(videosRepository: VideosRepository()),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          debugShowCheckedModeBanner: false,
          home: const AuthPage(),
        ),
      );
}
