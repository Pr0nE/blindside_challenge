import 'package:blindside_challenge/blocs/videos/videos_cubit.dart';
import 'package:blindside_challenge/blocs/videos/videos_state.dart';
import 'package:blindside_challenge/extensions/extensions.dart';
import 'package:blindside_challenge/model/video_model.dart';
import 'package:blindside_challenge/pages/auth_page.dart';
import 'package:blindside_challenge/theme/colors.dart';
import 'package:blindside_challenge/widgets/comments_widget.dart';
import 'package:blindside_challenge/widgets/video_list_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    _startListenUserAuthStatus();
    context.read<VideosCubit>().fetchAllVideos();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: Text(userName),
          actions: [
            IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<VideosCubit, VideosState>(
                  builder: (context, state) => VideoListWidget(
                    information:
                        state.asOrNull<VideosLoadedState>()?.videos ?? [],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  String get userName =>
      FirebaseAuth.instance.currentUser?.email ?? 'Anonymous user';

  void _startListenUserAuthStatus() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthPage()),
            (Route<dynamic> route) => false);
      }
    });
  }
}
