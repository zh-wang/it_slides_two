import 'package:it_slides_two/utils/pair.dart';

class RawPuzzleBoard {
  final int puzzleSize;
  final List<int> connections;
  final Pii s1; // initial position of slider 1
  final Pii t1; // terminal position of slider 1
  final Pii s2; // initial position of slider 2
  final Pii t2; // terminal position of slider 2
  final String id;

  const RawPuzzleBoard([
    this.puzzleSize = 0,
    this.connections = const [],
    this.s1 = const Pii(0, 0),
    this.t1 = const Pii(0, 0),
    this.s2 = const Pii(0, 0),
    this.t2 = const Pii(0, 0),
    this.id = ""
  ]);

  @override
  String toString() {
    return 'PuzzleBoard{puzzleSize: $puzzleSize, connections: $connections, s1: $s1, t1: $t1, s2: $s2, t2: $t2, id: $id}';
  }

  int getIndexByRowCol(Pii p) {
    return p.a * puzzleSize + p.b;
  }
}