import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {

  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var salonNameController = TextEditingController();
  var ownerNameController = TextEditingController();



 Future onRegisterPress() async {

    Map<String, dynamic> loginData = {
      'full_name': ownerNameController.text,
      'business_name': salonNameController.text, 
      'phone_number': phoneController.text,
      'email': emailController.text,
      'address': addressController.text,
      'package_id': 1,

 
    };

  //   try {
  //     Login loginResponse = await dioClient.postData<Login>(
  //       '${Apis.baseUrl}${Endpoints.login}',
  //       loginData,
  //       (json) => Login.fromJson(json),
  //     );

  //     await _prefs.setUser(loginResponse);
  //     await _prefs.saveAccessToken(loginResponse.token!);
  //     Get.offNamed(Routes.drawerScreen);
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       "Invalid username or password",
  //       snackPosition: SnackPosition.BOTTOM,
  //       leftBarIndicatorColor: red,
  //       backgroundColor: red.withOpacity(0.1),
  //       borderRadius: 10,
  //       margin: EdgeInsets.all(15),
  //     );
  //   }

  //// {
//     "status": "success",
//     "message": "User registered successfully",
//     "user": {
//         "id": 2,
//         "full_name": "Jane Smith",
//         "salon_name": "Jane's Beauty Hub",
//         "phone_number": "9876543210",
//         "email": "jane@example.com",
//         "address": "Building 2, Area 5, Near Mall, City 2",
//         "package_id": 2,
//         "created_at": "2025-03-13T10:05:00.000000Z",
//         "updated_at": "2025-03-13T10:05:00.000000Z"
//     },
//     "token": "2|XYZ1234567890ABCDEFGHIJKLMNO"
// }

  }

}
