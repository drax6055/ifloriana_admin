import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../main.dart';
import '../../../network/model/packages.dart';
import '../../../network/network_const.dart';

class PackagesController extends GetxController {
  var packages = <Package>[].obs;
  var selectedPackageId = RxnInt();
  var selectedIndex = 0.obs; // 0 = Monthly (default), 1 = Yearly
  var filteredPackages = <Package>[].obs;
  late Razorpay _razorpay;

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
    _razorpay.clear(); // Dispose of the Razorpay instance
    super.onClose();
  }

  void toggleGender(int index) {
    selectedIndex.value = index;
    filterPackages();
  }

  void fetchPackages() async {
    try {
      final response = await dioClient.dio
          .get('${Apis.PackagesbaseUrl}${Endpoints.packages}');
      if (response.statusCode == 200) {
        PackagesResponse packagesResponse =
            PackagesResponse.fromJson(response.data);
        packages.value = packagesResponse.packages;
        filterPackages(); // Filter on initial load
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
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
        'key': 'rzp_live_0c4P2L2TUgxP8X', // Ensure this is correct
        'amount': (selectedPackage.price * 100).toInt(), // Convert ₹ to paise
        'name': selectedPackage.name,
        'description': selectedPackage.description,
        'prefill': {
          'contact': '9974011196', // Must be 10-digit, no country code
          'email': 'sonidhairya1212@gmail.com'
        },
        'external': {
          'wallets': ['paytm']
        }
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        Get.snackbar('Error', 'Failed to open Razorpay: $e');
        print('==> Failed to open Razorpay: $e');
      }
    }
  }
                          
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar('Success', 'Payment successful: ${response.paymentId}');
    print('Payment successful: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Error', 'Payment failed: ${response.message}');
    print('==>Payment failed: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('Info', 'External Wallet selected: ${response.walletName}');
    print('External Wallet selected: ${response.walletName}');
  }
}
