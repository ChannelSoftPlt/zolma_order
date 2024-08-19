import 'dart:convert';
import 'package:http/http.dart' as http;

class Domain {
  static var domain = 'https://zolmaorder.com/order/mobile/';

  static var getproduct = domain + 'product2/index.php';
  static var getdealerinfo = domain + 'dealer/index.php';
  static var insertorder = domain + 'Order/index.php';
  static var getpromotion = domain + 'promotion/index.php';
  static var getcategory = domain + 'category/index.php';
  static var getstatus = domain + 'status/index.php';
  static var getdelivery = domain + 'delivery/index.php';
  static var getdriverinfo = domain + 'driver/index.php';
  static var getsystem = domain + 'system/index.php';


  static callApi(url, Map<String, String> params) async {
    var response = await http.post(url, body: params);
    return jsonDecode(response.body);
  }
}
String websitefilelink="https://zolmaorder.com/order/product/";

String imglink="https://zolmaorder.com/order/product/product_img/";

String promotionlink="https://zolmaorder.com/order/promotion/promotion_img/";

String filelink="https://zolmaorder.com/order/mobile/";

String categorylink="https://zolmaorder.com/order/category/category_img/";


