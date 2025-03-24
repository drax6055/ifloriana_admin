import 'package:flutter/material.dart';
import 'package:flutter_template/ui/drawer/profile/profile_controller.dart';
import 'package:get/get.dart';

import '../../../wiget/appbar/commen_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController getController = Get.put(ProfileController());

    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(title: "title"),
      body: Column(
        children: [
          
        ],
      ),
    ));
  }
}
