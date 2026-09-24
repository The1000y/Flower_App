import 'package:flower_app/config/utils/auth_validators.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/core/shared/app_widgets/custom_text_form_field.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_avatar.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/profile_gender_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../manager/cubit/profile_event.dart';
import '../manager/cubit/profile_state.dart';
import '../manager/cubit/profile_view_model.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController(text: AppStrings.passwordMask);
  final ValueNotifier<bool> _isFemaleNotifier = ValueNotifier<bool>(true);

  String get _gender =>
      _isFemaleNotifier.value ? AppStrings.genderFemaleApi : AppStrings.genderMaleApi;

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
    _passwordController.dispose();
    _isFemaleNotifier.dispose();
    super.dispose();
  }

  void _fillFieldsFrom(ProfileEntity profile) {
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber;
    _isFemaleNotifier.value = profile.gender.toLowerCase() != 'male';
  }

  bool _hasChanges(ProfileEntity original, String? pickedImagePath) {
    return pickedImagePath != null ||
        _firstNameController.text.trim() != original.firstName ||
        _lastNameController.text.trim() != original.lastName ||
        _emailController.text.trim() != original.email ||
        _phoneController.text.trim() != original.phoneNumber ||
        _gender.toLowerCase() != original.gender.toLowerCase();
  }

  void _onUpdatePressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<ProfileViewModel>();
    final original = viewModel.state.profileState.data;
    if (original == null) return;

    viewModel.doEvent(
      UpdateProfileEvent(
        profile: ProfileEntity(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          gender: _gender,
          photoUrl: viewModel.state.pickedImagePath ?? original.photoUrl,
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Fill the form once, when the profile first arrives
        BlocListener<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
          previous.profileState.data == null && current.profileState.data != null,
          listener: (context, state) => _fillFieldsFrom(state.profileState.data!),
        ),
        BlocListener<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
          previous.profileState.errorMessage != current.profileState.errorMessage &&
              current.profileState.errorMessage.isNotEmpty,
          listener: (context, state) =>
              _showSnackBar(state.profileState.errorMessage, isError: true),
        ),
        BlocListener<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
          previous.updateProfileState != current.updateProfileState,
          listener: (context, state) {
            final update = state.updateProfileState;
            if (update.data != null) {
              _showSnackBar(AppStrings.profileUpdated);
            } else if (update.errorMessage.isNotEmpty) {
              _showSnackBar(update.errorMessage, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppStrings.editProfileTitle, style: Theme.of(context).textTheme.titleLarge),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {
                // navigates to notifications screen, out of scope for this feature
              },
            ),
          ],
        ),
        // Rebuilds the whole screen only when the profile itself loads or fails
        body: BlocBuilder<ProfileViewModel, ProfileState>(
          buildWhen: (previous, current) => previous.profileState != current.profileState,
          builder: (context, state) {
            final profileState = state.profileState;
            if (profileState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (profileState.data == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(profileState.errorMessage),
                    TextButton(
                      onPressed: () =>
                          context.read<ProfileViewModel>().doEvent(FetchProfileEvent()),
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }
            return _buildForm();
          },
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: ProfileAvatar()),
            SizedBox(height: 24.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: AppStrings.firstNameLabel,
                    hintText: AppStrings.firstNameHint,
                    controller: _firstNameController,
                    validator: AuthValidators.firstName,
                  ),
                ),
                SizedBox(width: 17.w),
                Expanded(
                  child: CustomTextFormField(
                    label: AppStrings.lastNameLabel,
                    hintText: AppStrings.lastNameHint,
                    controller: _lastNameController,
                    validator: AuthValidators.lastName,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            CustomTextFormField(
              label: AppStrings.emailLabel,
              hintText: AppStrings.emailHint,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: AuthValidators.email,
            ),
            SizedBox(height: 24.h),
            CustomTextFormField(
              label: AppStrings.phoneNumberLabel,
              hintText: AppStrings.phoneNumberHint,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: AuthValidators.phone,
            ),
            SizedBox(height: 24.h),
            CustomTextFormField(
              label: AppStrings.passwordLabel,
              hintText: '',
              controller: _passwordController,
              readOnly: true,
              suffixIcon: TextButton(
                onPressed: () {
                  // navigates to change-password screen, out of scope for this feature
                },
                child: Text(
                  AppStrings.actionChange,
                  style: const TextStyle(
                    color: AppColors.pinkBase,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            ProfileGenderSelector(isFemaleNotifier: _isFemaleNotifier),
            SizedBox(height: 48.h),
            _buildUpdateButton(),
          ],
        ),
      ),
    );
  }

  // Own BlocBuilder: rebuilds only on update loading, picked image, or loaded profile changes
  Widget _buildUpdateButton() {
    return BlocBuilder<ProfileViewModel, ProfileState>(
      buildWhen: (previous, current) =>
      previous.updateProfileState.isLoading != current.updateProfileState.isLoading ||
          previous.pickedImagePath != current.pickedImagePath ||
          previous.profileState.data != current.profileState.data,
      builder: (context, state) {
        final original = state.profileState.data;
        return ListenableBuilder(
          listenable: Listenable.merge([
            _firstNameController,
            _lastNameController,
            _emailController,
            _phoneController,
            _isFemaleNotifier,
          ]),
          builder: (context, _) {
            final hasChanges =
                original != null && _hasChanges(original, state.pickedImagePath);
            return CustomButton(
              text: AppStrings.actionUpdate,
              // disabled when nothing changed; CustomButton also blocks taps while loading
              isEnabled: hasChanges,
              isLoading: state.updateProfileState.isLoading,
              enabledColor: AppColors.pinkBase,
              onPressed: () => _onUpdatePressed(context),
            );
          },
        );
      },
    );
  }
}