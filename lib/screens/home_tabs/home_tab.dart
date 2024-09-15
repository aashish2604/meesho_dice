import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/utils/product_data.dart';
import 'package:meesho_dice/widgets/category_box.dart';
import 'package:meesho_dice/widgets/product_box.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 237, 252),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PolicyContainer(),
              CategorySection(),
              OfferCarousal(),
              const SizedBox(
                height: 6,
              ),
              ProductsForYouHeader(),
              const SizedBox(
                height: 6.0,
              ),
              ProductsForYouBody()
            ],
          ),
        ));
  }
}

class PolicyContainer extends StatelessWidget {
  const PolicyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: const Color.fromARGB(224, 242, 147, 255).withOpacity(0.3),
      padding: EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
        ),
        child: Row(
          children: [],
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CategoryBox(image: "image", title: "Electronics"),
          CategoryBox(image: "image", title: "Home Appliances"),
          CategoryBox(image: "image", title: "Clothing"),
          CategoryBox(image: "image", title: "Kids"),
          CategoryBox(image: "image", title: "Shoes"),
          CategoryBox(image: "image", title: "Sports"),
          CategoryBox(image: "image", title: "Clothing"),
          CategoryBox(image: "image", title: "Clothing"),
        ],
      ),
    );
  }
}

class OfferCarousal extends StatelessWidget {
  const OfferCarousal({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];

    return Container(
        color: Colors.white,
        height: 160,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 120,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            // autoPlay: false,
          ),
          items: imgList
              .map((item) => Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Center(
                        child: Image.network(
                      item,
                      fit: BoxFit.fill,
                    )),
                  ))
              .toList(),
        ));
  }
}

class ProductsForYouHeader extends StatelessWidget {
  const ProductsForYouHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth,
            height: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Products For You",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
            ),
          ),
          Container(
            width: screenWidth,
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class ProductsForYouBody extends StatelessWidget {
  const ProductsForYouBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 320,
            mainAxisSpacing: 1.4,
            crossAxisSpacing: 1.4),
        itemCount: productData.length,
        itemBuilder: (context, index) {
          return ProductBox(
            details: productData[index],
          );
        });
  }
}
