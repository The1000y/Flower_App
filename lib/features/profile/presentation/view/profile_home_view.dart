//import 'package:flower_app/config/routing/routes.dart';
// import 'package:flower_app/features/profile/presentation/view/widgets/body_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../manager/profile_event.dart';
// import '../manager/profile_state.dart';
// import '../manager/profile_viewModel.dart';
//
// class ProfileHomeView extends StatefulWidget {
//   const ProfileHomeView({super.key});
//
//   @override
//   State<ProfileHomeView> createState() => _ProfileHomeViewState();
// }
//
// class _ProfileHomeViewState extends State<ProfileHomeView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileHomeViewModel>().doIntent(GetProfileIntent());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<ProfileHomeViewModel, ProfileHomeState>(
//         builder: (context, state) {
//           if (state.isLoading && state.data == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (state.data == null && state.errorMessage.isNotEmpty) {
//             return Center(child: Text(state.errorMessage));
//           }
//
//           return SafeArea(
//             child: ProfileBody(
//               user: state.data,
//               onEditProfile: () =>
//                   Navigator.pushNamed(context, Routes.editProfile),
//               onSavedAddress: () =>  Navigator.pushNamed(context, Routes.savedAddresses),
//               onNotification: () {},
//               onLanguage: () {},
//               onLogout: () =>
//                   Navigator.popUntil(context, (route) => route.isFirst),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }