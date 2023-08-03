import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'Class/CreditClass.dart';

class CreditController extends GetxController {
  var creditData = <Credit>[].obs;

  void updateCreditData(List<Credit> newData) {
    creditData.value = newData;
  }
}
