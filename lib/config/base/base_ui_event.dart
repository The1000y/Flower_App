/// Base type for every one-shot UI event a cubit pushes to the widget layer.
///
/// Unlike the persistent state, a UI event is transient: it describes something that
/// just happened (a confirmation, a failure, a navigation request) and must be
/// consumed exactly once. Sending it on a dedicated stream instead of storing
/// it in the state keeps the state a pure description of "what is on screen
/// now", so events never replay on rebuild and the cubit stays free of any
/// `BuildContext` / `ScaffoldMessenger` dependency.
abstract class BaseUiEvent {
  const BaseUiEvent();
}
