import 'dart:ui';

import 'package:blindside_challenge/model/video_info_model.dart';
import 'package:blindside_challenge/widgets/video_list_widget.dart';
import 'package:blindside_challenge/pages/video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoInfo> videos = [
    VideoInfo(id: '1', title: 'Was ist Blindside?'),
    VideoInfo(
      id: '2',
      title: 'Teaser NIKE in Tenerife',
    )
    // VideoInfo(id: '3', title: 'Video 3'),
    // VideoInfo(id: '4', title: 'Video 4'),
    // VideoInfo(id: '5', title: 'Video 5'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        //backgroundColor: Colors.black12,
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: VideoListWidget(
                  information: videos,
                  onLoaded: (List<VideoPlayerController> controllers) =>
                      print(controllers),
                ),
              ),
            ),
          ],
        ),
      );
}
