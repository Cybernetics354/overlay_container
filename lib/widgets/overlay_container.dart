part of overlay_container;

class OverlayContainerViewWidget extends StatefulWidget {
  final OverlayContainerController controller;
  final Widget content;
  final Duration duration;
  final Curve animationCurve;
  final OverlayAnimationDirection overlayAnimationDirection;
  final Widget child;
  final BoxDecoration decoration;
  final BuildContext context;
  OverlayContainerViewWidget({
    @required this.controller,
    @required this.content,
    @required this.duration,
    @required this.child,
    @required this.context,
    this.animationCurve = Curves.linearToEaseOut,
    this.overlayAnimationDirection = OverlayAnimationDirection.bottomToTop,
    this.decoration,
  });
  
  @override
  _OverlayContainerViewWidgetState createState() => _OverlayContainerViewWidgetState();
}

class _OverlayContainerViewWidgetState extends State<OverlayContainerViewWidget> with SingleTickerProviderStateMixin {
  Animation<double> sizeAnimation;
  Animation<double> scaleAnimation;
  StreamSubscription _eventSubscription;

  double _sizeDecision() {
    switch (widget.overlayAnimationDirection) {
      case OverlayAnimationDirection.bottomToTop:
      case OverlayAnimationDirection.topToBottom: {
        return MediaQuery.of(widget.context).size.height;
      }

      case OverlayAnimationDirection.leftToRight:
      case OverlayAnimationDirection.rightToLeft: {
        return MediaQuery.of(widget.context).size.width;
      }
        
      default: {
        return MediaQuery.of(widget.context).size.width;
      }
    }
  }

  _initialSetup() {
    widget.controller.animationController = new AnimationController(
      vsync: this,
      duration: widget.duration
    );

    widget.controller.animationController.addListener(() {
      setState(() {
        
      });
    });

    sizeAnimation = Tween<double>(begin: 0.0, end: _sizeDecision()).animate(CurvedAnimation(
      parent: widget.controller.animationController,
      curve: Interval(
        0.0, 1.0,
        curve: widget.animationCurve
      )
    ));

    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: widget.controller.animationController,
      curve: Interval(
        0.0, 1.0,
        curve: widget.animationCurve
      )
    ));

    _eventSubscription = widget.controller.overlayContainerStream.listen((event) {
      switch (event) {
        case OverlayContainerState.closed: {
          widget.controller.animationController.reverse();
          print("Overlay :: Closed");
          break;
        }

        case OverlayContainerState.opened: {
          widget.controller.animationController.forward();
          print("Overlay :: Open");
          break;
        }
          
        default: {
          throw "Unhandle Event";
        }
      }
    });
  }

  startSetup() async {
    await Future.delayed(Duration(seconds: 1));
    _initialSetup();
  }

  @override
  void initState() { 
    super.initState();
    startSetup();
  }

  @override
  void dispose() { 
    _eventSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: widget.content,
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  widget.controller.close();
                },
                child: overlayWidget(),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget overlayWidget() {
    Alignment _alignment;
    BoxDecoration _decoration;
    if(widget.decoration == null) {
      _decoration = BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Theme.of(widget.context).accentColor,
            Colors.transparent
          ]
        )
      );
    } else {
      _decoration = widget.decoration;
    }

    switch (widget.overlayAnimationDirection) {
      case OverlayAnimationDirection.bottomToTop: {
        _alignment = Alignment.bottomCenter;
        break;
      }

      case OverlayAnimationDirection.topToBottom: {
        _alignment = Alignment.topCenter;
        break;
      }

      case OverlayAnimationDirection.leftToRight: {
        _alignment = Alignment.centerLeft;
        break;
      }

      case OverlayAnimationDirection.rightToLeft: {
        _alignment = Alignment.centerRight;
        break;
      }
        
      default: {
        _alignment = Alignment.bottomCenter;
        break;
      }
    }

    switch (widget.overlayAnimationDirection) {
      case OverlayAnimationDirection.bottomToTop:
      case OverlayAnimationDirection.topToBottom: {
        return Center(
          child: Align(
            alignment: _alignment,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: sizeAnimation == null ? 0.0 : sizeAnimation.value,
              decoration: _decoration,
              child: Align(
                alignment: _alignment,
                child: Transform.scale(
                  scale: scaleAnimation == null ? 0 : scaleAnimation.value,
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      }

      case OverlayAnimationDirection.leftToRight:
      case OverlayAnimationDirection.rightToLeft: {
        return Center(
          child: Align(
            alignment: _alignment,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: sizeAnimation == null ? 0.0 : sizeAnimation.value,
              decoration: _decoration,
              child: Align(
                alignment: _alignment,
                child: Transform.scale(
                  scale: scaleAnimation == null ? 0 : scaleAnimation.value,
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      }
        
      default: {
        return SizedBox();
      }
    }
  }
}

enum OverlayAnimationDirection {
  bottomToTop,
  topToBottom,
  leftToRight,
  rightToLeft
}