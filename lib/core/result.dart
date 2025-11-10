sealed class Result<T> {
  const Result();
  R when<R>({required R Function(T) ok, required R Function(Object, StackTrace?) err}) {
    final self = this;
    if (self is Ok<T>) return ok(self.value);
    if (self is Err<T>) return err(self.error, self.stackTrace);
    throw StateError('Unhandled Result state');
  }
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final Object error;
  final StackTrace? stackTrace;
  const Err(this.error, [this.stackTrace]);
}
