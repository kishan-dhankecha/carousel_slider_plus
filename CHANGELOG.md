# 7.0.3

## Fixes
- Page controller is now disposed when the widget is disposed

# 7.0.2

## Fixes
- spacing issue fixed when revered is true ([#7](https://github.com/kishan-dhankecha/carousel_slider_plus/issues/7)).

## Chores
- Some code cleanup in carousel_slider_plus.dart
- Migrating guide updated in README.md

# 7.0.1

## Fixes
- slider now can be operated with stylus ([#3](https://github.com/kishan-dhankecha/carousel_slider_plus/issues/3)).

## Chores
- Example project updated

# 7.0.0

## Breaking change
- `CarouselControllerPlus` renamed to `CarouselSliderController`
> This change was made due ti many developers had find this naming convention better over the last one and there were only few developers who have adapted to this package from original carousel_slider package at the time of this change. Due to release of 3.24 of flutter many more developers are willing to migrate to this package so it is best time to fix the naming convention before it is used widely.

## Chores
- Docs updated
- Example app code updated to reflect latest changes

# 6.0.0

## Breaking change
- `CarouselController` renamed to `CarouselControllerPlus`
> This change was necessary as flutter now has it's own `CarouselController` class as part of their material library
- `carouselController` named property of `CarouselSlider` renamed to `controller`

## Chores
- Docs updated
- Example app code updated to reflect latest changes
- Live web preview added via gh-pages

# 5.0.2

## Fixes
- Fixes serenader2014/flutter_carousel_slider#438


# 5.0.1

## Fixes
- `options` in `CarouselSlider` in no longer required
- macOS image not loading in release build issue fixed

## Chores
- Code formatting
- Example project updated
- Dependencies updated


# 4.2.1

## Fixes
- Temporary remove `PointerDeviceKind.trackpad`
- Fix `'double?'` type


# 4.2.0

## Adds
- `enlargeFactor` option
- `CenterPageEnlargeStrategy.zoom` option
- `animateToClosest` option

## Fixes
- Clear timer if widget was unmounted
- Scroll carousel using touchpad


# 4.1.1

## Fixes
- Code formatting


# 4.1.0

## Adds
- Exposed `clipBehavior` in `CarouselOptions`
- Exposed `padEnds` in `CarouselOptions`
- Add `copyWith` method to `CarouselOptions`

## Fixes
- Can't swipe on web with Flutter 2.5


# 4.0.0

## Adds
- Support null safety (Null safety isn't a breaking change and is Backward compatible meaning you can use it with non-null safe code too)
- Update example code to null safety and add Dark theme support and controller support to indicators in on of the examples and also fix overflow errors.


# 3.0.0

## Breaking change
- `itemBuilder` needs to accept three arguments, instead of two.

## Adds
- Add third argument in `itemBuilder`, allow Hero and infinite scroll to coexist


# 2.3.4

## Fixes
- Rollback PR #222, due to it will break the existing project.


# 2.3.3

## Chores
- Code formatting


# 2.3.2

## Adds
- Allow Hero and infinite scroll to coexist

## Fixes
- Double pointer down and up will cause a exception
- Fixed `CarouselPageChangedReason`


# 2.3.1

## Chores
- Code formatting


# 2.3.0

## Adds
- Added start/stop autoplay functionality
- Pause auto play if not current route
- Add `pageSnapping` option for disable page snapping for the carousel

## Fixes
- Fixed unresponsiveness to state changes


# 2.2.1

## Fixes
- Fixed `carousel_options.dart` and `carousel_controller` not being exported by default.


# 2.2.0

## Adds
- `disableCenter` option
> This option controls whether the carousel slider item should be wrapped in a `Center` widget or not.
-  `enlargeStrategy` option
> This option allow user to set which enlarge strategy to enlarge the center slide. Use `CenterPageEnlargeStrategy.height` if you want to improve the performance.

## Fixes
- Fixed `CarousePageChangedReason.manual` never being emitted


# 2.1.0

## Adds
- `pauseAutoPlayOnTouch` option
> This option controls whether the carousel slider should pause the auto play function when user is touching the slider
- `pauseAutoPlayOnManualNavigate` option
> This option controls whether the carousel slider should pause the auto play function when user is calling controller's method.
- `pauseAutoPlayInFiniteScroll` option
> This option decide the carousel should go to the first item when it reach the last item or not.
- `pageViewKey` option
> This option is useful when you want to keep the pageview's position when it was recreated.

## Fixes
- Fix `CarouselPageChangedReason` bug

## Chores
- Use `Transform.scale` instead of `SizedBox` to wrap the slider item


# 2.0.0

## Breaking change
Instead of passing all the options to the `CarouselSlider`, now you'll need to pass these option to `CarouselOptions`:
```dart
CarouselSlider(
  CarouselOptions(height: 400.0),
  items: [1,2,3,4,5].map((i) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.amber
          ),
          child: Text('text $i', style: TextStyle(fontSize: 16.0),)
        );
      },
    );
  }).toList(),
)
```

## Adds
- `CarouselController`
> Since `v2.0.0`, `carousel_slider_plus` plugin provides a way to pass your own `CaourselController`, and you can use `CaouselController` instance to manually control the carousel's position. For a more detailed example please refer to [example project](example/lib/main.dart).
- `CarouselPageChangedReason`
> Now you can receive a `CarouselPageChangedReason` in `onPageChanged` callback.

## Removes
- `pauseAutoPlayOnTouch`
> `pauseAutoPlayOnTouch` option is removed, because it doesn't fix the problem we have. Currently, when we enable the autoPlay feature, we can not stop sliding when the user interact with the carousel. This is a flutter's issue.


# 1.4.1

## Fixs
- Fixed `animateTo()/jumpTo()` with non-zero initialPage


# 1.4.0

## Adds
- Add on-demand item feature

## Fixes
- Fixed `setState() called after dispose()` bug


# 1.3.1

## Adds
- Scroll physics option

## Fixes
- onPage indexing bug


# 1.3.0

## Deprecations
- Remove the deprecated param: `interval`, `autoPlayDuration`, `distortion`, `updateCallback`. Please use the new param.

## Fixes
- Fix `enlargeCenterPage` option is not working in `vertical` carousel slider.


# 1.2.0

## Adds
- Vertical scroll support
- Enable/disable infinite scroll


# 1.1.0

## Adds
- Added `pauseAutoPlayOnTouch` option
- Add documentation


# 1.0.1

## Adds
- Update doc


# 1.0.0

## Adds
- Added `distortion` option


# 0.0.6

## Fixes
- Fix hard coded number


# 0.0.5

## Fixes
- Fix `initialPage` bug, fix crash when widget is disposed.


# 0.0.2

## Adds
- CHANGELOG

## Removes
- Remove useless dependencies


# 0.0.1
- Initial version.
