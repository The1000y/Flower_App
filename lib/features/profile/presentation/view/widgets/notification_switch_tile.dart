import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/profile/presentation/view/widgets/option_tile.dart';
import 'package:flutter/material.dart';

class NotificationSwitchTile extends StatefulWidget {
  const NotificationSwitchTile({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  final String title;

  final bool value;

  final ValueChanged<bool>? onChanged;

  @override
  State<NotificationSwitchTile> createState() => _NotificationSwitchTileState();
}

class _NotificationSwitchTileState extends State<NotificationSwitchTile> {
  late bool _value = widget.value;

  @override
  void didUpdateWidget(NotificationSwitchTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      _value = widget.value;
    }
  }

  void _setValue(bool value) {
    if (_value == value) return;

    setState(() => _value = value);
    widget.onChanged?.call(value);
  }

  void _onSwitchChanged(bool value) => _setValue(value);

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
