import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/option_tile.dart';
import 'package:flutter/material.dart';

/// The "notifications" row of the profile screen: a switch plus a navigable
/// tile.
///
/// The switch is the stateful part, so it lives in its own widget instead of
/// making the whole profile body stateful for one boolean. The new value is
/// reported through [onChanged]; the parent owns persistence, and a failed
/// write is surfaced by the parent reverting the value.
class NotificationSwitchTile extends StatefulWidget {
  const NotificationSwitchTile({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  final String title;

  /// Current value of the switch.
  final bool value;

  /// Invoked with the new value whenever the switch is toggled, either by the
  /// switch itself or by tapping the row. The owner owns persistence and the
  /// local state is only updated optimistically.
  final ValueChanged<bool>? onChanged;

  @override
  State<NotificationSwitchTile> createState() => _NotificationSwitchTileState();
}

class _NotificationSwitchTileState extends State<NotificationSwitchTile> {
  late bool _value = widget.value;

  @override
  void didUpdateWidget(NotificationSwitchTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    // The parent is the source of truth (it may have reverted a failed write),
    // so mirror its value instead of keeping the optimistic local one.
    if (widget.value != oldWidget.value) {
      _value = widget.value;
    }
  }

  /// Both the switch and the tile tap route through here so the new value is
  /// reported to the owner, which owns persistence.
  void _setValue(bool value) {
    if (_value == value) return;

    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  /// `Switch.onChanged` hands the new value, so it is forwarded directly.
  void _onSwitchChanged(bool value) => _setValue(value);

  /// `ProfileOptionTile.onTap` is a `VoidCallback`, so the row tap flips the
  /// current value instead of receiving a new one.
  void _onTap() => _setValue(!_value);

  @override
  Widget build(BuildContext context) {
    return ProfileOptionTile(
      leading: SizedBox(
        height: 24,
        width: 40,
        child: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: _value,
            activeThumbColor: AppColors.pinkBase,
            onChanged: _onSwitchChanged,
          ),
        ),
      ),
      title: widget.title,
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: _onTap,
    );
  }
}
