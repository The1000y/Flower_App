import 'package:flower_app/core/locale/locale_cubit.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/option_tile.dart';
import 'package:flower_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBody extends StatefulWidget {
  final UserEntity? user;
  final VoidCallback onEditProfile;
  final VoidCallback onNotification;
  final VoidCallback onLanguage;
  final VoidCallback onLogout;

  /// Unread notification count driving the header badge. The badge is hidden
  /// when this is null or zero instead of showing a stale hardcoded number.
  final int? unreadNotificationsCount;

  /// Invoked whenever the notification switch is toggled, so the owner can
  /// persist the value. Local state is only updated optimistically.
  final ValueChanged<bool>? onNotificationsChanged;

  const ProfileBody({
    super.key,
    required this.user,
    required this.onEditProfile,
    required this.onNotification,
    required this.onLanguage,
    required this.onLogout,
    this.unreadNotificationsCount,
    this.onNotificationsChanged,
  });

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildProfileInfo(),
          const SizedBox(height: 20),
          _buildProfileOptions(context),
          const SizedBox(height: 24),
          _buildVersion(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Badge is capped at `99+` so an arbitrarily large count cannot distort the
  /// header layout.
  int get _badgeCount => widget.unreadNotificationsCount ?? 0;

  String get _badgeLabel => _badgeCount > 99 ? '99+' : '$_badgeCount';

  /// Both the switch and the tile tap route through here so the new value is
  /// reported to the owner, which owns persistence. The local state flip is
  /// optimistic; a failed write is surfaced by the owner reverting it.
  void _setNotificationsEnabled(bool value) {
    if (_notificationsEnabled == value) return;
    setState(() => _notificationsEnabled = value);
    widget.onNotificationsChanged?.call(value);
  }

  /// `Switch.onChanged` hands the new value, so it is forwarded directly.
  void _toggleNotifications(bool value) => _setNotificationsEnabled(value);

  /// `ProfileOptionTile.onTap` is a `VoidCallback`, so the tile tap flips the
  /// current value instead of receiving a new one.
  void _flipNotifications() => _setNotificationsEnabled(!_notificationsEnabled);

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_florist,
                color: AppColors.pinkBase,
                size: 22,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.floweryAppbarTitle,
                style: const TextStyle(
                  color: AppColors.pinkBase,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: widget.onNotification,
                tooltip: l10n.notificationTitle,
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  size: 28,
                  color: Colors.black87,
                ),
              ),
              if (_badgeCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        _badgeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    final name = widget.user?.fullName ?? '';
    final email = widget.user?.email ?? '';
    // Resolved once into a local so the null-check and the usage cannot drift
    // apart, and no force-unwraps are needed.
    final photoUrl = widget.user?.photoUrl;
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
          child: hasPhoto
              ? null
              : const Icon(Icons.person, size: 40, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              onPressed: widget.onEditProfile,
              tooltip: AppLocalizations.of(context)!.editProfileTitle,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          email,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ProfileOptionTile(
          icon: Icons.receipt_long_outlined,
          title: l10n.myOrdersTitle,
          onTap: () {
            // orders route
          },
        ),
        ProfileOptionTile(
          icon: Icons.bookmark_border_outlined,
          title: l10n.savedAddressTitle,
          onTap: () {
            // saved address route
          },
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
        ProfileOptionTile(
          leading: SizedBox(
            height: 24,
            width: 40,
            child: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _notificationsEnabled,
                activeThumbColor: AppColors.pinkBase,
                onChanged: _toggleNotifications,
              ),
            ),
          ),
          title: l10n.notificationTitle,
          trailing: const Icon(
            Icons.chevron_right,
            size: 20,
            color: Colors.grey,
          ),
          onTap: _flipNotifications,
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
        ProfileOptionTile(
          icon: Icons.translate_outlined,
          title: l10n.language,
          // Scoped rebuild: only the trailing text reacts to locale changes,
          // instead of rebuilding the whole options column.
          trailing: BlocBuilder<LocaleCubit, Locale>(
            builder: (context, _) => Text(
              context.watch<LocaleCubit>().currentLanguageName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.pinkBase,
              ),
            ),
          ),
          onTap: widget.onLanguage,
        ),
        ProfileOptionTile(
          icon: Icons.info_outline,
          title: l10n.aboutUs,
          onTap: () {
            // about route
          },
        ),
        ProfileOptionTile(
          icon: Icons.description_outlined,
          title: l10n.termsAndConditionsAlt,
          onTap: () {
            // terms route
          },
        ),
        Divider(height: 20, thickness: 1, color: Colors.grey.shade100),
        ProfileOptionTile(
          icon: Icons.logout_outlined,
          title: l10n.logout,
          trailing: const Icon(
            Icons.logout_outlined,
            size: 20,
            color: Colors.black87,
          ),
          onTap: widget.onLogout,
        ),
      ],
    );
  }

  Widget _buildVersion(BuildContext context) {
    return Text(
      'v 6.3.0 - (446)',
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
