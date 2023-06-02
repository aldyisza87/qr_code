import 'package:get/get.dart';

class LoginController extends GetxController {
  //Nilai awal true untuk hidden password yang akan di pantau dengan obs
  RxBool isHidden = true.obs;

  // Controler untuk button login set awal false karena belum klik
  RxBool isLoading = false.obs;
}
