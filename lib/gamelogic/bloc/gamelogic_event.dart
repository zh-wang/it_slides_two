part of 'gamelogic_bloc.dart';

abstract class GameLogicEvent extends Equatable {
  const GameLogicEvent();

  @override
  List<Object> get props => [];
}

class GameLogicEventInit extends GameLogicEvent {

  const GameLogicEventInit();
}

class GameLogicEventSwipe extends GameLogicEvent {
  final SwipeDir swipeDir;

  const GameLogicEventSwipe(this.swipeDir);
}

class GameLogicEventMoveEnded extends GameLogicEvent {
  final int indexOfSlider;

  const GameLogicEventMoveEnded(this.indexOfSlider);
}

class GameLogicEventWin extends GameLogicEvent {

  const GameLogicEventWin();
}

class GameLogicEventRestart extends GameLogicEvent {

  const GameLogicEventRestart();
}

class GameLogicEventToggleGuideView extends GameLogicEvent {

  const GameLogicEventToggleGuideView();
}

class GameLogicEventUpdateIsFirstTime extends GameLogicEvent {
  final bool isFirstTime;

  const GameLogicEventUpdateIsFirstTime(this.isFirstTime);
}

class GameLogicEventUpdatePuzzleSize extends GameLogicEvent {
  final int puzzleSize;

  const GameLogicEventUpdatePuzzleSize(this.puzzleSize);
}

class GameLogicEventUpdateTheme extends GameLogicEvent {

  const GameLogicEventUpdateTheme();
}
