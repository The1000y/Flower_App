import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../../config/di/di.dart';
import '../../../../../config/routing/routes.dart';
import '../../../../../core/shared/app_widgets/custom_button.dart';
import '../../../../../core/themes/app_colors/app_color.dart';
import '../../../domain/entities/address_entity.dart';
import '../manger/saved_address_event.dart';
import '../manger/saved_address_state.dart';
import '../manger/selected_address_cubit/selected_address_event.dart';
import '../manger/selected_address_cubit/selected_address_view_model.dart';
import 'widgets/address_card.dart';

class SavedAddressView extends StatelessWidget {
  const SavedAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SavedAddressViewModel>()..onEvent(LoadAddresses()),
      child: const _SavedAddressBody(),
    );
  }
}

class _SavedAddressBody extends StatefulWidget {
  const _SavedAddressBody();

  @override
  State<_SavedAddressBody> createState() => _SavedAddressBodyState();
}

class _SavedAddressBodyState extends State<_SavedAddressBody> {

  final _listKey = GlobalKey<AnimatedListState>();


  final List<AddressEntity> _addresses = [];

  Future<void> _goToAddAddress(BuildContext context, {AddressEntity? existing}) async {
    final result = await Navigator.of(context).pushNamed(
      Routes.addAddress,
      arguments: existing,
    );
    if (result != null && context.mounted) {
      context.read<SavedAddressViewModel>().onEvent(LoadAddresses());
    }
  }


  void _syncList(List<AddressEntity> newAddresses) {
    for (var i = _addresses.length - 1; i >= 0; i--) {
      final stillExists = newAddresses.any((a) => a.id == _addresses[i].id);
      if (!stillExists) {
        final removed = _addresses.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
              (context, animation) => _buildAnimatedCard(removed, animation),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    for (var i = 0; i < newAddresses.length; i++) {
      final address = newAddresses[i];
      final existingIndex = _addresses.indexWhere((a) => a.id == address.id);
      if (existingIndex == -1) {
        _addresses.insert(i, address);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 300));
      } else {
        _addresses[existingIndex] = address;
      }
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
          onEdit: () => _goToAddAddress(context, existing: address),
          onDelete: () =>
              context.read<SavedAddressViewModel>().onEvent(DeleteAddressPressed(address.id)),
          onSelect: () {
            context.read<SelectedAddressViewModel>().onEvent(
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Saved address'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: BlocConsumer<SavedAddressViewModel, SavedAddressState>(
                  // The listener is where the animation actually gets
                  // triggered — it runs once per state change, before the
                  // builder rebuilds, so _addresses is already correct by
                  // the time the AnimatedList below reads it.
                  listener: (context, state) {
                    if (state is SavedAddressError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    } else if (state is SavedAddressLoaded) {
                      _syncList(state.addresses);
                    }
                  },
                  builder: (context, state) {
                    // Only show the big spinner on the very first load —
                    // once we have data, a delete/add reload shouldn't
                    // blank the screen, the animation communicates the
                    // change instead.
                    final firstLoad = state is SavedAddressInitial ||
                        (state is SavedAddressLoading && _addresses.isEmpty);
                    if (firstLoad) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_addresses.isEmpty) {
                      return Center(
                        child: Text(
                          'No saved addresses yet',
                          style: TextStyle(color: AppColors.gray, fontSize: 14.sp),
                        ),
                      );
                    }
                    return AnimatedList(
                      key: _listKey,
                      initialItemCount: _addresses.length,
                      itemBuilder: (context, index, animation) {
                        return _buildAnimatedCard(_addresses[index], animation);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),
              CustomButton(
                text: 'Add new address',
                isEnabled: true,
                enabledColor: AppColors.pinkBase,
                onPressed: () => _goToAddAddress(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}