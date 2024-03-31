import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Added for Material design widgets
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import 'package:online_shopping/models/categories_model.dart';
import 'package:online_shopping/screens/user-panel/single_category_products_screen.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key}); // Corrected the syntax for key parameter

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('categories').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 5,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No category found!"),
          );
        }

        if (snapshot.data != null) {
          return Container(
            height: Get.height / 5.0,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: snapshot.data!.docs[index]['categoryId'],
                  categoryImg: snapshot.data!.docs[index]['categoryImg'],
                  categoryName: snapshot.data!.docs[index]['categoryName'],
                  createdAt: snapshot.data!.docs[index]['createdAt'],
                  updatedAt: snapshot.data!.docs[index]['updatedAt'],
                );
                return GestureDetector(
                  onTap: () => Get.to(() => AllSingleCategoryProductsScreen(
                      categoryId: categoriesModel.categoryId)),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Container(
                      width: Get.width / 4.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: Get.width / 4.0,
                            height: Get.height / 12,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)), // Use Radius.circular to specify border radius
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  categoriesModel.categoryImg as String, // Cast to String
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(height: 5.0),
                          Text(
                            categoriesModel.categoryName,
                            style: TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
