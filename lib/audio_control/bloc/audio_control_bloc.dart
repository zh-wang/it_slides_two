// ignore_for_file: public_member_api_docs

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_slides_two/gamelogic/bloc/gamelogic_bloc.dart';

part 'audio_control_event.dart';
part 'audio_control_state.dart';

class AudioControlBloc extends Bloc<AudioControlEvent, AudioControlState> {

  AudioControlBloc() : super(const AudioControlState()) {
    on<AudioControlPlayClickSE>(_onAudioControlPlayClickSE);
    on<AudioControlPlaySlideSE>(_onAudioControlPlaySlideSE);
    on<AudioControlPlayWinSE>(_onAudioControlPlayWinSE);

    _cacheClickSE.loadAll([seClick]);
    _cacheWinSE.loadAll([seWin]);
    _cacheSlideSE.loadAll([seSlide]);
  }

  static const seClick = "sounds/click01.wav";
  static const seWin = "sounds/claps_5s.mp3";
  static const seSlide = "sounds/click.mp3";

  final AudioCache _cacheClickSE = AudioCache(
    fixedPlayer: AudioPlayer(mode: PlayerMode.LOW_LATENCY),
  );

  final AudioCache _cacheWinSE = AudioCache(
    fixedPlayer: AudioPlayer(mode: PlayerMode.LOW_LATENCY),
  );

  final AudioCache _cacheSlideSE = AudioCache(
    fixedPlayer: AudioPlayer(mode: PlayerMode.LOW_LATENCY),
  );

  void _onAudioControlPlayClickSE(AudioControlPlayClickSE event, Emitter<AudioControlState> emit) {
    _cacheClickSE.play(seClick);
  }

  void _onAudioControlPlaySlideSE(AudioControlPlaySlideSE event, Emitter<AudioControlState> emit) {
    _cacheClickSE.play(seSlide);
  }

  void _onAudioControlPlayWinSE(AudioControlPlayWinSE event, Emitter<AudioControlState> emit) {
    _cacheWinSE.play(seWin);
  }
}
