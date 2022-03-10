import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:it_slides_two/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'audio_control/audio_control.dart';
import 'gamelogic/gamelogic.dart';

class PuzzleKeyboardHandler extends StatefulWidget {
  /// {@macro puzzle_keyboard_handler}
  const PuzzleKeyboardHandler({
    Key? key,
    required this.child,
  })  : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  State createState() => _PuzzleKeyboardHandlerState();
}

class _PuzzleKeyboardHandlerState extends State<PuzzleKeyboardHandler> {
  // The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final physicalKey = event.data.physicalKey;
      if (physicalKey == PhysicalKeyboardKey.arrowDown) {
        context.read<GameLogicBloc>().add(const GameLogicEventSwipe(SwipeDir.down));
        context.read<AudioControlBloc>().add(const AudioControlPlaySlideSE(GameState.running));
      } else if (physicalKey == PhysicalKeyboardKey.arrowUp) {
        context.read<GameLogicBloc>().add(const GameLogicEventSwipe(SwipeDir.up));
        context.read<AudioControlBloc>().add(const AudioControlPlaySlideSE(GameState.running));
      } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
        context.read<GameLogicBloc>().add(const GameLogicEventSwipe(SwipeDir.right));
        context.read<AudioControlBloc>().add(const AudioControlPlaySlideSE(GameState.running));
      } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
        context.read<GameLogicBloc>().add(const GameLogicEventSwipe(SwipeDir.left));
        context.read<AudioControlBloc>().add(const AudioControlPlaySlideSE(GameState.running));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.select((GameLogicBloc bloc) => bloc.state.gameState);
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: gameState == GameState.running ? _handleKeyEvent : null,
      child: Builder(
        builder: (context) {
          if (!_focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(_focusNode);
          }
          return widget.child;
        },
      ),
    );
  }
}
