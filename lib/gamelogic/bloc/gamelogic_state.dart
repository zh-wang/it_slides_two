// ignore_for_file: public_member_api_docs

part of 'gamelogic_bloc.dart';

enum GameState {
  init,
  running,
  win,
}

class GameLogicState extends Equatable {
  const GameLogicState({
    this.puzzleSize = 0,
    this.board = const RawPuzzleBoard(),
    this.pos01 = const Pii(0, 0),
    this.pos02 = const Pii(0, 0),
    this.moveDist01 = -1, // -1 for board init
    this.moveDist02 = -1, // -1 for board init
    this.lastSwipeDir = SwipeDir.none,
    this.moves = 0,
    this.theme = const ThemeLight(),
    this.indexOfTheme = 0,
    this.gameState = GameState.running,
    this.boardId = "",
    this.numOfActions = 0,
    this.isFirstTime = false,
  });

  final int puzzleSize;
  final RawPuzzleBoard board;
  final Pii pos01;
  final Pii pos02;
  final int moveDist01;
  final int moveDist02;
  final SwipeDir lastSwipeDir;
  final int moves;
  final int numOfActions;
  final BaseTheme theme;
  final int indexOfTheme;
  final GameState gameState;
  final String boardId;
  final bool isFirstTime;

  @override
  List<Object> get props => [
    puzzleSize,
    pos01,
    pos02,
    moveDist01,
    moveDist02,
    lastSwipeDir,
    moves,
    gameState,
    boardId,
    numOfActions,
    isFirstTime,
    indexOfTheme
  ];

  GameLogicState copyWith({
    int? puzzleSize,
    RawPuzzleBoard? board,
    Pii? pos01,
    Pii? pos02,
    int? moveDist01,
    int? moveDist02,
    SwipeDir? lastSwipeDir,
    int? moves,
    BaseTheme? theme,
    int? indexOfTheme,
    GameState? gameState,
    String? boardId,
    int? numOfActions,
    bool? isFirstTime,
  }) {
    return GameLogicState(
      puzzleSize: puzzleSize ?? this.puzzleSize,
      board: board ?? this.board,
      pos01: pos01 ?? this.pos01,
      pos02: pos02 ?? this.pos02,
      moveDist01: moveDist01 ?? this.moveDist01,
      moveDist02: moveDist02 ?? this.moveDist02,
      lastSwipeDir: lastSwipeDir ?? this.lastSwipeDir,
      moves: moves ?? this.moves,
      theme: theme ?? this.theme,
      indexOfTheme: indexOfTheme ?? this.indexOfTheme,
      gameState: gameState ?? this.gameState,
      boardId: boardId ?? this.boardId,
      numOfActions: numOfActions ?? this.numOfActions,
      isFirstTime: isFirstTime ?? this.isFirstTime
    );
  }
}