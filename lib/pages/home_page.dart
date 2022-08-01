import 'dart:async';

import 'package:blindside_challenge/services/video_manager_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blindside_challenge/blocs/videos/videos_cubit.dart';
import 'package:blindside_challenge/blocs/videos/videos_state.dart';
import 'package:blindside_challenge/extensions/extensions.dart';
import 'package:blindside_challenge/pages/auth_page.dart';
import 'package:blindside_challenge/theme/colors.dart';
import 'package:blindside_challenge/widgets/video_list_widget.dart';

/// Landing page of an authenticated user.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamSubscription _userAuthStatusSubscription;
  late final VideoManagerService _videoManagerService;

  @override
  void initState() {
    _videoManagerService = context.read<VideoManagerService>();
    _userAuthStatusSubscription = _startListenUserAuthStatus();
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

  StreamSubscription _startListenUserAuthStatus() {
    return FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const AuthPage()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void dispose() {
    _userAuthStatusSubscription.cancel();
    _videoManagerService.disposeAllControllers();

    super.dispose();
  }
}
