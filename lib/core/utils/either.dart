abstract class Either<L, R> {
  const Either();

  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) => ifLeft(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) => ifRight(value);
}