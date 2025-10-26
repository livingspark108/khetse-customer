import 'package:get/get.dart';
import 'package:user/models/businessLayer/apiHelper.dart';
import 'package:user/models/orderModel.dart';

class OrderController extends GetxController {
  APIHelper apiHelper = new APIHelper();
  List<Order> completedOrderList = [];
  List<Order>? activeOrderList = [];
  var isCompletedOrderHistoryListLoaded = false.obs;
  var isActiveOrderListLoaded = false.obs;
  var isDataLoaded2 = false.obs;
  var isDeleted = false.obs;

  var page = 1.obs;

  var isMoreDataLoaded = false.obs;
  var isRecordPending = true.obs;

  var page1 = 1.obs;
 
  var isMoreDataLoaded1 = false.obs;
  var isRecordPending1 = true.obs;

  deleteOrder(String? cartId, String? cancelReason) async {
    try {
      isDataLoaded2.value = false;
      final result = await apiHelper.deleteOrder(cartId, cancelReason);

      if (result != null) {
        if (result.status == "1") {
          isDeleted.value = true;
          Get.snackbar(
            "Order Cancelled.",
            "",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          isDeleted.value = false;
          Get.snackbar(
            "Order Cancellation Failed.",
            "",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }

      isDataLoaded2.value = true;
      update();
    } catch (e) {
      print("Exception -  order_controller.dart - deleteOrder():" + e.toString());
    }
  }

  getActiveOrderList() async {
    try {
      isActiveOrderListLoaded.value = false;

      // Reset for fresh load
      if (activeOrderList == null || activeOrderList!.isEmpty) {
        page1.value = 1;
      } else {
        page1.value++;
      }

      isMoreDataLoaded1.value = true;

      /// 🟢 1. Get normal active orders
      final normalResult = await apiHelper.getActiveOrders(page1.value);

      /// 🟢 2. Get photo orders
      final photoResult = await apiHelper.getActiveOrdersphoto(page1.value);

      List<Order> tempList = [];

      /// Merge both results
      if (normalResult != null && normalResult.status == "1") {
        tempList.addAll(normalResult.data);
      }

      if (photoResult != null && photoResult.status == "1") {
        tempList.addAll(photoResult.data);
      }

      if (tempList.isEmpty) {
        isRecordPending1.value = false;
      }

      /// 🟢 Sort by date (latest first)
      tempList.sort((a, b) {
        DateTime dateA = _safeDate(a.orderDate);
        DateTime dateB = _safeDate(b.orderDate);
        return dateB.compareTo(dateA);
      });

      activeOrderList = tempList;

      isMoreDataLoaded1.value = false;
      isActiveOrderListLoaded.value = true;
      update();
    } catch (e) {
      isActiveOrderListLoaded.value = true;
      update();
      print("Exception - order_controller.dart - getActiveOrderList(): $e");
    }
  }

  /// 🧩 Small helper for safe date parsing
  DateTime _safeDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == "0000-00-00") {
      return DateTime(1970); // fallback old date
    }
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return DateTime(1970);
    }
  }

  getCompletedOrderHistoryList() async {
    try {
      isCompletedOrderHistoryListLoaded.value = false;

      if (isRecordPending.value == true) {
        isMoreDataLoaded.value = true;

        if (completedOrderList.isEmpty) {
          page.value = 1;
        } else {
          page.value++;
        }

        final result = await apiHelper.getCompletedOrders(page.value);
        if (result != null) {
          if (result.status == "1") {
            List<Order> _tList = result.data;
            if (_tList.isEmpty) {
              isRecordPending.value = false;
            }
            completedOrderList = _tList;

            isMoreDataLoaded.value = false;
          } else {
            completedOrderList = [];
          }
        }
      }

      isCompletedOrderHistoryListLoaded.value = true;
      update();
    } catch (e) {
      print("Exception -  order_controller.dart - getOrderHistoryList():" + e.toString());
    }
  }

  getOrderHistory() async {
    print("Fetching order history");
    final List<dynamic> _ = await Future.wait([
      getActiveOrderList(),
      getCompletedOrderHistoryList()
    ]);
  }
}
