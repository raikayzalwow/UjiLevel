import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';
import '../../../core/theme/app_theme.dart';
import 'setup_profile_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _verify() async {
    String otpCode = _controllers.map((e) => e.text).join();
    if (otpCode.length < 6) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Kode Belum Lengkap',
        text: 'Silakan lengkapi 6 digit kode verifikasi Anda',
        confirmBtnText: 'Mengerti',
        confirmBtnColor: AppColors.forestGreen,
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SetupProfileScreen(email: widget.email),
        ),
      );
    }
  }

  void _handleResendCode() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Berhasil',
      text: 'Kode OTP baru berhasil dikirim ulang ke email Anda.',
      confirmBtnText: 'Oke',
      confirmBtnColor: AppColors.forestGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.04),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.black.withValues(alpha: 0.05),
                            width: 1),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.forestGreen,
                        size: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Verifikasi OTP',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  RichText(
                    text: TextSpan(
                      text:
                          'Silakan masukkan 6 digit kode yang telah dikirimkan ke alamat email ',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        color: AppColors.forestGreen.withValues(alpha: 0.6),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.forestGreen,
                          ),
                        ),
                        const TextSpan(text: ' untuk verifikasi akun.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 44),

                  // otp
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          height: 52,
                          child: CallbackShortcuts(
                            bindings: <ShortcutActivator, VoidCallback>{
                              const SingleActivator(
                                  LogicalKeyboardKey.backspace): () {
                                if (_controllers[index].text.isEmpty &&
                                    index > 0) {
                                  _controllers[index - 1].clear();
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                            },
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.forestGreen,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              cursorColor: AppColors.sageTeal,
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.45),
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: AppColors.sageTeal, width: 1.5),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // verif
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: _isLoading ? null : _verify,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.forestGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Verifikasi',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // kir ul kode
                  Center(
                    child: GestureDetector(
                      onTap: _handleResendCode,
                      child: RichText(
                        text: TextSpan(
                          text: 'Tidak menerima kode? ',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color:
                                AppColors.forestGreen.withValues(alpha: 0.55),
                            fontSize: 13,
                          ),
                          children: const [
                            TextSpan(
                              text: 'Kirim ulang',
                              style: TextStyle(
                                color: AppColors.forestGreen,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
