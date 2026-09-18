import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/routing/routes.dart';
import '../../../../../../core/constants/app_strings/app_strings.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../manager/cubit/add_address_cubit.dart';
import '../../../manager/cubit/address_events.dart';
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
      context.read<AddressCubit>().doEvent(FetchUserAddressesEvent());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.addressUpdatedSuccess)),
      );
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
          onDelete: () =>
              context.read<AddressCubit>().doEvent(DeleteAddressEvent(id: address.id)),
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