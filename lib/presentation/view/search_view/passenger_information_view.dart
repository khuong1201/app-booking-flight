import 'dart:convert';
import 'package:booking_flight/presentation/view/purcharse_services_view/addition_services_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:booking_flight/core/constants/app_colors.dart';
import 'package:booking_flight/core/constants/text_styles.dart';
import 'package:booking_flight/data/passenger_infor_model.dart';
import 'package:booking_flight/data/search_flight_data.dart';
import 'package:booking_flight/presentation/viewmodel/home/detail_flight_tickets_view_model.dart';
import 'package:booking_flight/presentation/viewmodel/search_viewmodel/passenger_info_viewmodel.dart';
import 'package:booking_flight/data/SearchViewModel.dart';

class PassengerInfoScreen extends StatelessWidget {
  final DetailFlightTicketsViewModel detailViewModel;
  final FlightData? flightData;
  final SearchViewModel? searchViewModel;

  const PassengerInfoScreen({
    super.key,
    required this.detailViewModel,
    this.flightData,
    this.searchViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: detailViewModel),
        ChangeNotifierProvider(
          create: (_) => PassengerInfoViewModel(
            adultCount: detailViewModel.passengerAdults,
            childCount: detailViewModel.passengerChilds,
            infantCount: detailViewModel.passengerInfants,
            detailViewModel: detailViewModel,
          ),
        ),
      ],
      child: _PassengerInfoBody(
        flightData: flightData,
        searchViewModel: searchViewModel,
      ),
    );
  }
}

class _PassengerInfoBody extends StatefulWidget {
  final FlightData? flightData;
  final SearchViewModel? searchViewModel;

  const _PassengerInfoBody({
    this.flightData,
    this.searchViewModel,
  });

  @override
  State<_PassengerInfoBody> createState() => _PassengerInfoBodyState();
}

class _PassengerInfoBodyState extends State<_PassengerInfoBody> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  late final List<TextEditingController> _lastNameControllers;
  late final List<TextEditingController> _firstNameControllers;
  late final List<TextEditingController> _dobControllers;
  late final List<TextEditingController> _documentNumberControllers;
  bool _showValidationErrors = false;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PassengerInfoViewModel>(context, listen: false);
    _phoneController.text = vm.phoneNumber;
    _emailController.text = vm.email;
    _lastNameControllers = List.generate(
      vm.allPassengers.length,
          (index) => TextEditingController(text: vm.allPassengers[index].lastName),
    );
    _firstNameControllers = List.generate(
      vm.allPassengers.length,
          (index) => TextEditingController(text: vm.allPassengers[index].firstName),
    );
    _dobControllers = List.generate(
      vm.allPassengers.length,
          (index) => TextEditingController(
        text: vm.allPassengers[index].dateOfBirth != null
            ? DateFormat('dd/MM/yyyy').format(vm.allPassengers[index].dateOfBirth!)
            : '',
      ),
    );
    _documentNumberControllers = List.generate(
      vm.allPassengers.length,
          (index) => TextEditingController(text: vm.allPassengers[index].documentNumber),
    );

    vm.addListener(() {
      if (_phoneController.text != vm.phoneNumber) {
        _phoneController.text = vm.phoneNumber;
      }
      if (_emailController.text != vm.email) {
        _emailController.text = vm.email;
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    for (final controller in _lastNameControllers) {
      controller.dispose();
    }
    for (final controller in _firstNameControllers) {
      controller.dispose();
    }
    for (final controller in _dobControllers) {
      controller.dispose();
    }
    for (final controller in _documentNumberControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PassengerInfoViewModel, DetailFlightTicketsViewModel>(
      builder: (context, vm, detailVM, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFFE3E8F7),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('CONTACT INFORMATION'),
                              const SizedBox(height: 8),
                              _buildDescription(
                                'Contact information will be used to confirm booking or receive notification from airlines/agency in case the flight changes.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _buildContactInfoSection(vm),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('PASSENGER INFORMATION'),
                              const SizedBox(height: 8),
                              _buildDescription(
                                'You must enter your full name with the same order as one in your Passport/ID card/TCR for adult or Children’s Birth certificate.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _buildPassengerInfoSection(vm),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: _buildSaveContactSwitch(vm),
                        ),
                        const SizedBox(height: 180),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTotalAmountExpansionTile(vm, detailVM),
                        _buildContinueButton(vm, detailVM),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Text(
        'PASSENGER INFORMATION',
        style: AppTextStyle.body3.copyWith(color: Colors.white),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 16),
          ),
        ),
      ),
      actions: const [
        TextButton(
          onPressed: null,
          child: Text('Help?', style: TextStyle(color: Colors.white)),
        ),
        SizedBox(width: 12),
      ],
    );
  }

  Widget _buildContactInfoSection(PassengerInfoViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone number',
          style: AppTextStyle.paragraph1.copyWith(color: AppColors.neutralColor),
        ),
        _buildTextField(
          'Phone number',
          _phoneController,
              (val) => vm.updateContactInfo(phoneNumber: val),
          validator: vm.validatePhoneNumber,
        ),
        const SizedBox(height: 12),
        Text(
          'Email',
          style: AppTextStyle.paragraph1.copyWith(color: AppColors.neutralColor),
        ),
        _buildTextField(
          'Email',
          _emailController,
              (val) => vm.updateContactInfo(email: val),
          validator: vm.validateEmail,
        ),
      ],
    );
  }

  Widget _buildPassengerInfoSection(PassengerInfoViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: vm.allPassengers.asMap().entries.map((entry) {
        return _buildPassengerCard(entry.key, entry.value, vm);
      }).toList(),
    );
  }

  Widget _buildSaveContactSwitch(PassengerInfoViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Save passenger contact',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Switch(
          value: vm.saveContactInfo,
          onChanged: (value) => vm.toggleSaveContactInfo(value),
        ),
      ],
    );
  }

  Widget _buildTotalAmountExpansionTile(PassengerInfoViewModel vm, DetailFlightTicketsViewModel detailVM) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            detailVM.totalPrice,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Color(0xFFE3E8F7),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          detailVM.airlineLogo.isNotEmpty ? detailVM.airlineLogo : 'assets/default_logo.png',
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        Text(detailVM.routeTitle),
                      ],
                    ),
                    Text(detailVM.price),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  thickness: 1,
                  color: AppColors.neutralColor,
                ),
              ),
              const SizedBox(height: 2),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ticket price'),
                    Text(detailVM.totalPrice),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildContinueButton(PassengerInfoViewModel vm, DetailFlightTicketsViewModel detailVM) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            _showValidationErrors = true;
          });

          String? errorMessage;
          for (int i = 0; i < vm.allPassengers.length; i++) {
            final error = vm.validatePassenger(vm.allPassengers[i]);
            if (error != null) {
              errorMessage = 'Passenger ${i + 1}: $error';
              break;
            }
          }
          if (errorMessage == null) {
            if (vm.validatePhoneNumber(vm.phoneNumber) != null) {
              errorMessage = vm.validatePhoneNumber(vm.phoneNumber);
            } else if (vm.validateEmail(vm.email) != null) {
              errorMessage = vm.validateEmail(vm.email);
            }
          }

          if (errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
            return;
          }

          setState(() {
            _showValidationErrors = false;
          });

          vm.logInfo();
          final jsonOutput = jsonEncode(vm.toJson());
          debugPrint('Passenger Info JSON: $jsonOutput');
          await vm.saveContactInfoIfNeeded();

          if (widget.flightData == null || widget.searchViewModel == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Flight data or search view model is missing.'),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdditionalServicesScreen(
                flightData: widget.flightData!,
                searchViewModel: widget.searchViewModel!,
                passengerInfoViewModel: vm,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          'Continue',
          style: AppTextStyle.body3.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Text(
      text,
      style: AppTextStyle.caption1.copyWith(color: Colors.grey),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      ValueChanged<String> onChanged, {
        String? Function(String?)? validator,
      }) {
    return TextField(
      style: AppTextStyle.body2.copyWith(
        color: controller.text.isNotEmpty ? AppColors.primaryColor : const Color(0xFF9C9C9C),
      ),
      controller: controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: label,
        border: const OutlineInputBorder(),
        errorText: _showValidationErrors && validator != null ? validator(controller.text) : null,
        errorStyle: const TextStyle(color: AppColors.secondaryColor),
      ),
      onChanged: (value) {
        onChanged(value);
        if (_showValidationErrors) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildPassengerCard(int index, Passenger passenger, PassengerInfoViewModel vm) {
    final lastNameController = _lastNameControllers[index];
    final firstNameController = _firstNameControllers[index];
    final dobController = _dobControllers[index];
    final documentNumberController = _documentNumberControllers[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          initiallyExpanded: true,
          title: Text(
            'Passenger ${index + 1} - ${passenger.type}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Last name'),
            ),
            _buildTextField(
              'Example: NGUYEN',
              lastNameController,
                  (val) => vm.updatePassenger(index: index, lastName: val),
              validator: (val) => val == null || val.isEmpty ? 'Last name is required' : null,
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Middle & First name'),
            ),
            _buildTextField(
              'Middle & First name',
              firstNameController,
                  (val) => vm.updatePassenger(index: index, firstName: val),
              validator: (val) => val == null || val.isEmpty ? 'First name is required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: _buildGenderDropdown(passenger, index, vm),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateOfBirthField(passenger, index, vm, dobController),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: _buildDocumentTypeDropdown(passenger, index, vm),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDocumentNumberField(documentNumberController, index, vm),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(Passenger passenger, int index, PassengerInfoViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender'),
        DropdownButtonFormField<String>(
          style: AppTextStyle.body2.copyWith(color: AppColors.primaryColor),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Choose',
            errorText: _showValidationErrors && passenger.gender == null ? 'Gender is required' : null,
            errorStyle: const TextStyle(color: AppColors.secondaryColor),
          ),
          value: passenger.gender,
          items: ['Male', 'Female'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (val) {
            vm.updatePassenger(index: index, gender: val);
            if (_showValidationErrors) {
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(
      Passenger passenger, int index, PassengerInfoViewModel vm, TextEditingController dobController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of Birth'),
        TextField(
          style: AppTextStyle.body2.copyWith(color: AppColors.primaryColor),
          controller: dobController,
          readOnly: true,
          enableInteractiveSelection: false,
          keyboardType: TextInputType.none,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'DD/MM/YYYY',
            errorText: _showValidationErrors && passenger.dateOfBirth == null
                ? 'Date of birth is required'
                : null,
            errorStyle: const TextStyle(color: AppColors.secondaryColor),
          ),
          onTap: () {
            vm.selectDateOfBirth(
              context: context,
              passengerIndex: index,
              passenger: passenger,
              dobController: dobController,
            ).then((_) {
              if (_showValidationErrors) {
                setState(() {});
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildDocumentTypeDropdown(Passenger passenger, int index, PassengerInfoViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Passport/ID'),
        DropdownButtonFormField<String>(
          style: AppTextStyle.body3.copyWith(color: AppColors.primaryColor),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'ID Card',
          ),
          value: passenger.documentType,
          items: ['ID Card', 'Passport'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (val) {
            vm.updatePassenger(index: index, documentType: val);
            if (_showValidationErrors) {
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Widget _buildDocumentNumberField(
      TextEditingController documentNumberController, int index, PassengerInfoViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Number'),
        TextField(
          style: AppTextStyle.body2.copyWith(
            color: documentNumberController.text.isNotEmpty
                ? AppColors.primaryColor
                : const Color(0xFF9C9C9C),
          ),
          controller: documentNumberController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Input Number',
            errorText: _showValidationErrors && documentNumberController.text.isEmpty
                ? 'Document number is required'
                : null,
            errorStyle: const TextStyle(color: AppColors.secondaryColor),
          ),
          onChanged: (val) {
            vm.updatePassenger(index: index, documentNumber: val);
            if (_showValidationErrors) {
              setState(() {});
            }
          },
        ),
      ],
    );
  }
}