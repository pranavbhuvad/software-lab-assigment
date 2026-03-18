class LoginRequest {
  final String email;
  final String password;
  final String role;
  final String? deviceToken;
  final String type;
  final String? socialId;

  const LoginRequest({
    required this.email,
    required this.password,
    this.role = 'farmer',
    this.deviceToken,
    this.type = 'email',
    this.socialId,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'role': role,
        if (deviceToken != null) 'device_token': deviceToken,
        'type': type,
        if (socialId != null) 'social_id': socialId,
      };
}

class RegisterRequest {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String? businessName;
  final String? informalName;
  final String? address;
  final String? city;
  final String? state;
  final int? zipCode;
  final String? deviceToken;
  final String type;

  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.role = 'farmer',
    this.businessName,
    this.informalName,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.deviceToken,
    this.type = 'email',
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
        if (businessName != null) 'business_name': businessName,
        if (informalName != null) 'informal_name': informalName,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (zipCode != null) 'zip_code': zipCode,
        if (deviceToken != null) 'device_token': deviceToken,
        'type': type,
      };
}

class ForgotPasswordRequest {
  final String mobile;
  const ForgotPasswordRequest({required this.mobile});
  Map<String, dynamic> toJson() => {'mobile': mobile};
}

class VerifyOtpRequest {
  final String otp;
  const VerifyOtpRequest({required this.otp});
  Map<String, dynamic> toJson() => {'otp': otp};
}

class ResetPasswordRequest {
  final String token;
  final String password;
  final String cpassword;

  const ResetPasswordRequest({
    required this.token,
    required this.password,
    required this.cpassword,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'password': password,
        'cpassword': cpassword,
      };
}

class AuthUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String token;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return AuthUser(
      id: data['id']?.toString() ?? '',
      fullName: data['full_name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      role: data['role']?.toString() ?? '',
      token: data['token']?.toString() ?? '',
    );
  }
}