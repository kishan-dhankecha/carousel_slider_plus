# carousel_slider_plus

A carousel slider widget.

This package is fork of [carousel_slider](https://pub.dev/packages/carousel_slider) which is not maintained anymore.

[![pub package](https://img.shields.io/pub/v/carousel_slider_plus.svg)](https://pub.dev/packages/carousel_slider_plus)

[![likes](https://img.shields.io/pub/likes/carousel_slider_plus)](https://pub.dev/packages/carousel_slider_plus/score)
[![popularity](https://img.shields.io/pub/popularity/carousel_slider_plus)](https://pub.dev/packages/carousel_slider_plus/score)
[![pub points](https://img.shields.io/pub/points/carousel_slider_plus)](https://pub.dev/packages/carousel_slider_plus/score)

---

---

- [Features](#features)
- [Installation](#installation)
- [How to use](#how-to-use)
  - [Parameters](#parameters)
  - [Builder Constructors](#build-item-widgets-on-demand)
  - [Carousel Controller](#carousel-controller)

- [Live preview](#live-preview)
- [Migrating from carousel_slider](#migrating-from-carousel_slider)
- [Screenshots](#screenshots)

---

## Migrating from carousel_slider

In this fork some of the namings are changed. So follow this below guides to migrate over this new package.

#### 1. Instead of using `CarouselController`,  we now will use  `CarouselControllerPlus`. This change was necessary as flutter now has it's own `CarouselController` class as part of their material library.

#### Before

```dart
final CarouselController _controller = CarouselController();
```

#### After

 ```dart
final CarouselControllerPlus _controller = CarouselControllerPlus();
```

#### 2. The parameter name to pass controller in `CarouselSlider` is now changed to `controller` from `carouselController`.

#### Before

```dart
CarouselSlider(
  carouselController: _controller,
  // Rest of the code
),
```

#### After

```dart
CarouselSlider(
  controller: _controller,
  // Rest of the code
),
```

#### Please make sure to change the import statement also

#### Before

```dart
import "package:carousel_slider/carousel_slider.dart;
```

#### After

```dart
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
```

## Features 

* Infinite scroll 
* Custom child widgets
* Auto play

## Live preview
https://kishan-dhankecha.github.io/carousel-slider-plus-gh-pages/

Note: this page is built with flutter-web. For a better user experience, please use a mobile device to open this link.

## Installation

Add latest version of `carousel_slider_plus` to your `pubspec.yaml` dependencies. And import it:

```dart
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
```

## How to use

Simply create a `CarouselSlider` widget, and pass the required params:

```dart
CarouselSlider(
  options: CarouselOptions(height: 400.0),
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

### Parameters

```dart
CarouselSlider(
  items: items,
  options: CarouselOptions(
    height: 400,
    aspectRatio: 16/9,
    viewportFraction: 0.8,
    initialPage: 0,
    enableInfiniteScroll: true,
    reverse: false,
    autoPlay: true,
    autoPlayInterval: Duration(seconds: 3),
    autoPlayAnimationDuration: Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: true,
    enlargeFactor: 0.3,
    onPageChanged: callbackFunction,
    scrollDirection: Axis.horizontal,
  )
)
```

**If you pass the `height` parameter, the `aspectRatio` parameter will be ignored.**

### Build item widgets on demand

This method will save memory by building items once it becomes necessary. This way they won't be built if they're not currently meant to be visible on screen.
It can be used to build different child item widgets related to content or by item index.

```dart
CarouselSlider.builder(
  itemCount: 15,
  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
    return Container(
      child: Text(itemIndex.toString()),
    );
  }
)
```

### Carousel controller

In order to manually control the PageView's position, you can create your own `CarouselControllerPlus`, and pass it to `CarouselSlider`. Then you can use the `CarouselControllerPlus` instance to manipulate the position.

```dart 
class CarouselDemo extends StatelessWidget {
  CarouselControllerPlus buttonCarouselController = CarouselControllerPlus();

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      CarouselSlider(
        items: child,
        controller: buttonCarouselController,
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          aspectRatio: 2.0,
          initialPage: 2,
        ),
      ),
      RaisedButton(
        onPressed: () => buttonCarouselController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.linear),
        child: Text('→'),
      )
    ]
  );
}
```

#### `CarouselControllerPlus` methods

``` dart
/// Animate to the next page
controller.nextPage({Duration duration, Curve curve});


/// Animate to the previous page
controller.previousPage({Duration duration, Curve curve});


/// Jump to the given page.
controller.jumpToPage(int page);


/// Animate to the given page.
controller.animateToPage(int page, {Duration duration, Curve curve});


/// Start/Stop Auto-play (only work if `autoplay` is set to true in `CarouselOptions`)
controller.startAutoPlay();

```

## Screenshots

Basic text carousel slider:

![simple](screenshot/basic.gif)

Basic image carousel slider:

![image](screenshot/image.gif)

A more complicated image carousel slider:

![complicated image](screenshot/complicated-image.gif)

Full Screen image carousel slider:

![fullscreen](screenshot/fullscreen.gif)

Image carousel slider with custom indicator:

![indicator](screenshot/indicator.gif)

Manually control the page position:

![manual](screenshot/manually.gif)

Vertical carousel slider:

![vertical](screenshot/vertical.gif)

Simple on-demand image carousel slider, with image auto prefetch:

![prefetch](screenshot/preload.gif)

No infinite scroll:

![no-loop](screenshot/noloop.gif)

All screenshots above can be found at the example project.

## License

MIT
