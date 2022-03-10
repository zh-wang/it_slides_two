
import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:it_slides_two/puzzle/puzzle.dart';
import 'package:it_slides_two/utils/color_palettes.dart';
import 'package:it_slides_two/utils/pair.dart';
import 'package:it_slides_two/utils/prefs.dart';
import 'package:it_slides_two/utils/swipe_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'gamelogic_event.dart';
part 'gamelogic_state.dart';

class GameLogicBloc extends Bloc<GameLogicEvent, GameLogicState> {

  late RawPuzzleBoard puzzleBoard;
  late List<PuzzleBoardSlot> slots;
  late Pii c1; // current postion of slider 1
  late Pii c2; // current postion of slider 2
  late bool isMoving01 = false;
  late bool isMoving02 = false;
  late int moves = 0;
  late int numOfActions = 0;
  late bool isFirstTime = false;
  late GameState gameState = GameState.init;
  late int puzzleSize = 4;
  late int indexOfTheme = 0;

  final ThemeDark themeDark = const ThemeDark();
  final ThemeLight themeLight = const ThemeLight();

  GameLogicBloc()
      : super(const GameLogicState()) {
    on<GameLogicEventInit>(_onGameLogicEventInit);
    on<GameLogicEventSwipe>(_onGameLogicEventSwipe);
    on<GameLogicEventMoveEnded>(_onGameLogicEventMoveEnded);
    on<GameLogicEventWin>(_onGameLogicEventWin);
    on<GameLogicEventRestart>(_onGameLogicEventRestart);
    on<GameLogicEventToggleGuideView>(_onGameLogicEventToggleGuideView);
    on<GameLogicEventUpdateIsFirstTime>(_onGameLogicEventUpdateIsFirstTime);
    on<GameLogicEventUpdatePuzzleSize>(_onGameLogicEventUpdatePuzzleSize);
    on<GameLogicEventUpdateTheme>(_onGameLogicEventUpdateTheme);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void _onGameLogicEventUpdateTheme(GameLogicEventUpdateTheme event, Emitter<GameLogicState> emit) async {
    debugPrint("_onGameLogicEventUpdateTheme");
    indexOfTheme = 1 - indexOfTheme;
    emit(state.copyWith(
      indexOfTheme: indexOfTheme,
      theme: indexOfTheme == 0 ? themeLight : themeDark
    ));

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefsKeyChoosedTheme, indexOfTheme);
  }

  void _onGameLogicEventUpdatePuzzleSize(GameLogicEventUpdatePuzzleSize event, Emitter<GameLogicState> emit) async {
    debugPrint("_onGameLogicEventUpdatePuzzleSize");
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefsKeyChoosedSize, event.puzzleSize);

    add(const GameLogicEventInit());
  }

  void _onGameLogicEventUpdateIsFirstTime(GameLogicEventUpdateIsFirstTime event, Emitter<GameLogicState> emit) async {
    debugPrint("_onGameLogicEventUpdateIsFirstTime");
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(prefsKeyIsFirstTime, event.isFirstTime);
    isFirstTime = event.isFirstTime;

    add(const GameLogicEventToggleGuideView());
  }

  void _onGameLogicEventToggleGuideView(GameLogicEventToggleGuideView event, Emitter<GameLogicState> emit) async {
    debugPrint("_onGameLogicEventToggleGuideView");
    final prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool(prefsKeyIsFirstTime) ?? true;
    gameState = GameState.running;
    emit(state.copyWith(
        isFirstTime: isFirstTime,
        gameState: gameState
    ));
  }

  void _onGameLogicEventRestart(GameLogicEventRestart event, Emitter<GameLogicState> emit) {
    debugPrint("_onGameLogicEventRestart");
    isMoving01 = isMoving02 = false;
    moves = numOfActions = 0;
    slots = _genPuzzleBoardSlots(puzzleBoard);
    c1 = puzzleBoard.s1;
    c2 = puzzleBoard.s2;
    slots[puzzleBoard.getIndexByRowCol(puzzleBoard.s1)].occupied = true;
    slots[puzzleBoard.getIndexByRowCol(puzzleBoard.s2)].occupied = true;
    gameState = GameState.init;
    emit(state.copyWith(
        board: puzzleBoard,
        pos01: c1,
        pos02: c2,
        moveDist01: -1,
        moveDist02: -1,
        lastSwipeDir: SwipeDir.none,
        moves: moves,
        numOfActions: numOfActions,
        gameState: gameState,
        boardId: puzzleBoard.id
    ));

    add(const GameLogicEventToggleGuideView());
  }

  void _onGameLogicEventInit(GameLogicEventInit event, Emitter<GameLogicState> emit) async {
    debugPrint("_onGameLogicEventInit");

    final prefs = await SharedPreferences.getInstance();

    // test
    // prefs.setBool(prefsKeyIsFirstTime, true);
    // isFirstTime = true;

    puzzleSize = prefs.getInt(prefsKeyChoosedSize) ?? 4;
    indexOfTheme = prefs.getInt(prefsKeyChoosedTheme) ?? 0;

    debugPrint("indexoftheme: $indexOfTheme");

    isMoving01 = isMoving02 = false;
    moves = numOfActions = 0;
    puzzleBoard = await _getBoardFromAsset(Random().nextInt(100), puzzleSize);
    // puzzleBoard = await _getBoardFromAsset(1, 4);
    slots = _genPuzzleBoardSlots(puzzleBoard);
    c1 = puzzleBoard.s1;
    c2 = puzzleBoard.s2;
    slots[puzzleBoard.getIndexByRowCol(puzzleBoard.s1)].occupied = true;
    slots[puzzleBoard.getIndexByRowCol(puzzleBoard.s2)].occupied = true;

    gameState = GameState.init;

    emit(state.copyWith(
        puzzleSize: puzzleSize,
        board: puzzleBoard,
        pos01: c1,
        pos02: c2,
        moveDist01: -1,
        moveDist02: -1,
        lastSwipeDir: SwipeDir.none,
        moves: moves,
        numOfActions: 0,
        gameState: gameState,
        boardId: puzzleBoard.id,
        theme: indexOfTheme == 0 ? themeLight : themeDark,
        indexOfTheme: indexOfTheme
    ));

    Future.delayed(const Duration(milliseconds: 1000), () {
      add(const GameLogicEventToggleGuideView());
    });
  }

  void _onGameLogicEventSwipe(GameLogicEventSwipe event, Emitter<GameLogicState> emit) {
    if (isMoving01 || isMoving02) {
      debugPrint("_onGameLogicEventSwipe isMoving");
      return;
    }

    if (isFirstTime) {
      debugPrint("_onGameLogicEventSwipe isFirstTime");
      return;
    }

    if (gameState == GameState.win || gameState == GameState.init) {
      debugPrint("_onGameLogicEventSwipe isWin");
      return;
    }

    debugPrint("_onGameLogicEventSwipe, " + event.swipeDir.name);
    isMoving01 = isMoving02 = true;
    numOfActions++;
    var needReorder = _needReorderBySwipeDir(c1, c2, event.swipeDir);
    int moveDist01 = -1;
    int moveDist02 = -1;
    if (needReorder) {
      moveDist02 = _performSingleMove(puzzleBoard.getIndexByRowCol(c2), event.swipeDir, 2);
      moveDist01 = _performSingleMove(puzzleBoard.getIndexByRowCol(c1), event.swipeDir, 1);
    } else {
      moveDist01 = _performSingleMove(puzzleBoard.getIndexByRowCol(c1), event.swipeDir, 1);
      moveDist02 = _performSingleMove(puzzleBoard.getIndexByRowCol(c2), event.swipeDir, 2);
    }
    // print("moveDist01: $moveDist01 moveDist02: $moveDist02");
    if (moveDist01 > 0 || moveDist02 > 0) {
      moves++;
      // print("current moves is $moves");
    }
    // print("current numOfActions is $numOfActions");

    emit(state.copyWith(
        pos01: c1,
        pos02: c2,
        moveDist01: moveDist01,
        moveDist02: moveDist02,
        lastSwipeDir: event.swipeDir,
        moves: moves,
        numOfActions: numOfActions,
        gameState: gameState
    ));
  }

  void _onGameLogicEventMoveEnded(GameLogicEventMoveEnded event, Emitter<GameLogicState> emit) {
    debugPrint("_onGameLogicEventMoveEnded");
    if (event.indexOfSlider == 0) {
      isMoving01 = false;
    } else {
      isMoving02 = false;
    }
    // print("$isMoving01, $isMoving02, $c1, ${puzzleBoard.t1}, $c2, ${puzzleBoard.t2}");
    if (!isMoving01 && !isMoving02 && puzzleBoard.t1 == c1 && puzzleBoard.t2 == c2) {
      emit(state.copyWith(gameState: GameState.win));
    }
  }

  void _onGameLogicEventWin(GameLogicEventWin event, Emitter<GameLogicState> emit) {
    debugPrint("_onGameLogicEventWin");
    gameState = GameState.win;
    emit(state.copyWith(gameState: gameState));
  }

  Future<RawPuzzleBoard> _getBoardFromAsset(int indexOfBoard, int puzzleSize) {
    String fileName = 'assets/levels/bk_gen_board_4x4_15_i100';
    if (puzzleSize == 5) {
      fileName = 'assets/levels/bk_gen_board_5x5_20_i100';
    }
    if (puzzleSize == 6) {
      fileName = 'assets/levels/bk_gen_board_6x6_25_i100';
    }
    return rootBundle.loadString(fileName, cache: true)
        .then((rawString) {
          List<String> listOfBoards = rawString.split("BOARD_START");
          listOfBoards.removeAt(0); // first item is empty
          String rawStringOfBoard = listOfBoards[indexOfBoard];
          List<String> linesOfBoard = rawStringOfBoard.split("\n");
          linesOfBoard.removeWhere((element) => element.isEmpty);
          int ci = 4;
          // print(linesOfBoard);

          List<int> connections = [];
          for (int i = 0; i < puzzleSize; i++) {
            connections.addAll(linesOfBoard[ci + i].split(' ').map((s) => int.parse(s)));
          }
          ci += puzzleSize;
          ci++; // skip one line

          return RawPuzzleBoard(
            puzzleSize,
            connections,
            _readIntPairFromString(puzzleSize, linesOfBoard[ci]),
            _readIntPairFromString(puzzleSize, linesOfBoard[ci + 1]),
            _readIntPairFromString(puzzleSize, linesOfBoard[ci + 2]),
            _readIntPairFromString(puzzleSize, linesOfBoard[ci + 3]),
            linesOfBoard[1]
          );
    });
  }

  Pii _readIntPairFromString(int boardSize, String s) {
    List<int> listOfInt = s.split(' ').map((s) => int.parse(s)).toList();
    // slider's position is left-bottom based
    // layout is left-top based
    // so we need a transform
    return Pii(boardSize - 1 - listOfInt[0], listOfInt[1]);
  }

  List<PuzzleBoardSlot> _genPuzzleBoardSlots(RawPuzzleBoard puzzleBoard) {
    List<PuzzleBoardSlot> ret = [];
    for (var r = 0; r < puzzleBoard.puzzleSize; r++) {
      for (var c = 0; c < puzzleBoard.puzzleSize; c++) {
        ret.add(PuzzleBoardSlot(r, c, r * puzzleBoard.puzzleSize + c));
      }
    }

    for (var r = 0; r < puzzleBoard.puzzleSize; r++) {
      for (var c = 0; c < puzzleBoard.puzzleSize; c++) {
        var iCur = r * puzzleBoard.puzzleSize + c;
        var iLeft = r * puzzleBoard.puzzleSize + c - 1;
        var iTop = (r - 1) * puzzleBoard.puzzleSize + c;
        var isTopCon = puzzleBoard.connections[iCur] & 2 == 0;
        var isLeftCon = puzzleBoard.connections[iCur] & 1 == 0;
        if (c > 0 && isLeftCon) {
          ret[iLeft].rCon = ret[iCur];
          ret[iCur].lCon = ret[iLeft];
        }
        if (r > 0 && isTopCon) {
          ret[iTop].bCon = ret[iCur];
          ret[iCur].tCon = ret[iTop];
        }
      }
    }
    return ret;
  }

  bool _needReorderBySwipeDir(Pii p1, Pii p2, SwipeDir swipeDir) {
    bool needReverse = false;
    switch(swipeDir) {
      case SwipeDir.up:
        needReverse = p1.a > p2.a;
        break;
      case SwipeDir.down:
        needReverse = p1.a < p2.a;
        break;
      case SwipeDir.left:
        needReverse = p1.b > p2.b;
        break;
      case SwipeDir.right:
        needReverse = p1.b < p2.b;
        break;
      default:
        break;
    }
    return needReverse;
  }

  int _performSingleMove(int index, SwipeDir swipeDir, int indexOfSlider) {
    slots[index].occupied = false;
    // _test();
    int moveDist = 0;
    switch(swipeDir) {
      case SwipeDir.up:
        while (slots[index].tCon != null && !slots[index].tCon!.occupied) {
          index = slots[index].tCon!.index;
          moveDist++;
        }
        break;
      case SwipeDir.down:
        while (slots[index].bCon != null && !slots[index].bCon!.occupied) {
          index = slots[index].bCon!.index;
          moveDist++;
        }
        break;
      case SwipeDir.left:
        while (slots[index].lCon != null && !slots[index].lCon!.occupied) {
          index = slots[index].lCon!.index;
          moveDist++;
        }
        break;
      case SwipeDir.right:
        while (slots[index].rCon != null && !slots[index].rCon!.occupied) {
          index = slots[index].rCon!.index;
          moveDist++;
        }
        break;
      default:
        break;
    }
    slots[index].occupied = true;
    if (indexOfSlider == 1) {
      c1 = Pii(slots[index].r, slots[index].c);
    } else {
      c2 = Pii(slots[index].r, slots[index].c);
    }
    return moveDist;
  }
}
