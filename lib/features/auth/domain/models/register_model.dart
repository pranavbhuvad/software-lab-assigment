import 'dart:io';

class RegisterRequest {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String businessName;
  final String informalName;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final File? registrationProof;
  final Map<String, List<String>> businessHours;
  final String deviceToken;
  final String type;
  final String? socialId;

  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
    required this.businessName,
    required this.informalName,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    this.registrationProof,
    required this.businessHours,
    required this.deviceToken,
    this.type = 'email',
    this.socialId,
  });

  /// Flatten business_hours into form-data friendly strings
  /// e.g. business_hours[mon][0] = "8:00am - 10:00am"
  Map<String, String> toFormFields() {
    final fields = <String, String>{
      'full_name': fullName,
      'email': email,
      'phone': '+91$phone',
      'password': password,
      'role': role,
      'business_name': businessName,
      'informal_name': informalName,
      'address': address,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'device_token': deviceToken,
      'type': type,
      if (socialId != null) 'social_id': socialId!,
    };

    businessHours.forEach((day, slots) {
      for (int i = 0; i < slots.length; i++) {
        fields['business_hours[$day][$i]'] = slots[i];
      }
    });

    return fields;
  }
}

class RegisterResponse {
  final bool success;
  final String message;
  final String? token;

  const RegisterResponse({
    required this.success,
    required this.message,
    this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      token: json['token'] as String?,
    );
  }
}