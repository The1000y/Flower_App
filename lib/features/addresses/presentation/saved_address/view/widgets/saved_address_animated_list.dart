import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/di/di.dart';
import '../../../../../../config/routing/routes.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../manger/saved_address_event.dart';
import '../../manger/saved_address_view_model.dart';
import '../../manger/selected_address_cubit/selected_address_event.dart';
import '../../manger/selected_address_cubit/selected_address_view_model.dart';
import 'address_card.dart';

class SavedAddressAnimatedList extends StatefulWidget {
  final List<AddressEntity> addresses;
  const SavedAddressAnimatedList({super.key, required this.addresses});

  @override
  State<SavedAddressAnimatedList> createState() => _SavedAddressAnimatedListState();
}

class _SavedAddressAnimatedListState extends State<SavedAddressAnimatedList> {
  final _listKey = GlobalKey<AnimatedListState>();
  final List<AddressEntity> _internalList = [];

  @override
  void didUpdateWidget(covariant SavedAddressAnimatedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.addresses != oldWidget.addresses) {
      _syncList(widget.addresses);
    }
  }

  @override
  void initState() {
    super.initState();
    _internalList.addAll(widget.addresses);
  }

  void _syncList(List<AddressEntity> newAddresses) {
    for (var i = _internalList.length - 1; i >= 0; i--) {
      if (!newAddresses.any((a) => a.id == _internalList[i].id)) {
        final removed = _internalList.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
              (context, animation) => _buildAnimatedCard(removed, animation),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    for (var i = 0; i < newAddresses.length; i++) {
      final address = newAddresses[i];
      final existingIndex = _internalList.indexWhere((a) => a.id == address.id);
      if (existingIndex == -1) {
        _internalList.insert(i, address);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 300));
      } else {
        _internalList[existingIndex] = address;
      }
    }
  }

  Future<void> _goToEdit(AddressEntity address) async {
    final result = await Navigator.of(context).pushNamed(
      Routes.addAddress,
      arguments: address,
    );
    if (result != null && mounted) {
      context.read<SavedAddressViewModel>().onEvent(LoadAddresses());
    }
  }

  Widget _buildAnimatedCard(AddressEntity address, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: animation,
        child: AddressCard(
          address: address,
          onEdit: () => _goToEdit(address),
          onDelete: () => context.read<SavedAddressViewModel>().onEvent(DeleteAddressPressed(address.id)),
          onSelect: () {
            getIt<SelectedAddressViewModel>().onEvent(
              AddressSelectedEvent(
                addressId: address.id,
                label: '${address.addressLine} - ${address.area}',
              ),
            );
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _internalList.length,
      itemBuilder: (context, index, animation) {
        return _buildAnimatedCard(_internalList[index], animation);
      },
    );
  }
}