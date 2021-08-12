import 'dart:async';

import 'package:diiket_models/all.dart';
import 'package:driver/data/providers/auth/auth_provider.dart';
import 'package:driver/data/providers/firebase_provider.dart';
import 'package:driver/helpers/validation_helper.dart';
import 'package:driver/ui/common/styles.dart';
import 'package:driver/ui/common/utils.dart';
import 'package:driver/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

enum MobileVerificationState {
  showPhoneForm,
  showOtpForm,
}

class LoginPage extends StatefulWidget {
  static String route = 'driver/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  MobileVerificationState curentState = MobileVerificationState.showPhoneForm;

  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  final phoneNumberField = TextEditingController();
  final otpCodeField = TextEditingController();

  bool isLoading = false;
  String? verificationId;
  int? forceResendingToken;

  Timer? resendTimer;
  int resendTimeoutCounter = 30;

  void startTimer() {
    resendTimer?.cancel();

    const oneSec = Duration(seconds: 1);
    resendTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (resendTimeoutCounter == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            resendTimeoutCounter--;
          });
        }
      },
    );
  }

  void resetTimer() {
    resendTimer?.cancel();
    resendTimeoutCounter = 30;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: () async {
            switch (curentState) {
              case MobileVerificationState.showPhoneForm:
                return true;
              case MobileVerificationState.showOtpForm:
                _cancelConfirmingOtp();
                return false;
            }
          },
          child: ProviderListener(
            provider: authExceptionProvider,
            onChange: _onAuthExceptionChange,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: AbsorbPointer(
                absorbing: isLoading,
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isLoading ? 0.5 : 1,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: _buildContent(context),
                        ),
                      ),
                    ),
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: ColorPallete.primaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (curentState) {
      case MobileVerificationState.showPhoneForm:
        return _buildMobileForm(context);
      case MobileVerificationState.showOtpForm:
        return _buildOtpForm(context);
    }
  }

  Widget _buildMobileForm(BuildContext context) {
    return Form(
      key: phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                const SizedBox(height: 30),
                Text('Diiket Driver', style: kTextTheme.headline1),
                const SizedBox(height: 5),
                const Text(
                    'Masukan nomor telepon Anda yang terdaftar untuk melanjutkan'),
                const SizedBox(height: 37),
                Container(
                  decoration: kBorderedDecoration,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 14.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.phone_android_rounded,
                        color: ColorPallete.darkGray,
                        size: 22.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '+62',
                          style: kTextTheme.bodyText2!.copyWith(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(),
                          child: TextFormField(
                            controller: phoneNumberField,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration.collapsed(
                              hintText: 'Nomor telepon anda',
                            ),
                            onChanged: (_) => setState(() {}),
                            // validator:
                            //     kDebugMode ? null : ValidationHelper.validateMobile,
                            validator: ValidationHelper.validateMobile,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 37),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            height: 48,
            child: PrimaryButton(
              color: ColorPallete.secondaryColor,
              disabled: phoneNumberField.text.isEmpty,
              onPressed: () {
                FocusScope.of(context).unfocus();

                if (!phoneFormKey.currentState!.validate()) return;

                _sendSmsVerificationCode();
              },
              child: Text('Lanjut'),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Text(
              'Selanjutnya, Anda akan menerima SMS untuk verifikasi.',
              style: kTextTheme.overline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpForm(BuildContext context) {
    return Form(
      key: otpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                InkWell(
                  onTap: _cancelConfirmingOtp,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    decoration: BoxDecoration(
                      border: kBorderedDecoration.border,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 42,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Verifikasi',
                  style: kTextTheme.headline1,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Silakan masukkan 6 digit kode yang sudah kami kirim ke nomer Anda di +62 ${phoneNumberField.value.text}.',
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 48,
                ),
                PinCodeTextField(
                  length: 6,
                  // validator: ValidationHelper.validateOtp,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    borderRadius: BorderRadius.circular(4),
                    inactiveColor: ColorPallete.lightGray,
                    inactiveFillColor: ColorPallete.backgroundColor,
                    activeColor: ColorPallete.successColor,
                    activeFillColor: ColorPallete.backgroundColor,
                    selectedColor: ColorPallete.primaryColor,
                    selectedFillColor: ColorPallete.backgroundColor,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  controller: otpCodeField,
                  autoDisposeControllers: false,
                  // onCompleted: (otpCode) {
                  //   _verifyOtpCode(otpCodeField.text);
                  // },
                  appContext: context,
                  onChanged: (String value) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 14),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            height: 48,
            child: PrimaryButton(
              disabled: otpCodeField.text.length != 6,
              color: ColorPallete.secondaryColor,
              onPressed: () {
                FocusScope.of(context).unfocus();

                if (!otpFormKey.currentState!.validate()) return;

                _verifyOtpCode(otpCodeField.text);
              },
              child: Text('Lanjut'),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: resendTimeoutCounter <= 0
                ? TextButton(
                    onPressed: () async {
                      await _sendSmsVerificationCode(
                        forceResendingToken: forceResendingToken,
                        onCodeSent: () {
                          setState(() {
                            resetTimer();
                            startTimer();

                            Utils.alert(
                              context,
                              'Kode verifikasi berhasil dikirim ulang.',
                            );
                          });
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      primary: ColorPallete.primaryColor,
                    ),
                    child: Text('Kirim ulang kode verifikasi'),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      top: 15.0,
                      right: MediaQuery.of(context).size.width * 0.1,
                    ),
                    child: Text(
                      'Kirim ulang kode dalam $resendTimeoutCounter detik',
                      style: kTextTheme.overline,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendSmsVerificationCode({
    int? forceResendingToken,
    Function? onCodeSent,
  }) {
    setState(() {
      isLoading = true;
    });

    return context.read(firebaseAuthProvider).verifyPhoneNumber(
          phoneNumber: "+62 ${phoneNumberField.text}",
          forceResendingToken: forceResendingToken,
          verificationCompleted: (phoneAuthCredential) {
            otpCodeField.text = phoneAuthCredential.smsCode ?? '';

            _signInWithPhoneCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            setState(() {
              curentState = MobileVerificationState.showPhoneForm;
              isLoading = false;
              this.verificationId = null;
              this.forceResendingToken = null;
            });

            context.read(authExceptionProvider).state = CustomException(
              message: error.message,
              stackTrace: error.stackTrace,
              reason: error.code,
            );
          },
          codeSent: (verificationId, forceResendingToken) {
            setState(() {
              curentState = MobileVerificationState.showOtpForm;
              isLoading = false;
              this.verificationId = verificationId;
              this.forceResendingToken = forceResendingToken;
              startTimer();
            });

            onCodeSent?.call();
          },
          codeAutoRetrievalTimeout: (verificationId) {
            // print('timeout');
            // print(verificationId);
          },
        );
  }

  Future<void> _verifyOtpCode(String otpCode) async {
    if (verificationId == null) {
      return setState(() {
        curentState = MobileVerificationState.showPhoneForm;
      });
    }

    final phoneAuthCredential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otpCode,
    );

    await _signInWithPhoneCredential(phoneAuthCredential);
  }

  Future<void> _signInWithPhoneCredential(
      firebase_auth.PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      isLoading = true;
    });

    try {
      await context
          .read(authProvider.notifier)
          .signInWithPhoneCredential(phoneAuthCredential);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _cancelConfirmingOtp() {
    setState(() {
      curentState = MobileVerificationState.showPhoneForm;
      isLoading = false;
      verificationId = null;
      forceResendingToken = null;
      resetTimer();
    });
  }

  void _onAuthExceptionChange(
    BuildContext context,
    StateController<CustomException?> value,
  ) {
    if (value.state != null) {
      print(value.state);

      Utils.alert(context, value.state?.message ?? 'Terjadi kesalahan');
    }
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    phoneNumberField.dispose();
    otpCodeField.dispose();

    super.dispose();
  }
}
