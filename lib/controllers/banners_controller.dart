import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetchBannersUrls();
  }

  Future<void> fetchBannersUrls() async {
    try {
      QuerySnapshot bannersSnapshot =
      await FirebaseFirestore.instance.collection('banners').get();

      if (bannersSnapshot.docs.isNotEmpty) {
        List<String> newUrls = bannersSnapshot.docs
            .map((doc) => doc['imageUrl'] as String)
            .toList();

        for (String url in newUrls) {
          // Check if the URL already exists in the list
          if (!bannerUrls.contains(url)) {
            bannerUrls.add(url);
          }
        }
      }
    } catch (e) {
      print("error: $e");
    }
  }

}
