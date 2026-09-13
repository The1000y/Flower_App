import 'dart:io';

import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/presentation/register/view/widgets/register_custom_text_form_field.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_gender_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:image_picker/image_picker.dart';

import '../manager/cubit/profile_event.dart';
import '../manager/cubit/profile_state.dart';
import '../manager/cubit/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final ValueNotifier<bool> _isFemaleNotifier = ValueNotifier<bool>(true);

  ProfileEntity? _loadedProfile;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileViewModel>().doEvent(FetchProfileEvent());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _isFemaleNotifier.dispose();
    super.dispose();
  }

  void _fillFieldsFrom(ProfileEntity profile) {
    _loadedProfile = profile;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
    _isFemaleNotifier.value = profile.gender.toLowerCase() == 'female';
  }

  Future<void> _onAvatarTap(BuildContext context) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      context.read<ProfileViewModel>().doEvent(PickProfileImageEvent(imagePath: picked.path));
    }
  }

  void _onUpdatePressed(BuildContext context) {
    setState(() => _isSubmitted = true);
    if (!_formKey.currentState!.validate() || _loadedProfile == null) return;

    context.read<ProfileViewModel>().doEvent(
      UpdateProfileEvent(
        profile: ProfileEntity(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          gender: _isFemaleNotifier.value ? 'Female' : 'Male',
          photoUrl: _loadedProfile!.photoUrl, // upload not available yet — keep existing
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileViewModel, ProfileState>(
      listenWhen: (previous, current) =>
      previous.profileState != current.profileState ||
          previous.updateProfileState != current.updateProfileState,
      listener: (context, state) {
        if (state.profileState.data != null && _loadedProfile == null) {
          setState(() => _fillFieldsFrom(state.profileState.data!));
        }
        if (state.profileState.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.profileState.errorMessage!), backgroundColor: AppColors.error));
        }
        if (state.updateProfileState.data != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Profile updated')));
        }
        if (state.updateProfileState.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.updateProfileState.errorMessage!), backgroundColor: AppColors.error));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Edit profile', style: Theme.of(context).textTheme.titleLarge),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                // navigates to notifications screen — out of scope for this feature
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileViewModel, ProfileState>(
          builder: (context, state) {
            if (state.profileState.isLoading && _loadedProfile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () => _onAvatarTap(context),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 40.r,
                              backgroundImage: state.pickedImagePath != null
                                  ? FileImage(File(state.pickedImagePath!)) as ImageProvider
                                  : (_loadedProfile?.photoUrl != null
                                  ? NetworkImage(_loadedProfile!.photoUrl!)
                                  : null),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 12.r,
                                backgroundColor: AppColors.pinkBase,
                                child: Icon(Icons.camera_alt, size: 14.sp, color: AppColors.whiteBase),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RegisterCustomTextFormField(
                            label: 'First name',
                            hintText: 'Enter first name',
                            controller: _firstNameController,
                            validator: AuthValidators.firstName,
                            forceShowErrors: _isSubmitted,
                          ),
                        ),
                        SizedBox(width: 17.w),
                        Expanded(
                          child: RegisterCustomTextFormField(
                            label: 'Last name',
                            hintText: 'Enter last name',
                            controller: _lastNameController,
                            validator: AuthValidators.lastName,
                            forceShowErrors: _isSubmitted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    RegisterCustomTextFormField(
                      label: 'Email',
                      hintText: 'Enter email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: AuthValidators.email,
                      forceShowErrors: _isSubmitted,
                    ),
                    SizedBox(height: 24.h),
                    RegisterCustomTextFormField(
                      label: 'Phone number',
                      hintText: 'Enter phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: AuthValidators.phone,
                      forceShowErrors: _isSubmitted,
                    ),
                    SizedBox(height: 24.h),
                 IgnorePointer(  child: RegisterCustomTextFormField(
                      label: 'Password',
                      hintText: '',
                      controller: TextEditingController(text: '••••••'),
                      suffixIcon: TextButton(
                        onPressed: () {
                          // navigates to change-password screen — out of scope for this feature
                        },
                        child: Text(
                          'Change',
                          style: TextStyle(
                            color: AppColors.pinkBase,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),),
                    SizedBox(height: 16.h),
                    ProfileGenderSelector(isFemaleNotifier: _isFemaleNotifier),
                    SizedBox(height: 48.h),
                    CustomButton(
                      text: 'Update',
                      isEnabled: !state.updateProfileState.isLoading,
                      isLoading: state.updateProfileState.isLoading,
                      enabledColor: AppColors.pinkBase,
                      onPressed: () => _onUpdatePressed(context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}