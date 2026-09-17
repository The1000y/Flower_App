import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/themes/app_colors/app_color.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/addresses/presentation/view/add_address/address_view.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_cubit.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_state.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/build_sections.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_header.dart';
import 'package:flower_app/features/commerce/presentation/home/view/widgets/custom_location-data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.controller});
  final PersistentTabController controller;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<HomeCubit>().doEvent(GetSectionEvent());
    context.read<AddressCubit>().doEvent(FetchUserAddressesEvent());
  });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
   return  Scaffold(
        backgroundColor: AppColors.whiteBase,
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final sectionsState = state.sectionsState;

                if (sectionsState.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (sectionsState.errorMessage.isNotEmpty) {
                  return Center(child: Text(sectionsState.errorMessage));
                }
                final sections = sectionsState.data ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomHeaderHomeView(),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<AddressCubit, AddressState>(
                        builder: (context, state) {
                          if (state.selectedAddress == null &&
                              state.locationState.data != null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.read<AddressCubit>().doEvent(
                                SetClosestAddressEvent(
                                  currentLocation: state.locationState.data!,
                                ),
                              );
                            });
                          }

                          return CustomLocationData(
                            textTheme: textTheme,
                            selectedAddress: state.selectedAddress,
                            addresses: state.userAddresses,
                            onAddNewAddressTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: getIt.get<AddressCubit>(),
                                    child: AddressView(),
                                  ),
                                ),
                              );
                            },
                            onAddressChanged: (newAddress) {
                              context.read<AddressCubit>().doEvent(
                                SelectAddressEvent(selectedAddress: newAddress),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      children: List.generate(sections.length, (index) {
                        final section = sections[index];
                        return BuildSections(
                          context,
                          widget.controller,
                        ).buildSection(section, textTheme: textTheme);
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    
  }
}
