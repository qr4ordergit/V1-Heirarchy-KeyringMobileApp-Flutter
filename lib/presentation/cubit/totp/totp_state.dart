class TotpState {
  final String otpCode;
  final int remainingSeconds;
  final String? errorMessage;

  const TotpState({
    this.otpCode = '',
    this.remainingSeconds = 30,
    this.errorMessage,
  });
}
