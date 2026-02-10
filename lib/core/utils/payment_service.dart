import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  late Razorpay _razorpay;
  final AuthRepository authRepository;
  final FirebaseFirestore firestore;

  PaymentService({required this.authRepository, required this.firestore});

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void openCheckout({
    required double amount,
    required String contact,
    required String email,
    String description = 'VoxAI Quest Premium - 30 Days',
  }) {
    var options = {
      'key': dotenv.env['RAZORPAY_KEY_ID'] ?? 'rzp_test_YourKeyHere',
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': 'VoxAI Quest',
      'description': description,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void purchaseSubscription({required String contact, required String email}) {
    openCheckout(
      amount: 99, // 99 INR
      contact: contact,
      email: email,
      description: 'VoxAI Quest Premium - 1 Month',
    );
  }

  Future<void> upgradeToPremium(String userId) async {
    final expiryDate = DateTime.now().add(const Duration(days: 30));
    await firestore.collection('users').doc(userId).update({
      'isPremium': true,
      'premiumExpiryDate': Timestamp.fromDate(expiryDate),
    });
  }

  void dispose() {
    _razorpay.clear();
  }
}
