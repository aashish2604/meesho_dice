import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/product_details.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/product_data.dart';
import 'package:meesho_dice/widgets/category_box.dart';
import 'package:meesho_dice/widgets/loading.dart';
import 'package:meesho_dice/widgets/product_box.dart';
import 'package:meesho_dice/widgets/timer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          PolicyContainer(),
          PersonalizedProducts(),
          OfferCarousal(),
          const SizedBox(
            height: 6.0,
          ),
          CategorySection(),
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
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/policy_banner.jpg"))),
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
        children: const [
          CategoryBox(
            image:
                "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Fmodern-stationary-collection-arrangement.jpg?alt=media&token=223d4f98-2c0c-469d-8435-a93acb59dcbc",
            title: "Electronics",
            category: "electronics",
          ),
          CategoryBox(
            image:
                "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Fcontemporary-living-room-interior-design-with-white-sofa.jpg?alt=media&token=1881a683-6cc7-4dda-ab36-0ecaf7fa877a",
            title: "Home",
            category: "home",
          ),
          CategoryBox(
            image:
                "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Ffast-fashion-concept-with-full-clothing-store.jpg?alt=media&token=754de242-9659-4236-b655-316e5066c072",
            title: "Clothing",
            category: "cloths",
          ),
          CategoryBox(
            image:
                "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Fkids-home-playing-with-toys.jpg?alt=media&token=5684e24d-ace4-433f-b549-07e8b2cc7114",
            title: "Kids",
            category: "kids",
          ),
          CategoryBox(
            image:
                "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Ffootball-background-grass-with-shoes.jpg?alt=media&token=28711fd4-0420-42f2-b1be-8ad80d3e13d3",
            title: "Shoes",
            category: "shoes",
          ),
          CategoryBox(
            image:
                "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2F37207.jpg?alt=media&token=a383080c-4f2b-45d7-b42b-c891e3eed626",
            title: "Sports",
            category: "sports",
          )
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
      'https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2FScreenshot%20(288).png?alt=media&token=0b547b7b-b260-41b0-8967-abe8e71ba4b2',
      'https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2FScreenshot%20(285).png?alt=media&token=6e8ce13c-b5c3-4fb3-8c18-92bc4f81ac78'
    ];

    return Container(
        color: Colors.white,
        height: 160,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 140,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            // autoPlay: false,
          ),
          items: imgList
              .map((item) => GestureDetector(
                    onTap: () {
                      launchUrl(
                          Uri.parse(
                              "https://webviews.meesho.com/pages/static/mega-blockbuster-sale0-1"),
                          mode: LaunchMode.inAppWebView);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(item)),
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
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
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
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

class PersonalizedProducts extends StatelessWidget {
  const PersonalizedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseServices.getUserId())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data!.data();
            final personalizedOffers =
                documents!["personalized_offers"] as List;
            return personalizedOffers.isNotEmpty
                ? Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Offers just for you",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 14.0,
                              ),
                              TimerBox(
                                  endTime:
                                      DateTime.now().add(Duration(hours: 3)))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: personalizedOffers.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> details =
                                    productData.firstWhere((e) =>
                                        e["id"] == personalizedOffers[index]);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    details: details)));
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 130,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            details["images"]
                                                                [0]))),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2.0,
                                        ),
                                        Text(
                                          details["title_name"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        });
  }
}

class PersonalizedProductBox extends StatelessWidget {
  final Map<String, dynamic> details;
  const PersonalizedProductBox({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetails(details: details)));
      },
      child: Container(
        height: 120,
        width: 100,
        child: Column(
          children: [
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(details["images"][0]))),
            ),
            const SizedBox(
              height: 6.0,
            ),
            Text(
              details["title_name"],
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
