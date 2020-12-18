part of overlay_container;

class OverlayContainerController {
  /// Animation Controller
  AnimationController animationController;

  /// Store the state
  OverlayContainerState _state = OverlayContainerState.closed;

  /// Stream Controller for [overlayContainer]
  final StreamController<OverlayContainerState> _overlayContainerController = new StreamController<OverlayContainerState>.broadcast();
  /// Stream pipe for [_overlayContainerController]
  Stream<OverlayContainerState> get overlayContainerStream => _overlayContainerController.stream;
  /// Stream sink for [_overlayContainerController]
  StreamSink<OverlayContainerState> get _overlayContainerIn => _overlayContainerController.sink;
  
  /// Don't forget to dispose this controller
  void dispose() {
    _overlayContainerController?.close();
  }

  /// For change the overlay container's state
  _changeEvent(OverlayContainerState state) {
    _overlayContainerIn.add(state);
    _state = state;
  }

  /// Call [controller.open()] to open the overlay
  void open() {
    _changeEvent(OverlayContainerState.opened);
    print("OverlayController :: Open");
  }

  /// Call [controller.close()] to close the overlay
  void close() {
    _changeEvent(OverlayContainerState.closed);
    print("OverlayController :: Close");
  }

  /// Get current state, return [OverlayContainerState]
  OverlayContainerState getState() {
    return _state;
  }

  /// To get initial state on stream
  void initialGetState() {
    _overlayContainerIn.add(_state);
    animationController?.dispose();
  }
}

enum OverlayContainerState {
  opened,
  closed
}