import 'dart:async';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/view/widgets/cuastom_address_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  late Completer<GoogleMapController> controllerMap =
      Completer<GoogleMapController>();
  bool isMapScroll = true;

  @override
  Widget build(BuildContext context) {
    var testTheme = Theme.of(context).textTheme;
    var addressCubit = getIt.get<AddressCubit>();
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
        create: (context) => addressCubit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            physics: isMapScroll
                ? const ScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: CustomAddressBody(
              controllerMap: controllerMap,
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
