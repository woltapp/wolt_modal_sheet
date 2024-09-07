part of '../wolt_modal_sheet.dart';

class _NavigationSizeAdapter extends StatefulWidget {
  final WoltModalSheetCoordinator coordinator;

  const _NavigationSizeAdapter({
    super.key,
    required this.coordinator,
  });

  @override
  State<_NavigationSizeAdapter> createState() => _NavigationSizeAdapterState();
}

class _NavigationSizeAdapterState extends State<_NavigationSizeAdapter>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _sizeChangedNotifier;
  late final AnimationController _sizeAnimationController;
  late Animation<double> _heightAnimation;

  GlobalKey? _topPageKey;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _sizeChangedNotifier = ValueNotifier<double>(0);
    _sizeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = _createAnimation(0, 0);
    _sizeAnimationController.forward(from: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Subscribe on constraints changing.
    _actualizeConstraints(ConstraintsProvider.of(context).constraints);
  }

  @override
  void dispose() {
    _sizeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final constraints = ConstraintsProvider.of(context).constraints;

    return ConstrainedBox(
      constraints: constraints,
      child: ValueListenableBuilder<double>(
        valueListenable: _sizeChangedNotifier,
        builder: (context, height, child) => _AnimatedSizeWidget(
          heightAnimation: _heightAnimation,
          child: ClipRRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Builder(builder: (context) {
                    return ConstrainedBox(
                      constraints: ConstraintsProvider.of(context).constraints,
                      child: _NavigationStack(
                        changePagesNotifier: widget.coordinator.pagesPublisher,
                        onTopPageChanged: _onTopPageChanged,
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Animation<double> _createAnimation(double begin, double end) {
    return Tween<double>(begin: begin, end: end)
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
        .animate(_sizeAnimationController);
  }

  void _actualizeConstraints(BoxConstraints constraints) {
    if (!_isInitialized) {
      // postpone for the first call of _onTopPageChanged;
      return;
    }

    _updateSize(isAnimated: false);
  }

  void _onTopPageChanged(GlobalKey? topPageKey) {
    _topPageKey = topPageKey;

    if (!_isInitialized) {
      // first time handled;
      _isInitialized = true;
      _updateSize(isAnimated: false);
    } else {
      _updateSize(isAnimated: true);
    }
  }

  void _updateSize({bool isAnimated = true}) {
    final topPageKey = _topPageKey;

    if (topPageKey != null) {
      _waitForLayoutAndUpdateConstraints(topPageKey, isAnimated: isAnimated);
    } else {
      final currentHeight = _sizeChangedNotifier.value;
      final targetHeight =
          ConstraintsProvider.of(context).constraints.maxHeight;

      if (currentHeight == targetHeight) {
        return;
      }

      _sizeChangedNotifier.value = targetHeight;
      _heightAnimation = _createAnimation(currentHeight, targetHeight);
      _sizeAnimationController.forward(from: isAnimated ? 0 : 1);
    }
  }

  void _waitForLayoutAndUpdateConstraints(
    GlobalKey key, {
    bool isAnimated = true,
  }) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          final size = key.currentContext?.size;
          if (size != null) {
            final currentHeight = _sizeChangedNotifier.value;
            final targetHeight = size.height;
            final minHeight =
                ConstraintsProvider.of(context).constraints.minHeight;

            if (currentHeight == targetHeight) {
              return;
            }

            if (targetHeight < minHeight) {
              _sizeChangedNotifier.value = minHeight;
              _heightAnimation = _createAnimation(currentHeight, minHeight);
            } else {
              _sizeChangedNotifier.value = targetHeight;
              _heightAnimation = _createAnimation(currentHeight, targetHeight);
            }

            _sizeAnimationController.forward(from: isAnimated ? 0 : 1);
          }
        }
      },
    );
  }
}

class _AnimatedSizeWidget extends AnimatedWidget {
  final Widget child;
  final Animation<double> heightAnimation;

  const _AnimatedSizeWidget({
    Key? key,
    required this.child,
    required this.heightAnimation,
  }) : super(key: key, listenable: heightAnimation);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightAnimation.value,
      child: child,
    );
  }
}
