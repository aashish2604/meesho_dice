import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithIndicatorDemo extends StatefulWidget {
  final List<String> imageUrls;
  const CarouselWithIndicatorDemo({super.key, required this.imageUrls});

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  List<Widget> getImageSliders() {
    final List<Widget> imageSliders = widget.imageUrls
        .map((item) => Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Image.network(item, fit: BoxFit.fill)),
            ))
        .toList();
    return imageSliders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const SizedBox(
          height: 12.0,
        ),
        CarouselSlider(
          items: getImageSliders(),
          carouselController: _controller,
          options: CarouselOptions(
              // viewportFraction: 1,
              enlargeCenterPage: true,
              height: 400,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 5.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: (_current == entry.key
                        ? Colors.purple
                        : Colors.black12)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
