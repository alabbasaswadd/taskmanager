// =======================================================
// base_state.dart
// =======================================================
abstract class BaseState {
  const BaseState();
}

class InitialState extends BaseState {
  const InitialState();
}

class LoadingState extends BaseState {
  const LoadingState();
}

class SuccessState<T> extends BaseState {
  final T data;
  const SuccessState(this.data);
}

class ErrorState extends BaseState {
  final String message;
  const ErrorState(this.message);
}
