import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bazaarniti/manager/static_method.dart';
import 'package:bazaarniti/values/colors.dart';
import 'package:bazaarniti/values/dimens.dart';
import 'package:bazaarniti/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'audio_player_buttons.dart';
import 'seek_bar.dart';
import 'package:audio_session/audio_session.dart';

class playButton extends StatefulWidget {
  final v, details;

  const playButton({super.key, this.v, this.details});

  @override
  State<playButton> createState() => _playButtonState();
}

class _playButtonState extends State<playButton> {
  AudioPlayer? _audioPlayer;

  Future<void> _init() async {
    _audioPlayer = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _audioPlayer!.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      STM().errorDialog(context, 'A stream error occurred: $e');
      print('A stream error occurred: $e');
    });
    try {
      await _audioPlayer!.setAudioSource(AudioSource.uri(
        Uri.parse(widget.v['audio']),
        tag: MediaItem(
          playable: true,
          id: '${widget.details['id']}',
          album: "${widget.details['name']}",
          title: "${widget.v['name']}",
          artUri: Uri.parse(
              "https://img.freepik.com/free-vector/detailed-podcast-logo-template_23-2148786067.jpg"),
        ),
      ));
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      STM().errorDialog(context, "Error loading playlist: $e");
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer!.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer!.positionStream,
          _audioPlayer!.bufferedPositionStream,
          _audioPlayer!.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Clr().screenBackground,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Clr().white),
        title: Text('${widget.v['name']}'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Clr().screenBackground,
        actions: [
          SvgPicture.asset('assets/sharewhite.svg', height: Dim().d24),
          SizedBox(
            width: Dim().d12,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dim().d36,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  height: Dim().d140,
                  width: Dim().d140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Clr().yellow, width: 4),
                      image: DecorationImage(
                        image: NetworkImage(
                            '${widget.details['user']['image'].toString()}'),
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(
                  width: Dim().d20,
                ),
                Expanded(
                    child: Text('${widget.details['user']['name'].toString()}',
                        style: Sty().mediumText.copyWith(color: Clr().white)))
              ]),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              child: Text('${widget.details['name']}',
                  style: Sty().extraLargeText.copyWith(
                      color: Clr().yellow, fontWeight: FontWeight.w300)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              child: Text('${widget.v['description']}',
                  style: Sty().microText.copyWith(
                      color: Clr().white, fontWeight: FontWeight.w100)),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Padding(
                  padding: EdgeInsets.zero,
                  child: SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                    onChangeEnd: _audioPlayer!.seek,
                  ),
                );
              },
            ),
            Align(
                alignment: Alignment.center,
                child: PlayerButtons(_audioPlayer!)),
            SizedBox(
              height: Dim().d20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              child: Text('Transcript',
                  style: Sty().mediumText.copyWith(color: Clr().white)),
            ),
            SizedBox(
              height: Dim().d16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d20),
              child: Text('${widget.v['transcript']}',
                  style: Sty().microText.copyWith(
                      color: Clr().white, fontWeight: FontWeight.w300)),
            ),
          ],
        ),
      ),
    );
  }
}
