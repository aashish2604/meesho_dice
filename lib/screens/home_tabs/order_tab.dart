import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/product_data.dart';
import 'package:meesho_dice/widgets/loading.dart';
import 'package:meesho_dice/widgets/product_box.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseServices.getUserId())
              .collection("orders")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LabeledLoadingWidget(
                    label: Text("Loading"), loaderColor: kMeeshoPurple),
              );
            }
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              return Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          horizontal:
                              BorderSide(color: Colors.black54, width: 1.0))),
                  child: YourOrdersBody(docs: docs));
            }
            return const Center(child: Text('No documents found'));
          }),
    );
  }
}

class YourOrdersBody extends StatelessWidget {
  final List<QueryDocumentSnapshot<Object?>> docs;
  const YourOrdersBody({super.key, required this.docs});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 320,
            mainAxisSpacing: 1.4,
            crossAxisSpacing: 1.4),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final data = docs[index].data() as Map<String, dynamic>;
          final productId = data["product_id"];
          final productDetails =
              productData.firstWhere((e) => e["id"] == productId);
          return ProductBox(
            details: productDetails,
          );
        });
  }
}
