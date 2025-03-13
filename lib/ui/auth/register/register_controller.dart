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

  }

}
