import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_event.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_state.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/saved_address_view_model.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/selected_address_cubit/selected_address_event.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/selected_address_cubit/selected_address_state.dart';
import 'package:flower_app/features/addresses/presentation/saved_address/manger/selected_address_cubit/selected_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomLocationData extends StatelessWidget {
  const CustomLocationData({super.key, required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    // Provide both view models to the widget tree so we don't have to call getIt in the UI
    return MultiBlocProvider(
      providers: [
        BlocProvider<SavedAddressViewModel>.value(
          value: getIt<SavedAddressViewModel>(),
        ),
        BlocProvider<SelectedAddressViewModel>.value(
          value: getIt<SelectedAddressViewModel>(),
        ),
      ],
      child: _CustomLocationDataView(textTheme: textTheme),
    );
  }
}

class _CustomLocationDataView extends StatefulWidget {
  const _CustomLocationDataView({required this.textTheme});

  final TextTheme textTheme;

  @override
  State<_CustomLocationDataView> createState() => _CustomLocationDataViewState();
}

class _CustomLocationDataViewState extends State<_CustomLocationDataView> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _targetKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    // Safely call events via context
    context.read<SavedAddressViewModel>().doEvent(LoadAddresses());
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _goToAddAddress() async {
    _removeOverlay();
    await Navigator.pushNamed(context, Routes.addAddress);
    if (mounted) {
      context.read<SavedAddressViewModel>().doEvent(LoadAddresses());
    }
  }

  // Pure UI sorting logic: sorts default addresses to the top.
  // Hardware GPS distance sorting should be handled by the Cubit/Domain layers.
  List<AddressEntity> _sortAddresses(List<AddressEntity> addresses) {
    final list = [...addresses];
    list.sort((a, b) => a.isDefault == b.isDefault ? 0 : (a.isDefault ? -1 : 1));
    return list;
  }

  void _selectAddress(AddressEntity address) {
    context.read<SelectedAddressViewModel>().onEvent(
      AddressSelectedEvent(
        addressId: address.id,
        label: '${address.addressLine} - ${address.area}',
      ),
    );
  }

  void _autoSelectIfNeeded(List<AddressEntity> addresses) {
    if (addresses.isEmpty) return;

    if (context.read<SelectedAddressViewModel>().state.addressId != null) return;

    final sorted = _sortAddresses(addresses);
    if (mounted && sorted.isNotEmpty) {
      _selectAddress(sorted.first);
    }
  }

  void _openDropdown(List<AddressEntity> addresses) {
    final sorted = _sortAddresses(addresses);
    if (!mounted) return;

    final renderBox = _targetKey.currentContext?.findRenderObject() as RenderBox?;
    final targetHeight = renderBox?.size.height ?? 40;

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeOverlay,
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, targetHeight + 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 240, maxWidth: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...sorted.map(
                            (address) => ListTile(
                          dense: true,
                          title: Text(
                            '${address.addressLine} - ${address.area}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            _selectAddress(address);
                            _removeOverlay();
                          },
                        ),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.add_location_alt_outlined,
                          color: AppColors.pinkBase,
                        ),
                        title: const Text(AppStrings.addNewAddress),
                        onTap: _goToAddAddress,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  String _fallbackLabel(List<AddressEntity> addresses) {
    final defaultAddress = addresses.firstWhere(
          (a) => a.isDefault,
      orElse: () => addresses.first,
    );
    return '${defaultAddress.addressLine} - ${defaultAddress.area}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SavedAddressViewModel, SavedAddressState>(
      listenWhen: (previous, current) =>
      previous.addressesState.data != current.addressesState.data,
      listener: (context, state) {
        _autoSelectIfNeeded(state.addressesState.data ?? const <AddressEntity>[]);
      },
      builder: (context, savedState) {
        final addresses = savedState.addressesState.data ?? const <AddressEntity>[];

        return BlocBuilder<SelectedAddressViewModel, SelectedAddressState>(
          builder: (context, selectedState) {
            final isEmpty = addresses.isEmpty;
            final label = isEmpty
                ? AppStrings.addNewAddress
                : (selectedState.label ?? _fallbackLabel(addresses));

            return CompositedTransformTarget(
              link: _layerLink,
              child: InkWell(
                key: _targetKey,
                onTap: () {
                  if (isEmpty) {
                    _goToAddAddress();
                    return;
                  }
                  if (_overlayEntry != null) {
                    _removeOverlay();
                  } else {
                    _openDropdown(addresses);
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: AppColors.black100),
                    Flexible(
                      child: Text(
                        isEmpty
                            ? ' ${AppStrings.addNewAddress}'
                            : ' ${AppStrings.deliverToPrefix} $label',
                        style: widget.textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isEmpty)
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.pinkBase,
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}