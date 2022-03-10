import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_slides_two/audio_control/audio_control.dart';
import 'package:it_slides_two/keyboard_handler.dart';
import 'package:it_slides_two/layout/layout.dart';
import 'package:it_slides_two/timer/bloc/timer_bloc.dart';
import 'package:it_slides_two/gamelogic/bloc/gamelogic_bloc.dart';

import '../models/models.dart';
import '../utils/utils.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TimerBloc(ticker: const Ticker())),
        BlocProvider(create: (_) => GameLogicBloc()),
        BlocProvider(create: (_) => AudioControlBloc())
      ],
      child: const PuzzleAnimateSwitcher(),
    );
  }
}

class PuzzleAnimateSwitcher extends StatelessWidget {
  const PuzzleAnimateSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardId = context.select((GameLogicBloc bloc) => bloc.state.boardId);
    return StatefulWrapper(
        onInit: () => context.read<GameLogicBloc>().add(const GameLogicEventInit()),
        child: PuzzleView(key: Key(boardId))
    );
  }
}

class GuideView extends StatelessWidget {
  const GuideView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = context.select((GameLogicBloc bloc) => bloc.state.gameState);
    final isFirstTime = context.select((GameLogicBloc bloc) => bloc.state.isFirstTime);
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
        top: isFirstTime ? 0 : height,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            color: Color(0x44121212)
        ),
        child: Center(
          child: Container(
              width: 300,
              height: 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: const Color(0xEEFFFFFF)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("1. Use swipe or arrow keys to move both sliders.\n\n"
                      "2. Move both sliders to target slots to win.",
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  const SizedBox(height: 16,),
                  WidgetHelper.normalBtn(() {
                    context.read<AudioControlBloc>().add(AudioControlPlayClickSE(gameState));
                    context.read<GameLogicBloc>().add(const GameLogicEventUpdateIsFirstTime(false));
                  }, "Got it",
                      bgColor: theme.primaryColor,
                      textColor: Colors.black),
          ],
              )
          ),
        ),
      )
    );
  }
}

class WinView extends StatelessWidget {
  const WinView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = context.select((GameLogicBloc bloc) => bloc.state.gameState);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (gameState == GameState.win) {
      context.read<AudioControlBloc>().add(const AudioControlPlayWinSE());
    }
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
        top: gameState == GameState.win ? 0 : height,
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
              color: Color(0x44121212)
          ),
          child: Center(
            child: Container(
              width: 400,
              height: 500,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: const Color(0xEEFFFFFF)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.asset(AppAssets.getAssetsImgPath("congra.png"))
                  ),
                  const SizedBox(height: 64),
                  const BottomBar()
                ],
              ),
            ),
          ),
        )
    );
  }
}

class PuzzleViewBackground extends StatelessWidget {
  const PuzzleViewBackground({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final indexOfTheme = context.select((GameLogicBloc bloc) => bloc.state.indexOfTheme);
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: Container(
        key: ValueKey(indexOfTheme),
        decoration: BoxDecoration(
            color: theme.bg
        ),
      ),
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    final indexOfTheme = context.select((GameLogicBloc bloc) => bloc.state.indexOfTheme);
    final themeImgName = indexOfTheme == 0
        ? "cloth_dark.png" : "cloth_light.png";
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const SizedBox(width: 16,),
        Text("It Slides Two",
            style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 28
            )
        ),
        const SizedBox(width: 16,),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(AppAssets.getAssetsImgPath(themeImgName)),
              ),
              onTap: () => context.read<GameLogicBloc>()
                  .add(const GameLogicEventUpdateTheme()),
            ),
          )
        )
      ]
    );
  }
}

class BoardSizePicker extends StatelessWidget {
  const BoardSizePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int puzzleSize = context.select((GameLogicBloc bloc) => bloc.state.puzzleSize);
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Size: ",
            style: TextStyle(
                color: theme.textColor,
                fontSize: 24
            )
        ),
        CustomRadioListTile<int>(
          selectedColor: theme.primaryColor,
          value: 4,
          groupValue: puzzleSize,
          leading: '4',
          onChanged: (value) => context.read<GameLogicBloc>()
              .add(GameLogicEventUpdatePuzzleSize(value)),
        ),
        CustomRadioListTile<int>(
          selectedColor: theme.primaryColor,
          value: 5,
          groupValue: puzzleSize,
          leading: '5',
          onChanged: (value) => context.read<GameLogicBloc>()
              .add(GameLogicEventUpdatePuzzleSize(value)),
        ),
        CustomRadioListTile<int>(
          selectedColor: theme.primaryColor,
          value: 6,
          groupValue: puzzleSize,
          leading: '6',
          onChanged: (value) => context.read<GameLogicBloc>()
              .add(GameLogicEventUpdatePuzzleSize(value)),
        ),
    ],
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moves = context.select((GameLogicBloc bloc) => bloc.state.moves);
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedRotation(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
          turns: 0.25 * moves,
          child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: theme.slider1,
                  borderRadius: BorderRadius.circular(4)
              )
          ),
        ),
        const SizedBox(width: 16,),
        Text("$moves Moves",
            style: TextStyle(
                color: theme.textColor,
                fontSize: 24
            )
        ),
        const SizedBox(width: 16,),
        AnimatedRotation(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuad,
          turns: -0.25 * moves,
          child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: theme.slider2,
                  borderRadius: BorderRadius.circular(4)
              )
          ),
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = context.select((GameLogicBloc bloc) => bloc.state.gameState);
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WidgetHelper.normalBtn(() {
          context.read<GameLogicBloc>().add(const GameLogicEventRestart());
          context.read<AudioControlBloc>().add(AudioControlPlayClickSE(gameState));
        }, "Restart",
            bgColor: theme.primaryColor,
            textColor: Colors.black),
        const SizedBox(width: 32,),
        WidgetHelper.normalBtn(() {
          context.read<GameLogicBloc>().add(const GameLogicEventInit());
          context.read<AudioControlBloc>().add(AudioControlPlayClickSE(gameState));
        }, "Try Another",
            bgColor: theme.primaryColor,
            textColor: Colors.black)
      ],
    );
  }
}

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key}) : super(key: key);

  Widget _makeWidget(BuildContext context, int sizeIndex) {
    final gameState = context.select((GameLogicBloc bloc) => bloc.state.gameState);
    Widget puzzleWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleBar(),
          const SizedBox(height: 24),
          const BoardSizePicker(),
          const SizedBox(height: 24),
          const TopBar(),
          const SizedBox(height: 16),
          ConstrainedBox(
            // TODO: responsive size
            constraints: BoxConstraints.tight(const Size(400, 400)),
            child: const Center(
              child: SquarePuzzleBoard(),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedOpacity(
              opacity: gameState == GameState.win ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: const BottomBar(),
          )
        ]
    );
    return Stack(
      children: [
        puzzleWidget,
        const WinView(),
        const GuideView(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.select((GameLogicBloc bloc) => bloc.state.gameState);
    return PuzzleKeyboardHandler(
      child: Scaffold(
        body: GestureDetector(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const PuzzleViewBackground(),
              ResponsiveLayoutBuilder(
                  small: (context, widget) => _makeWidget(context, 1),
                  medium: (context, widget) => _makeWidget(context, 2),
                  large: (context, widget) => _makeWidget(context, 3)
              )
            ],
          ),
          onVerticalDragEnd: (detail) {
            if (detail.velocity.pixelsPerSecond.dy > 0) {
              context.read<GameLogicBloc>().add(const GameLogicEventSwipe(SwipeDir.down));
              context.read<AudioControlBloc>().add(AudioControlPlaySlideSE(gameState));
            } else if (detail.velocity.pixelsPerSecond.dy < 0) {
              context.read<GameLogicBloc>().add(const GameLogicEventSwipe(SwipeDir.up));
              context.read<AudioControlBloc>().add(AudioControlPlaySlideSE(gameState));
            }
          },
          onHorizontalDragEnd: (detail) {
            if (detail.velocity.pixelsPerSecond.dx > 0) {
              context.read<GameLogicBloc>().add(const GameLogicEventSwipe(SwipeDir.right));
              context.read<AudioControlBloc>().add(AudioControlPlaySlideSE(gameState));
            } else if (detail.velocity.pixelsPerSecond.dx < 0) {
              context.read<GameLogicBloc>().add(const GameLogicEventSwipe(SwipeDir.left));
              context.read<AudioControlBloc>().add(AudioControlPlaySlideSE(gameState));
            }
          },
        ),
      ),
    );
  }
}

class SquarePuzzleBoard extends StatelessWidget {
  const SquarePuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameLogicBloc, GameLogicState>(
        buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
        builder: (context, state) {
          final puzzleSize = context.select((GameLogicBloc bloc) => bloc.state.puzzleSize);
          final puzzleBoard = context.select((GameLogicBloc bloc) => bloc.state.board);
          final pos01 = context.select((GameLogicBloc bloc) => bloc.state.pos01);
          final pos02 = context.select((GameLogicBloc bloc) => bloc.state.pos02);
          final moveDist01 = context.select((GameLogicBloc bloc) => bloc.state.moveDist01);
          final moveDist02 = context.select((GameLogicBloc bloc) => bloc.state.moveDist02);
          if (puzzleSize == 0) {
            return const Text("Loading...",
                style: TextStyle(
                    fontSize: 24
                )
            );
          } else {
            return AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                  margin: const EdgeInsets.all(20),
                  child: LayoutBuilder(
                      builder: (BuildContext context,
                          BoxConstraints constraints) {
                        final w = constraints.maxWidth / puzzleSize;
                        final h = constraints.maxHeight / puzzleSize;
                        return Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              WallGroup(w: w, h: h),
                              Target(
                                r: puzzleBoard.t1.a,
                                c: puzzleBoard.t1.b,
                                w: w,
                                h: h,
                                indexOfTarget: 0,),
                              Target(
                                r: puzzleBoard.t2.a,
                                c: puzzleBoard.t2.b,
                                w: w,
                                h: h,
                                indexOfTarget: 1,),
                              Slider(
                                r: pos01.a,
                                c: pos01.b,
                                w: w,
                                h: h,
                                indexOfSlider: 0,
                                moveDist: moveDist01,),
                              Slider(
                                r: pos02.a,
                                c: pos02.b,
                                w: w,
                                h: h,
                                indexOfSlider: 1,
                                moveDist: moveDist02,),
                            ]);
                      }
                  )
              ),
            );
          }
        });
  }
}

const double sliderMargin = 10;

class Target extends StatelessWidget {
  const Target({
    Key? key,
    required this.r,
    required this.c,
    required this.w,
    required this.h,
    required this.indexOfTarget
  }) : super(key: key);

  final int r;
  final int c;
  final double w;
  final double h;
  final int indexOfTarget;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    return Positioned(
      left: c * w,
      top: r * h,
      width: w,
      height: h,
      child: Container(
        margin: const EdgeInsets.all(sliderMargin),
        decoration: BoxDecoration(
            border: Border.all(
                color: indexOfTarget == 0 ? theme.target1 : theme.target2,
                width: 4),
            borderRadius: BorderRadius.circular(sliderMargin)
        ),
        width: w,
        height: h,
      ),
    );
  }
}

class Slider extends StatelessWidget {
  const Slider({
    Key? key,
    required this.r,
    required this.c,
    required this.w,
    required this.h,
    required this.indexOfSlider,
    required this.moveDist
  }) : super(key: key);

  final int r;
  final int c;
  final double w;
  final double h;
  final int indexOfSlider;
  final int moveDist;

  @override
  Widget build(BuildContext context) {
    context.select((GameLogicBloc bloc) => bloc.state.numOfActions); // Need this to update UI
    final lastSwipeDir = context.select((GameLogicBloc bloc) => bloc.state.lastSwipeDir);
    final moveDist = indexOfSlider == 0
        ? context.select((GameLogicBloc bloc) => bloc.state.moveDist01)
        : context.select((GameLogicBloc bloc) => bloc.state.moveDist02);
    if (moveDist == 0) {
      context.read<GameLogicBloc>()
          .add(GameLogicEventMoveEnded(indexOfSlider));
    }
    return AnimatedPositioned(
        duration: Duration(milliseconds: (moveDist > 0 ? moveDist : 0) * 100),
        curve: Curves.easeOutQuad,
        left: c * w,
        top: r * h,
        width: w,
        height: h,
        onEnd: () {
          context.read<GameLogicBloc>()
              .add(GameLogicEventMoveEnded(indexOfSlider));
        },
        child: SliderInnerContainer(
            w: w,
            h: h,
            indexOfSlider: indexOfSlider,
            swipeDir: lastSwipeDir,
            moveDist: moveDist,
            key: UniqueKey()
        )
    );
  }
}

class SliderInnerContainer extends StatefulWidget {
  static const routeName = 'SliderInnerContainer';

  final int indexOfSlider;
  final double w;
  final double h;
  final SwipeDir swipeDir;
  final int moveDist;

  const SliderInnerContainer({
    Key? key,
    required this.w,
    required this.h,
    required this.indexOfSlider,
    required this.swipeDir,
    required this.moveDist
  }) : super(key: key);

  @override
  _SliderInnerContainerState createState() =>
      _SliderInnerContainerState();
}

class _SliderInnerContainerState extends State<SliderInnerContainer>
    with SingleTickerProviderStateMixin {

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );

  final double offset = 4;
  RelativeRect? endRect = const RelativeRect.fromLTRB(0, 0, 0, 0);

  @override
  void initState() {
    super.initState();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
        // context.read<GameLogicBloc>()
        //     .add(GameLogicEventMoveEnded(widget.indexOfSlider));
      }
    });
    if (widget.moveDist == 0) {
      switch(widget.swipeDir) {
        case SwipeDir.up:
          endRect = RelativeRect.fromLTRB(0, -offset, 0, offset);
          break;
        case SwipeDir.down:
          endRect = RelativeRect.fromLTRB(0, offset, 0, -offset);
          break;
        case SwipeDir.left:
          endRect = RelativeRect.fromLTRB(-offset, 0, offset, 0);
          break;
        case SwipeDir.right:
          endRect = RelativeRect.fromLTRB(offset, 0, -offset, 0);
          break;
        default:
          break;
      }
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double turns = 0;
    switch(widget.swipeDir) {
      case SwipeDir.right:
        turns = 0.75;
        break;
      case SwipeDir.up:
        turns = 0.5;
        break;
      case SwipeDir.left:
        turns = 0.25;
        break;
      default:
        break;
    }
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    final gameState = context.select((GameLogicBloc bloc) => bloc.state.gameState);
    final imageName = gameState == GameState.win ? "circle.png" : "bk_arrow_down.png";
    final isIconVisible = widget.swipeDir == SwipeDir.none;
    return Stack(
        children: [
          PositionedTransition(
            rect: _animationController.drive(
              CurveTween(
                curve: Curves.easeInOut,
              ),
            ).drive(
              RelativeRectTween(
                begin: const RelativeRect.fromLTRB(0, 0, 0, 0),
                end: endRect,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(sliderMargin),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: widget.indexOfSlider == 0 ? theme.slider1 : theme.slider2,
                  borderRadius: BorderRadius.circular(sliderMargin)
              ),
              width: widget.w,
              height: widget.h,
              child: AnimatedRotation(
                turns: turns,
                duration: const Duration(milliseconds: 100),
                child: Image.asset(AppAssets.getAssetsImgPath(imageName)),
              ),
            ),
          ),
        ]
    );
  }
}

class WallGroup extends StatelessWidget {
  const WallGroup({
    Key? key,
    required this.w,
    required this.h,
  }) : super(key: key);

  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    final lenOfEdge = context.select((GameLogicBloc bloc) => bloc.state.puzzleSize);
    final puzzleBoard = context.select((GameLogicBloc bloc) => bloc.state.board);
    List<Wall> listOfWalls = [];
    for (int r = 0; r < lenOfEdge; r++) {
      for (int c = 0; c < lenOfEdge; c++) {
        if (r == 0) {
          listOfWalls.add(Wall(r: r, c: c, w: w, h: h,
            isLeft: false, isOutMost: true,));
        }
        if (c == 0) {
          listOfWalls.add(Wall(r: r, c: c, w: w, h: h,
            isLeft: true, isOutMost: true,));
        }
        int v = puzzleBoard.connections[r * lenOfEdge + c];
        if ((v & 1) > 0) {
          listOfWalls.add(Wall(r: r, c: c, w: w, h: h,
            isLeft: true, isOutMost: false,));
        }
        if ((v & 2) > 0) {
          listOfWalls.add(Wall(r: r, c: c, w: w, h: h,
            isLeft: false, isOutMost: false,));
        }
        if (r == lenOfEdge - 1) {
          listOfWalls.add(Wall(r: r + 1, c: c, w: w, h: h,
            isLeft: false, isOutMost: true,));
        }
        if (c == lenOfEdge - 1) {
          listOfWalls.add(Wall(r: r, c: c + 1, w: w, h: h,
            isLeft: true, isOutMost: true,));
        }
      }
    }
    return Stack(
        clipBehavior: Clip.none,
        children: listOfWalls
    );
  }
}

class Wall extends StatelessWidget {
  const Wall({
    Key? key,
    required this.r,
    required this.c,
    required this.w,
    required this.h,
    required this.isLeft,
    required this.isOutMost
  }) : super(key: key);

  final int r;
  final int c;
  final double w;
  final double h;
  final bool isLeft;
  final bool isOutMost;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((GameLogicBloc bloc) => bloc.state.theme);
    double wallThicknessInHalf = 2;
    return Positioned(
      left: c * w - wallThicknessInHalf,
      top: r * h - wallThicknessInHalf,
      width: isLeft ? wallThicknessInHalf * 2 : w + wallThicknessInHalf * 2,
      height: isLeft ? h + wallThicknessInHalf * 2 : wallThicknessInHalf * 2,
      child: Container(
        decoration: BoxDecoration(
          color: theme.wall,
        ),
        width: w,
        height: h,
      ),
    );
  }
}