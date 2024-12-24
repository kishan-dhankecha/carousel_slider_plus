library carousel_slider_plus;

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'carousel_controller.dart';
import 'carousel_options.dart';
import 'carousel_state.dart';
import 'helpers/conditional_parent.widget.dart';
import 'utils.dart';

export 'carousel_controller.dart';
export 'carousel_options.dart';

/// A function that creates a widget for a given index
/// This is useful for when you want to create the items on demand
typedef ExtendedIndexedWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  int realIndex,
);

/// A carousel slider widget.
///
/// This widget is useful when you have a bunch of widgets that you want
/// to display in a carousel. It can be used to display images, cards,
/// or any other widgets. It is similar to a ViewPager in Android. It is highly
/// customizable and flexible. You can control the carousel manually by using
/// the [CarouselSliderController] that is passed to the constructor.
class CarouselSlider extends StatefulWidget {
  /// [CarouselOptions] to create a [CarouselState] with
  final CarouselOptions options;

  /// Whether or not to disable touch gestures.
  /// If this is set to true, the carousel will not respond to any touch events
  /// and will not be able to be swiped or controlled by the user.
  /// This is useful for when you want to control the carousel manually.
  /// Defaults to false.
  final bool disableGesture;

  /// The list of widgets that will be used to create the carousel items.
  final List<Widget>? items;

  /// The builder that will be used to create the carousel items.
  /// This is useful for when you want to create the items on demand.
  /// This is required if you are using the builder constructor.
  /// The builder will be called with the context, the index of the item,
  /// and the real index of the item.
  /// The real index is the index of the item in the list of items
  /// and is useful for when you are using infinite scroll.
  final ExtendedIndexedWidgetBuilder? itemBuilder;

  /// The controller that can be used to control the carousel
  /// This can be used to change the current page or to start the autoplay.
  /// Defaults to a new instance of [CarouselSliderController].
  /// If you want to control the carousel manually,
  /// you can pass your own instance of
  /// [CarouselSliderController] to this constructor
  final CarouselSliderController carouselController;

  /// The number of items in the carousel
  /// This is required if you are using the builder constructor
  /// If you are using the list constructor, this will be set automatically
  final int itemCount;

  /// Creates a carousel slider widget with a list of items. The items will
  /// be created from the list of widgets that you pass to this constructor.
  CarouselSlider({
    super.key,
    required this.items,
    CarouselOptions? options,
    this.disableGesture = false,
    CarouselSliderController? controller,
  })  : this.options = options ?? CarouselOptions(),
        itemBuilder = null,
        itemCount = items?.length ?? 0,
        carouselController = controller ?? CarouselSliderController(),
        assert(items != null, 'items cannot be null');

  /// Creates a carousel slider widget with a builder. The items will be
  /// created using the builder that you pass to this constructor.
  /// This is useful for when you want to create the items on demand.
  CarouselSlider.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    CarouselOptions? options,
    this.disableGesture = false,
    CarouselSliderController? controller,
  })  : this.options = options ?? CarouselOptions(),
        items = null,
        carouselController = controller ?? CarouselSliderController(),
        assert(itemBuilder != null, 'itemBuilder cannot be null');

  @override
  _CarouselSliderState createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider>
    with TickerProviderStateMixin {
  Timer? timer;

  CarouselOptions get options => widget.options;

  late CarouselState state;

  /// mode is related to why the page is being changed
  CarouselPageChangedReason mode = CarouselPageChangedReason.controller;

  void changeMode(CarouselPageChangedReason _mode) {
    mode = _mode;
  }

  @override
  void didUpdateWidget(CarouselSlider oldWidget) {
    state.options = options;
    state.itemCount = widget.itemCount;

    // pageController needs to be re-initialized to respond to state changes
    state.pageController = PageController(
      viewportFraction: options.viewportFraction,
      initialPage: state.realPage,
    );

    // handle autoplay when state changes
    handleAutoPlay();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    state = CarouselState(
      this.options,
      clearTimer,
      resumeTimer,
      this.changeMode,
      widget.itemCount,
    );

    widget.carouselController.state = state;
    state.initialPage = widget.options.initialPage;
    state.realPage = options.enableInfiniteScroll
        ? state.realPage + state.initialPage
        : state.initialPage;
    handleAutoPlay();

    state.pageController = PageController(
      viewportFraction: options.viewportFraction,
      initialPage: state.realPage,
    );
  }

  Timer? getTimer() {
    if (!widget.options.autoPlay) return null;
    return Timer.periodic(widget.options.autoPlayInterval, (_) {
      if (!mounted) {
        clearTimer();
        return;
      }

      final route = ModalRoute.of(context);
      if (route?.isCurrent == false) return;

      CarouselPageChangedReason previousReason = mode;
      changeMode(CarouselPageChangedReason.timed);
      int nextPage = state.pageController.page!.round() + 1;

      if (nextPage >= widget.itemCount &&
          widget.options.enableInfiniteScroll == false) {
        if (widget.options.pauseAutoPlayInFiniteScroll) {
          clearTimer();
          return;
        }
        nextPage = 0;
      }

      final future = state.pageController.animateToPage(
        nextPage,
        duration: widget.options.autoPlayAnimationDuration,
        curve: widget.options.autoPlayCurve,
      );
      future.then((_) => changeMode(previousReason));
    });
  }

  void clearTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  void resumeTimer() {
    if (timer == null) {
      timer = getTimer();
    }
  }

  void handleAutoPlay() {
    bool autoPlayEnabled = widget.options.autoPlay;

    if (autoPlayEnabled && timer != null) return;

    clearTimer();
    if (autoPlayEnabled) {
      resumeTimer();
    }
  }

  Widget getGestureWrapper(Widget child) {
    Widget wrapper;
    if (widget.options.height != null) {
      wrapper = Container(
        height: widget.options.height,
        child: child,
      );
    } else {
      wrapper = AspectRatio(
        aspectRatio: widget.options.aspectRatio,
        child: child,
      );
    }

    return ConditionalParentWidget(
      isIncluded: !widget.disableGesture,
      child: NotificationListener(
        onNotification: (Notification notification) {
          if (notification is ScrollUpdateNotification) {
            widget.options.onScrolled?.call(state.pageController.page);
          }
          return false;
        },
        child: wrapper,
      ),
      parentBuilder: (Widget child) {
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => onPanDown(),
          onPointerUp: (_) => onPanUp(),
          onPointerCancel: (_) => onPanUp(),
          child: child,
        );
      },
    );
  }

  Widget getCenterWrapper(Widget child) {
    return ConditionalParentWidget(
      child: child,
      isIncluded: !widget.options.disableCenter,
      parentBuilder: (child) => Center(child: child),
    );
  }

  Widget getEnlargeWrapper(Widget? child,
      {double? width,
      double? height,
      double? scale,
      required double itemOffset}) {
    if (widget.options.enlargeStrategy == CenterPageEnlargeStrategy.height) {
      return SizedBox(child: child, width: width, height: height);
    }
    if (widget.options.enlargeStrategy == CenterPageEnlargeStrategy.zoom) {
      late Alignment alignment;
      final bool horizontal = options.scrollDirection == Axis.horizontal;
      if (itemOffset > 0) {
        alignment = horizontal ? Alignment.centerRight : Alignment.bottomCenter;
      } else {
        alignment = horizontal ? Alignment.centerLeft : Alignment.topCenter;
      }
      return Transform.scale(child: child, scale: scale!, alignment: alignment);
    }
    return Transform.scale(
      scale: scale!,
      child: Container(child: child, width: width, height: height),
    );
  }

  void onPanDown() {
    if (widget.options.pauseAutoPlayOnTouch) {
      clearTimer();
    }

    changeMode(CarouselPageChangedReason.manual);
  }

  void onPanUp() {
    if (widget.options.pauseAutoPlayOnTouch) {
      resumeTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    state.dispose();
    clearTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return SizedBox();
    return getGestureWrapper(PageView.builder(
      padEnds: widget.options.padEnds,
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        overscroll: false,
        dragDevices: {...PointerDeviceKind.values},
      ),
      clipBehavior: widget.options.clipBehavior,
      physics: widget.disableGesture
          ? NeverScrollableScrollPhysics()
          : widget.options.scrollPhysics,
      scrollDirection: widget.options.scrollDirection,
      pageSnapping: widget.options.pageSnapping,
      controller: state.pageController,
      reverse: widget.options.reverse,
      itemCount: widget.options.enableInfiniteScroll ? null : widget.itemCount,
      key: widget.options.pageViewKey,
      onPageChanged: (int index) {
        int currentPage = getRealIndex(
          index + state.initialPage,
          state.realPage,
          widget.itemCount,
        );
        widget.options.onPageChanged?.call(currentPage, mode);
      },
      itemBuilder: (BuildContext context, int idx) {
        final int index = getRealIndex(
          idx + state.initialPage,
          state.realPage,
          widget.itemCount,
        );

        return AnimatedBuilder(
          animation: state.pageController,
          child: widget.itemBuilder?.call(context, index, idx) ??
              widget.items![index],
          builder: (BuildContext context, child) {
            double distortionValue = 1.0;
            // if `enlargeCenterPage` is true, we must calculate the carousel item's height
            // to display the visual effect
            double itemOffset = 0;
            if (widget.options.enlargeCenterPage == true) {
              // pageController.page can only be accessed after the first build,
              // so in the first build we calculate the item offset manually
              var position = state.pageController.position;
              if (position.hasPixels && position.hasContentDimensions) {
                var _page = state.pageController.page;
                if (_page != null)
                  itemOffset =
                      widget.options.reverse ? idx - _page : _page - idx;
              } else {
                final storageCtx =
                    state.pageController.position.context.storageContext;
                final double previousSavedPosition = (PageStorage.of(storageCtx)
                        .readState(storageCtx) as double?) ??
                    state.realPage.toDouble();
                itemOffset = widget.options.reverse
                    ? idx - previousSavedPosition
                    : previousSavedPosition - idx;
              }

              final enlargeFactor = options.enlargeFactor.clamp(0.0, 1.0);
              final distortionRatio =
                  (1 - (itemOffset.abs() * enlargeFactor)).clamp(0.0, 1.0);
              distortionValue = Curves.easeOut.transform(distortionRatio);
            }

            final double height = widget.options.height ??
                MediaQuery.sizeOf(context).width *
                    (1 / widget.options.aspectRatio);

            if (widget.options.scrollDirection == Axis.horizontal) {
              return getCenterWrapper(
                getEnlargeWrapper(
                  child,
                  height: distortionValue * height,
                  scale: distortionValue,
                  itemOffset: itemOffset,
                ),
              );
            } else {
              return getCenterWrapper(
                getEnlargeWrapper(
                  child,
                  width: distortionValue * MediaQuery.sizeOf(context).width,
                  scale: distortionValue,
                  itemOffset: itemOffset,
                ),
              );
            }
          },
        );
      },
    ));
  }
}
