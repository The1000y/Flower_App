import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

/// `bloc_test`'s `whenListen` helper is implemented on top of mocktail, so it
/// cannot drive a Mockito cubit mock. This wires the `stream` and `state`
/// getters of such a mock to a broadcast [StreamController] that the test can
/// push further states into, giving the same behaviour as `whenListen`.
class CubitStreamStub<S, C extends Cubit<S>> {
  CubitStreamStub(this.cubit, S initialState)
    : controller = StreamController<S>.broadcast() {
    when(cubit.stream).thenAnswer((_) => controller.stream);
    when(cubit.state).thenReturn(initialState);
  }

  final C cubit;
  final StreamController<S> controller;

  /// Makes [state] the current state and notifies every `BlocBuilder`.
  void emit(S state) {
    when(cubit.state).thenReturn(state);
    controller.add(state);
  }

  Future<void> close() => controller.close();
}
