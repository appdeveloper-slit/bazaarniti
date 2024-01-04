import 'package:bazaarniti/adapter/playbutton.dart';
import 'package:bazaarniti/values/colors.dart';
import 'package:bazaarniti/values/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class PlayerButtons extends StatefulWidget {
  final check, audioPlayer;

  PlayerButtons({super.key, this.check, this.audioPlayer});

  @override
  State<PlayerButtons> createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
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
          widget.check
              ? Container()
              : Expanded(
                  child: StreamBuilder<SequenceState?>(
                    stream: widget.audioPlayer.sequenceStateStream,
                    builder: (_, __) {
                      return _previousButton();
                    },
                  ),
                ),
          // Expanded(
          //     child: SvgPicture.asset('assets/arrowbackward.svg',height: Dim().d20,)),
          Expanded(
            child: StreamBuilder<PlayerState>(
              stream: widget.audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                final playerState = snapshot.data!;
                return _playPauseButton(playerState);
              },
            ),
          ),
          // Expanded(
          //     child: SvgPicture.asset('assets/arrowforward.svg',height: Dim().d20,)),
          widget.check
              ? Container()
              : Expanded(
                  child: StreamBuilder<SequenceState?>(
                    stream: widget.audioPlayer.sequenceStateStream,
                    builder: (_, __) {
                      return _nextButton();
                    },
                  ),
                ),
          // StreamBuilder<LoopMode>(
          //   stream: widget.audioPlayer.loopModeStream,
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
    } else if (widget.audioPlayer.playing != true) {
      return InkWell(
        onTap: widget.audioPlayer.play,
        child: Container(
            decoration: BoxDecoration(
              color: Clr().yellow,
              shape: BoxShape.circle,
            ),
            child: Icon(
          Icons.play_arrow,
          size: Dim().d32,
          color: Clr().white,
        )),
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
          onPressed: widget.audioPlayer.pause,
        ),
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.replay),
        color: Clr().white,
        iconSize: 64.0,
        onPressed: () => widget.audioPlayer.seek(Duration.zero,
            index: widget.audioPlayer.effectiveIndices!.first),
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
          await widget.audioPlayer.shuffle();
        }
        await widget.audioPlayer.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _previousButton() {
    return InkWell(
        onTap: () async {
          if (widget.audioPlayer.position > Duration(seconds: 15)) {
            await widget.audioPlayer.seek(
                Duration(seconds: widget.audioPlayer.position.inSeconds - 15));
          } else {
            await widget.audioPlayer.seek(Duration(seconds: 0));
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
    //     if (widget.audioPlayer.position > Duration(seconds: 15)) {
    //       await widget.audioPlayer
    //           .seek(Duration(seconds: widget.audioPlayer.position.inSeconds - 15));
    //     } else {
    //       await widget.audioPlayer.seek(Duration(seconds: 0));
    //     }
    //   },
    // );
  }

  Widget _nextButton() {
    return InkWell(
        onTap: () async {
          if (widget.audioPlayer.position > Duration(seconds: 0)) {
            await widget.audioPlayer.seek(
                Duration(seconds: widget.audioPlayer.position.inSeconds + 15));
          } else {
            await widget.audioPlayer.seek(Duration(seconds: 0));
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
    //     if (widget.audioPlayer.position > Duration(seconds: 0)) {
    //       await widget.audioPlayer
    //           .seek(Duration(seconds: widget.audioPlayer.position.inSeconds + 15));
    //     } else {
    //       await widget.audioPlayer.seek(Duration(seconds: 0));
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
        widget.audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}

// class PlayerButtons extends StatelessWidget {
//   final check;
//
//   PlayerButtons(this._audioPlayer, {Key? key, this.check}) : super(key: key);
//   late AudioPlayer _audioPlayer;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: Dim().d350,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // StreamBuilder<bool>(
//           //   stream: _audioPlayer.shuffleModeEnabledStream,
//           //   builder: (context, snapshot) {
//           //     return _shuffleButton(context, snapshot.data ?? false);
//           //   },
//           // ),
//           check
//               ? Container()
//               : Expanded(
//                   child: StreamBuilder<SequenceState?>(
//                     stream: _audioPlayer.sequenceStateStream,
//                     builder: (_, __) {
//                       return _previousButton();
//                     },
//                   ),
//                 ),
//           // Expanded(
//           //     child: SvgPicture.asset('assets/arrowbackward.svg',height: Dim().d20,)),
//           Expanded(
//             child: StreamBuilder<PlayerState>(
//               stream: _audioPlayer.playerStateStream,
//               builder: (_, snapshot) {
//                 final playerState = snapshot.data!;
//                 return _playPauseButton(playerState);
//               },
//             ),
//           ),
//           // Expanded(
//           //     child: SvgPicture.asset('assets/arrowforward.svg',height: Dim().d20,)),
//           check
//               ? Container()
//               : Expanded(
//                   child: StreamBuilder<SequenceState?>(
//                     stream: _audioPlayer.sequenceStateStream,
//                     builder: (_, __) {
//                       return _nextButton();
//                     },
//                   ),
//                 ),
//           // StreamBuilder<LoopMode>(
//           //   stream: _audioPlayer.loopModeStream,
//           //   builder: (context, snapshot) {
//           //     return _repeatButton(context, snapshot.data ?? LoopMode.off);
//           //   },
//           // ),
//         ],
//       ),
//     );
//   }
//
//   Widget _playPauseButton(PlayerState playerState) {
//     final processingState = playerState.processingState;
//     if (processingState == ProcessingState.loading ||
//         processingState == ProcessingState.buffering) {
//       return Container(
//         margin: const EdgeInsets.all(8.0),
//         width: 64.0,
//         height: 64.0,
//         child: const CircularProgressIndicator(),
//       );
//     } else if (_audioPlayer.playing != true) {
//       return Container(
//         // decoration: BoxDecoration(
//         //   color: Clr().yellow,
//         //   shape: BoxShape.circle,
//         // ),
//         child: IconButton(
//           icon: Icon(
//             Icons.play_arrow,
//             color: Clr().white,
//           ),
//           iconSize: 46.0,
//           onPressed: _audioPlayer.play,
//         ),
//       );
//     } else if (processingState != ProcessingState.completed) {
//       return Container(
//         // decoration: BoxDecoration(
//         //   color: Clr().yellow,
//         //   shape: BoxShape.circle,
//         // ),
//         child: IconButton(
//           icon: Icon(
//             Icons.pause,
//             color: Clr().white,
//           ),
//           iconSize: 46.0,
//           onPressed: _audioPlayer.pause,
//         ),
//       );
//     } else {
//       return IconButton(
//         icon: const Icon(Icons.replay),
//         iconSize: 64.0,
//         onPressed: () => _audioPlayer.seek(Duration.zero,
//             index: _audioPlayer.effectiveIndices!.first),
//       );
//     }
//   }
//
//   Widget _shuffleButton(BuildContext context, bool isEnabled) {
//     return IconButton(
//       icon: isEnabled
//           ? Icon(
//               Icons.shuffle,
//               color: Clr().white,
//             )
//           : Icon(
//               Icons.shuffle,
//               color: Clr().white,
//             ),
//       onPressed: () async {
//         final enable = !isEnabled;
//         if (enable) {
//           await _audioPlayer.shuffle();
//         }
//         await _audioPlayer.setShuffleModeEnabled(enable);
//       },
//     );
//   }
//
//   Widget _previousButton() {
//     return InkWell(
//         onTap: () async {
//           if (_audioPlayer.position > Duration(seconds: 15)) {
//             await _audioPlayer
//                 .seek(Duration(seconds: _audioPlayer.position.inSeconds - 15));
//           } else {
//             await _audioPlayer.seek(Duration(seconds: 0));
//           }
//         },
//         child: SvgPicture.asset(
//           'assets/previous.svg',
//           height: Dim().d32,
//         ));
//     // return IconButton(
//     //   icon: Icon(
//     //     Icons.fast_rewind,
//     //     color: Clr().white,
//     //   ),
//     //   iconSize: 25,
//     //   onPressed: () async {
//     //     if (_audioPlayer.position > Duration(seconds: 15)) {
//     //       await _audioPlayer
//     //           .seek(Duration(seconds: _audioPlayer.position.inSeconds - 15));
//     //     } else {
//     //       await _audioPlayer.seek(Duration(seconds: 0));
//     //     }
//     //   },
//     // );
//   }
//
//   Widget _nextButton() {
//     return InkWell(
//         onTap: () async {
//           if (_audioPlayer.position > Duration(seconds: 0)) {
//             await _audioPlayer
//                 .seek(Duration(seconds: _audioPlayer.position.inSeconds + 15));
//           } else {
//             await _audioPlayer.seek(Duration(seconds: 0));
//           }
//         },
//         child: SvgPicture.asset(
//           'assets/forward.svg',
//           height: Dim().d32,
//         ));
//     // return IconButton(
//     //   icon: Icon(
//     //     Icons.fast_forward,
//     //     color: Clr().white,
//     //   ),
//     //   iconSize: 25,
//     //   onPressed: () async {
//     //     if (_audioPlayer.position > Duration(seconds: 0)) {
//     //       await _audioPlayer
//     //           .seek(Duration(seconds: _audioPlayer.position.inSeconds + 15));
//     //     } else {
//     //       await _audioPlayer.seek(Duration(seconds: 0));
//     //     }
//     //   },
//     // );
//   }
//
//   Widget _repeatButton(BuildContext context, LoopMode loopMode) {
//     final icons = [
//       Icon(
//         Icons.repeat,
//         color: Clr().white,
//       ),
//       Icon(
//         Icons.repeat,
//         color: Clr().white,
//       ),
//       Icon(
//         Icons.repeat_one,
//         color: Clr().white,
//       ),
//     ];
//     const cycleModes = [
//       LoopMode.off,
//       LoopMode.all,
//       LoopMode.one,
//     ];
//     final index = cycleModes.indexOf(loopMode);
//     return IconButton(
//       icon: icons[index],
//       onPressed: () {
//         _audioPlayer.setLoopMode(
//             cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
//       },
//     );
//   }
// }
