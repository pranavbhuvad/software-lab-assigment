  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
  import 'package:software_lab/core/utils/app_validators.dart';
  import 'package:software_lab/core/theme/app_colors.dart';
  import 'package:software_lab/core/theme/app_text_styles.dart';
  import 'package:software_lab/features/auth/presentation/widgets/auth_card.dart';
  import 'package:software_lab/features/auth/presentation/widgets/custom_textfield.dart';
  import 'package:software_lab/features/auth/presentation/widgets/sign_nav.dart';
  import 'package:software_lab/features/auth/presentation/widgets/step_header.dart';


  class Step2FarmInfo extends StatelessWidget {
    final GlobalKey<FormState> formKey;
    final TextEditingController businessNameCtrl, informalNameCtrl,
        streetCtrl, cityCtrl, zipCtrl;
    final String? selectedState;
    final void Function(String?) onStateChanged;
    final VoidCallback onContinue, onBack;

    static const List<String> _usStates = [
      'Alabama','Alaska','Arizona','Arkansas','California','Colorado',
      'Connecticut','Delaware','Florida','Georgia','Hawaii','Idaho',
      'Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana',
      'Maine','Maryland','Massachusetts','Michigan','Minnesota',
      'Mississippi','Missouri','Montana','Nebraska','Nevada',
      'New Hampshire','New Jersey','New Mexico','New York',
      'North Carolina','North Dakota','Ohio','Oklahoma','Oregon',
      'Pennsylvania','Rhode Island','South Carolina','South Dakota',
      'Tennessee','Texas','Utah','Vermont','Virginia','Washington',
      'West Virginia','Wisconsin','Wyoming',
    ];

    const Step2FarmInfo({
      super.key,
      required this.formKey,
      required this.businessNameCtrl,
      required this.informalNameCtrl,
      required this.streetCtrl,
      required this.cityCtrl,
      required this.zipCtrl,
      required this.selectedState,
      required this.onStateChanged,
      required this.onContinue,
      required this.onBack,
    });

    @override
    Widget build(BuildContext context) {
      return AuthCard(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StepHeader(currentStep: 2, totalSteps: 4, title: 'Farm Info'),
              SizedBox(height: 40.h,),
              CustomTextField(
                hint: 'Business Name',
                prefixIcon: Icons.sell_outlined,
                controller: businessNameCtrl,
                validator: (v) => AppValidators.required(v, 'Business name'),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                hint: 'Informal Name',
                prefixIcon: Icons.tag_faces_outlined,
                controller: informalNameCtrl,
                validator: (v) => AppValidators.required(v, 'Informal name'),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                hint: 'Street Address',
                prefixIcon: Icons.home_outlined,
                controller: streetCtrl,
                validator: (v) => AppValidators.required(v, 'Address'),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                hint: 'City',
                prefixIcon: Icons.location_on_outlined,
                controller: cityCtrl,
                validator: (v) => AppValidators.required(v, 'City'),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DropdownButtonFormField<String>(
                      value: selectedState,
                      hint: Text('State',
                          style: AppTextStyles.body.copyWith(
                              color: AppColors.textHint, fontSize: 13.sp)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.inputFill,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 15.h),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(0.5),
                              width: 1.2),
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                                color: AppColors.error, width: 1)),
                        isDense: true,
                      ),
                      icon: Icon(Icons.keyboard_arrow_down,
                          size: 18.sp, color: AppColors.textSecondary),
                      isExpanded: true,
                      items: _usStates
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s,
                                    style: AppTextStyles.body.copyWith(
                                        color: AppColors.textPrimary,
                                        fontSize: 13.sp)),
                              ))
                          .toList(),
                      onChanged: onStateChanged,
                      style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary, fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 5,
                    child: CustomTextField(
                      hint: 'Enter Zipcode',
                      prefixIcon: Icons.pin_drop_outlined,
                      controller: zipCtrl,
                      keyboardType: TextInputType.number,
                      validator: AppValidators.zipCode,
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(height: 24.h),
              SignupNavRow(onBack: onBack, onContinue: onContinue),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      );
    }
  }