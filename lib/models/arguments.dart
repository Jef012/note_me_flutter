class UserArguments {
  final int? userId;
  final String? mobile;
  final String? email;
  final String? otp;
  final String? authToken;
  final bool? newUser;

  UserArguments({
    this.authToken,
    this.userId,
    this.mobile,
    this.email,
    this.otp,
    this.newUser,
  });
}
