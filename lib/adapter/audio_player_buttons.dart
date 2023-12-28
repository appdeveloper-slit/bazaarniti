import 'package:bazaarniti/values/colors.dart';
import 'package:bazaarniti/values/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatelessWidget {
  PlayerButtons(this._audioPlayer, {Key? key}) : super(key: key);

  late AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dim().d350,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // StreamBuilder<bool>(
          //   stream: _audioPlayer.shuffleModeEnabledStream,
          //   builder: (context, snapshot) {
          //     return _shuffleButton(context, snapshot.data ?? false);
          //   },
          // ),
          Expanded(
            child: StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return _previousButton();
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                final playerState = snapshot.data!;
                return _playPauseButton(playerState);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return _nextButton();
              },
            ),
          ),
          // StreamBuilder<LoopMode>(
          //   stream: _audioPlayer.loopModeStream,
          //   builder: (context, snapshot) {
          //     return _repeatButton(context, snapshot.data ?? LoopMode.off);
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _playPauseButton(PlayerState playerState) {
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: const CircularProgressIndicator(),
      );
    } else if (_audioPlayer.playing != true) {
      return Container(
        decoration: BoxDecoration(
          color: Clr().yellow,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.play_arrow,
            color: Clr().white,
          ),
          iconSize: 46.0,
          onPressed: _audioPlayer.play,
        ),
      );
    } else if (processingState != ProcessingState.completed) {
      return Container(
        decoration: BoxDecoration(
          color: Clr().yellow,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            Icons.pause,
            color: Clr().white,
          ),
          iconSize: 46.0,
          onPressed: _audioPlayer.pause,
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.replay),
        iconSize: 64.0,
        onPressed: () => _audioPlayer.seek(Duration.zero,
            index: _audioPlayer.effectiveIndices!.first),
      );
    }
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
      icon: isEnabled
          ? Icon(
              Icons.shuffle,
              color: Clr().white,
            )
          : Icon(
              Icons.shuffle,
              color: Clr().white,
            ),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await _audioPlayer.shuffle();
        }
        await _audioPlayer.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _previousButton() {
    return InkWell(
        onTap: () async {
          if (_audioPlayer.position > Duration(seconds: 15)) {
            await _audioPlayer
                .seek(Duration(seconds: _audioPlayer.position.inSeconds - 15));
          } else {
            await _audioPlayer.seek(Duration(seconds: 0));
          }
        },
        child: SvgPicture.asset(
          'assets/previous.svg',
          height: Dim().d32,
        ));
    // return IconButton(
    //   icon: Icon(
    //     Icons.fast_rewind,
    //     color: Clr().white,
    //   ),
    //   iconSize: 25,
    //   onPressed: () async {
    //     if (_audioPlayer.position > Duration(seconds: 15)) {
    //       await _audioPlayer
    //           .seek(Duration(seconds: _audioPlayer.position.inSeconds - 15));
    //     } else {
    //       await _audioPlayer.seek(Duration(seconds: 0));
    //     }
    //   },
    // );
  }

  Widget _nextButton() {
    return InkWell(
        onTap: () async {
          if (_audioPlayer.position > Duration(seconds: 0)) {
            await _audioPlayer
                .seek(Duration(seconds: _audioPlayer.position.inSeconds + 15));
          } else {
            await _audioPlayer.seek(Duration(seconds: 0));
          }
        },
        child: SvgPicture.asset(
          'assets/forward.svg',
          height: Dim().d32,
        ));
    // return IconButton(
    //   icon: Icon(
    //     Icons.fast_forward,
    //     color: Clr().white,
    //   ),
    //   iconSize: 25,
    //   onPressed: () async {
    //     if (_audioPlayer.position > Duration(seconds: 0)) {
    //       await _audioPlayer
    //           .seek(Duration(seconds: _audioPlayer.position.inSeconds + 15));
    //     } else {
    //       await _audioPlayer.seek(Duration(seconds: 0));
    //     }
    //   },
    // );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      Icon(
        Icons.repeat,
        color: Clr().white,
      ),
      Icon(
        Icons.repeat,
        color: Clr().white,
      ),
      Icon(
        Icons.repeat_one,
        color: Clr().white,
      ),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        _audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}
