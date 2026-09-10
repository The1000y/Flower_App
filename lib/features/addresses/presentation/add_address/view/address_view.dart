import 'dart:async';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/presentation/add_address/view/widgets/cuastom_address_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entities/address_entity.dart';
import '../manager/cubit/add_address_cubit.dart';

class AddressView extends StatefulWidget {
  final AddressEntity? editingAddress;

  const AddressView({super.key, this.editingAddress});
  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  late Completer<GoogleMapController> controllerMap =
  Completer<GoogleMapController>();
  bool isMapScroll = true;


  @override
  dispose() {
    super.dispose();
    controllerMap = Completer<GoogleMapController>();
  }

  @override
  Widget build(BuildContext context) {
    var testTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        // leadingWidth: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        titleSpacing: 0,
        title: Text(AppStrings.addressTitle, style: testTheme.titleLarge),
      ),
      body: BlocProvider<AddressCubit>(
        create: (context) => getIt.get<AddressCubit>(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            physics: isMapScroll
                ? const ScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: CustomAddressBody(
              controllerMap: controllerMap,
              editingAddress: widget.editingAddress,
              isMapScroll: (scroll) {
                setState(() {
                  isMapScroll = scroll;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}