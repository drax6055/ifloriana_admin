import 'package:flutter/cupertino.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import '../../../commen_items/sharePrafrence.dart';
import '../../../main.dart';
import '../../../network/model/login_model.dart';
import '../../../network/network_const.dart';
import '../../../route/app_route.dart';

class LoginController extends GetxController {
  final SharedPreferenceManager _prefs = SharedPreferenceManager();

  var emailController = TextEditingController();
  var passController = TextEditingController();
  var showPass = false.obs;

  void toggleShowPass() {
    showPass.value = !showPass.value;
  }

  Future onLoginPress() async {

    Map<String, dynamic> loginData = {
      'email': emailController.text, 
      'password': passController.text, 
    };

    try {
      Login loginResponse = await dioClient.postData<Login>(
        '${Apis.baseUrl}${Endpoints.login}',
        loginData,
        (json) => Login.fromJson(json),
      );

      await _prefs.setUser(loginResponse);
      await _prefs.saveAccessToken(loginResponse.token!);
      Get.offNamed(Routes.drawerScreen);
    } catch (e) {
      Get.snackbar(
        'Error',
        "Invalid username or password",
        snackPosition: SnackPosition.BOTTOM,
        leftBarIndicatorColor: red,
        backgroundColor: red.withOpacity(0.1),
        borderRadius: 10,
        margin: EdgeInsets.all(15),
      );
    }
  }
}
