import 'package:flutter/widgets.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../main.dart';
import '../../../network/model/packages_model.dart';
import '../../../network/model/signup_model.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

class PackagesController extends GetxController {
  var packages = <Package>[].obs;
  var selectedPackageId = RxnInt();
  var selectedIndex = 0.obs; // 0 = Monthly (default), 1 = Yearly
  var filteredPackages = <Package>[].obs;
  late Razorpay _razorpay;
  final Map<String, dynamic> registerData = Get.arguments;

  @override
  void onInit() {
    fetchPackages();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  void toggleGender(int index) {
    selectedIndex.value = index;
    filterPackages();
  }

  void fetchPackages() async {
    try {
      final response =
          await dioClient.dio.get('${Apis.baseUrl}${Endpoints.packages}');
      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        packages.value = jsonData.map((e) => Package.fromJson(e)).toList();
        filterPackages();
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  void filterPackages() {
    if (selectedIndex.value == 0) {
      filteredPackages.value = packages
          .where((pkg) => pkg.subscriptionPlan.toLowerCase() == "monthly")
          .toList();
    } else {
      filteredPackages.value = packages
          .where((pkg) => pkg.subscriptionPlan.toLowerCase() == "yearly")
          .toList();
    }
  }

  void updateSelected(int value) {
    selectedPackageId.value = value;
  }

  void startPayment() {
    var selectedPackage =
        packages.firstWhereOrNull((pkg) => pkg.id == selectedPackageId.value);
    if (selectedPackage != null) {
      var options = {
        'key': dotenv.env['RAZORPAY_KEY_ID'],
        'amount': (selectedPackage.price * 100).toInt(),
        'name': selectedPackage.name,
        'description': selectedPackage.description,
        'prefill': {
          'contact': registerData['Phone'],
          'email': registerData['Email']
        },
        'external': {
          'wallets': ['paytm']
        }
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        CustomSnackbar.showError('Error', 'Failed to open Razorpay: $e');
        print('==> Failed to open Razorpay: $e');
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      String paymentId = response.paymentId ?? '';

      var selectedPackage =
          packages.firstWhereOrNull((pkg) => pkg.id == selectedPackageId.value);

      if (selectedPackage != null) {
        double amount = selectedPackage.price * 100;

        await dioClient.capturePayment(paymentId, amount);

        CustomSnackbar.showSuccess('Success', 'Payment captured successfully');
        print('Success --> Payment captured successfully: $paymentId');
        onRegisterData();
        Get.offNamed(Routes.loginScreen);
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Payment capture failed: $e');
      print('Error --> Payment capture failed: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomSnackbar.showError('Error', 'Payment failed: ${response.message}');
    print('Error --> Payment failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CustomSnackbar.showSuccess(
        'Info', 'External Wallet selected: ${response.walletName}');
    print('Info: External Wallet selected: ${response.walletName}');
  }

  Future onRegisterData() async {
    Map<String, dynamic> register_post_details = {
      'full_name': registerData['Owner_Name'].toString(),
      'salon_name': registerData['Salon_Name'].toString(),
      'phone_number': registerData['Phone'].toString(),
      'email': registerData['Email'].toString(),
      'address': registerData['Address'].toString(),
      'package_id': selectedPackageId.value,
    };

    try {
      Sigm_up_model registerResponse = await dioClient.postData<Sigm_up_model>(
        '${Apis.baseUrl}${Endpoints.signup}',
        register_post_details,
        (json) => Sigm_up_model.fromJson(json),
      );
      Get.offNamed(Routes.loginScreen);
    } catch (e) {
      CustomSnackbar.showError("==>", e.toString());
    }
  }
}
