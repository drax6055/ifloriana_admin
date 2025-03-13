import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../main.dart';
import '../../../network/model/packages.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

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
        'key': 'rzp_live_0c4P2L2TUgxP8X', 
        'amount': (selectedPackage.price * 100).toInt(), 
        'name': selectedPackage.name,
        'description': selectedPackage.description,
        'prefill': {
          'contact': '9974011196', 
          'email': 'sonidhairya1212@gmail.com'
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    CustomSnackbar.showSuccess(
        'Success', 'Payment successful: ${response.paymentId}');
    print('Success --> Payment successful: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CustomSnackbar.showError('Error', 'Payment failed: ${response.message}');
    print('Error --> Payment failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CustomSnackbar.showSuccess(
        'Info', 'External Wallet selected: ${response.walletName}');
    print('Info : External Wallet selected: ${response.walletName}');
  }
}
