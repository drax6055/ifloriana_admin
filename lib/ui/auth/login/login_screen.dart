import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/app_images.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';
import '../../../route/app_route.dart';
import '../../../utils/custom_text_styles.dart';
import '../../../utils/validation.dart';
import '../../../wiget/Custome_textfield.dart';
import '../../../wiget/Custome_button.dart';
import '../../../wiget/custome_text.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController getController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>(); 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Form(
         key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
               Login_screen(),
              ],
            ),
          ),
        ),
    
    );
  }

  Widget InputTxtfield_Email() {
    return CustomTextFormField(
      controller: getController.emailController,
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) => Validation.validateEmail(value),
    );
  }

  Widget InputTxtfield_Pass() {
    return Obx(() => CustomTextFormField(
          controller: getController.passController,
          labelText: 'Password',
          obscureText: !getController.showPass.value,
          suffixIcon: IconButton(
            onPressed: () {
              getController.toggleShowPass();
            },
            icon: Icon(
              getController.showPass.value
                  ? Icons.visibility
                  : Icons.visibility_off,
                  color: grey,
            ),
            
          ),
          validator: (value) => Validation.validatePassword(value), 
        ));
  }

  Widget Btn_Login() {
    return ElevatedButtonExample(
      text: "Login",
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          getController.onLoginPress();
        } else {
          Get.snackbar(
            'Validation Error',
            'Please fill in all fields correctly',
            snackPosition: SnackPosition.BOTTOM,
            leftBarIndicatorColor: red,
            backgroundColor: red.withOpacity(0.1),
            borderRadius: 10,
            margin: EdgeInsets.all(15),
          );
        }
      },
    );
  }
Widget login_screen_header() {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Container(
        height: 170.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
      ),
      Positioned(
        bottom: -50,
        child: Container(
           decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10, 
                  color: secondaryColor, 
                  spreadRadius: 6
                  )
                ],
            ),
          child: CircleAvatar(
            radius: 70,
            backgroundColor: primaryColor,
            foregroundImage: AssetImage(AppImages.applogo,),
          ),
        ),
      )
    ],
  );
}


   Widget login_screen_body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CustomTextWidget(
           text: 'Welcome Back!',
            textStyle: CustomTextStyles.textFontSemiBold(size: 16.sp),
          ),
           SizedBox(height: 3.h),
           CustomTextWidget(
           text: 'You Have Been Missed For Long Time',
            textStyle: CustomTextStyles.textFontSemiBold(size: 12.sp,color: grey),
          ),
            SizedBox(height: 20.h),
          
          InputTxtfield_Email(),
          SizedBox(height: 16.h),
          InputTxtfield_Pass(),
          SizedBox(height: 16.h),
          Align(alignment: Alignment.topRight,child: CustomTextWidget(text: "Forgot your password?",textStyle: CustomTextStyles.textFontBold(size: 14.sp,color: primaryColor))),
          SizedBox(height: 30.h),
          Btn_Login(),
          SizedBox(height: 16.h),
          InkWell(onTap: () =>  Get.toNamed(Routes.registerScreen),
            child: Align(alignment: Alignment.center,child: CustomTextWidget(text: "Create new account",textStyle: CustomTextStyles.textFontBold(size: 14.sp,color: primaryColor)))),
        ],
      ),
    );
   }
   Widget Login_screen(){
    return Column(
      children: [
        login_screen_header(),
        SizedBox(height: 45.h),
        login_screen_body(),
      ],
    );
   }
}
