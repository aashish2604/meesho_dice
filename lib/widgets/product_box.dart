import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/services/general_functions.dart';
import 'package:meesho_dice/services/theme.dart';

class ProductBox extends StatelessWidget {
  final Map<String, dynamic> details;
  const ProductBox({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: CachedNetworkImage(
            imageUrl: details["images"][0],
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                details["title_name"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bodyTextStyle,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Text(
                    "₹ ${details["price"]}",
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    "${(details["price"] / (1 - 0.01 * details["discount"])).ceil()}",
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    "${details["discount"].toString()}% off",
                    style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                ],
              ),
              Text(
                "Free Delivery",
                style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7)),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Row(
                children: [
                  RatingBox(rating: details["rating"]),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    "(${GeneralFunctions().formatIndianNumber(details["no_of_feedbacks"].toString())})",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class RatingBox extends StatelessWidget {
  final double rating;
  const RatingBox({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: [
          Text(
            rating.toString(),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(
            width: 3.0,
          ),
          Icon(
            Icons.star,
            color: Colors.white,
            size: 11,
          )
        ],
      ),
    );
  }
}
