//import 'package:flower_app/core/locale/locale_cubit.dart';
// import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
// import 'package:flower_app/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../config/routing/routes.dart';
// import 'optionTile.dart';
//
// class ProfileBody extends StatelessWidget {
//   final UserEntity? user;
//   final VoidCallback onEditProfile;
//   final VoidCallback onNotification;
//   final VoidCallback onLanguage;
//   final VoidCallback onLogout;
//   final VoidCallback onSavedAddress;
//
//   const ProfileBody({
//     required this.user,
//     required this.onEditProfile,
//     required this.onNotification,
//     required this.onLanguage,
//     required this.onLogout,
//     required this.onSavedAddress,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildHeader(context),
//           const SizedBox(height: 20),
//           _buildProfileInfo(),
//           const SizedBox(height: 20),
//           _buildProfileOptions(context),
//           const SizedBox(height: 20),
//           _buildVersion(context),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             l10n.floweryAppbarTitle,
//             style: Theme.of(
//               context,
//             ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
//           ),
//           GestureDetector(
//             onTap: onNotification,
//             child: Stack(
//               children: [
//                 const Icon(Icons.notifications_none_outlined, size: 26),
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     width: 7,
//                     height: 7,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileInfo() {
//     return Column(
//       children: [
//         Stack(
//           clipBehavior: Clip.none,
//           children: [
//             const CircleAvatar(radius: 34, child: Icon(Icons.person, size: 32)),
//             Positioned(
//               right: -4,
//               bottom: -2,
//               child: GestureDetector(
//                 onTap: onEditProfile,
//                 child: Container(
//                   width: 24,
//                   height: 24,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: const Icon(Icons.edit_outlined, size: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Text(
//           user?.fullName ?? '',
//           style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           user?.email ?? '',
//           style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProfileOptions(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final currentLanguageName =
//         context.watch<LocaleCubit>().currentLanguageName;
//
//     return Column(
//       children: [
//         ProfileOptionTile(
//           icon: Icons.receipt_long_outlined,
//           title: l10n.myOrdersTitle,
//           onTap: () {
//             // orders route
//           },
//         ),
//
//         ProfileOptionTile(
//           icon: Icons.bookmark_border,
//           title: l10n.saveAddress,
//           onTap: () {
//             Navigator.pushNamed(context, Routes.savedAddresses);      },
//         ),
//
//         const Divider(height: 1),
//
//         ProfileOptionTile(
//           icon: Icons.notifications_none_outlined,
//           title: l10n.notificationTitle,
//           trailing: Switch(
//             value: true,
//             onChanged: (_) {
//               // notification setting intent later
//             },
//           ),
//           onTap: onNotification,
//         ),
//
//         const Divider(height: 1),
//
//         ProfileOptionTile(
//           icon: Icons.language_outlined,
//           title: l10n.language,
//           trailingText: currentLanguageName,
//           onTap: onLanguage,
//         ),
//
//         ProfileOptionTile(
//           icon: Icons.info_outline,
//           title: l10n.aboutUs,
//           onTap: () {
//             // about route
//           },
//         ),
//
//         ProfileOptionTile(
//           icon: Icons.description_outlined,
//           title: l10n.termsAndConditionsAlt,
//           onTap: () {
//             // terms route
//           },
//         ),
//
//         const Divider(height: 1),
//
//         ProfileOptionTile(
//           icon: Icons.logout_outlined,
//           title: l10n.logout,
//           onTap: onLogout,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildVersion(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Text(
//         l10n.versionProfile,
//         style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
//       ),
//     );
//   }
// }
