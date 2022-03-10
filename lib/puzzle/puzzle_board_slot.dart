
import 'package:equatable/equatable.dart';

class PuzzleBoardSlot extends Equatable {
  final int r;
  final int c;
  final int index;
  PuzzleBoardSlot? tCon;
  PuzzleBoardSlot? bCon;
  PuzzleBoardSlot? lCon;
  PuzzleBoardSlot? rCon;
  bool occupied;

  PuzzleBoardSlot(this.r, this.c, this.index, {
    this.occupied = false
  });

  @override
  List<Object?> get props => [r, c, index, occupied];

  @override
  bool? get stringify => true;
}