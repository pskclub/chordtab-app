import 'package:chordtab/constants/theme.const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChordYoutubePlayerView extends StatefulWidget {
  const ChordYoutubePlayerView({Key? key}) : super(key: key);

  @override
  _ChordYoutubePlayerViewState createState() => _ChordYoutubePlayerViewState();
}

class _ChordYoutubePlayerViewState extends State<ChordYoutubePlayerView> {
  String _title = '';
  String _author = '';
  bool _isPlaying = false;
  double _percent = 0.01;
  String _duration = '0:00';
  String _nowDuration = '0:00';
  YoutubePlayerController _youtubeController = YoutubePlayerController(
    initialVideoId: 'XuAdG3NjNH8',
    flags: YoutubePlayerFlags(
        autoPlay: true, mute: false, disableDragSeek: true, enableCaption: false, hideControls: true),
  );

  @override
  void initState() {
    _youtubeController.addListener(() {
      setState(() {
        _title = _youtubeController.metadata.title;
        _author = _youtubeController.metadata.author;
        _isPlaying = _youtubeController.value.isPlaying;
        var durationSec = '${_youtubeController.metadata.duration.inSeconds.remainder(60)}';
        _duration =
            '${_youtubeController.metadata.duration.inMinutes.remainder(60)}:${durationSec.length == 1 ? '0$durationSec' : durationSec}';

        var nowDurationSec = '${_youtubeController.value.position.inSeconds.remainder(60)}';
        _nowDuration =
            '${_youtubeController.value.position.inMinutes.remainder(60)}:${nowDurationSec.length == 1 ? '0$nowDurationSec' : nowDurationSec}';
        var percent =
            ((100 * _youtubeController.value.position.inSeconds) / _youtubeController.metadata.duration.inSeconds) /
                100;

        if (percent.isNaN || percent < 0) {
          percent = 0;
        }

        if (percent > 1) {
          percent = 1;
        }
        _percent = percent;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 32,
              ),
              Text(
                _title,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                _author,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 38,
              ),
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 64,
                lineHeight: 4.0,
                percent: _percent,
                progressColor: ThemeColors.secondary,
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_nowDuration),
                    Text(_duration),
                  ],
                ),
              ),
              SizedBox(
                height: 38,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _youtubeController.seekTo(Duration(seconds: _youtubeController.value.position.inSeconds - 10));
                    },
                    child: Icon(Icons.fast_rewind),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                      primary: ThemeColors.primaryLight, // <-- Button color
                      onPrimary: Colors.grey, // <-- Splash color
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_isPlaying) {
                        _youtubeController.pause();
                      } else {
                        _youtubeController.play();
                      }
                    },
                    child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      primary: ThemeColors.secondary, // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _youtubeController.seekTo(Duration(seconds: _youtubeController.value.position.inSeconds + 10));
                    },
                    child: Icon(Icons.fast_forward),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                      primary: ThemeColors.primaryLight, // <-- Button color
                      onPrimary: Colors.grey, // <-- Splash color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
