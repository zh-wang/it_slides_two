import 'package:equatable/equatable.dart';

typedef Pii = Pair<int>;

class Pair<T> extends Equatable {
  final T a;
  final T b;

  const Pair(this.a, this.b);

  @override
  List<Object?> get props => [a, b];

  @override
  bool? get stringify => true;
}