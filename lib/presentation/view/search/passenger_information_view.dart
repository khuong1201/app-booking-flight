import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/constants.dart';
import '../../../data/passenger_infor_model.dart';
import '../../viewmodel/searchmodel/passenger_info_viewmodel.dart';

class PassengerInfoScreen extends StatelessWidget {
  final int adultCount;
  final int childCount;
  final int infantCount;
  final String ticketPrice;
  final String routerTrip; // Add this
  final String logoAirPort; // Add this

  const PassengerInfoScreen({
    super.key,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    required this.ticketPrice,
    required this.routerTrip,
    required this.logoAirPort,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PassengerInfoViewModel(
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
      ),
      child: _PassengerInfoBody(
        ticketPrice: ticketPrice,
        logoAirPort: logoAirPort,
        routerTrip: routerTrip,
      ),
    );
  }
}

class _PassengerInfoBody extends StatefulWidget {
  final String ticketPrice;
  final String logoAirPort;
  final String routerTrip;
  const _PassengerInfoBody({
    super.key,
    required this.ticketPrice,
    required this.logoAirPort,
    required this.routerTrip,
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

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PassengerInfoViewModel>(context, listen: false);
    _lastNameControllers = List.generate(vm.allPassengers.length,
            (index) => TextEditingController(text: vm.allPassengers[index].lastName));
    _firstNameControllers = List.generate(vm.allPassengers.length,
            (index) => TextEditingController(text: vm.allPassengers[index].firstName));
    _dobControllers = List.generate(
        vm.allPassengers.length,
            (index) => TextEditingController(
          text: vm.allPassengers[index].dateOfBirth != null
              ? DateFormat('dd/MM/yyyy').format(vm.allPassengers[index].dateOfBirth!)
              : '',
        ));
    _documentNumberControllers = List.generate(vm.allPassengers.length,
            (index) => TextEditingController(text: vm.allPassengers[index].documentNumber));
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
    return Consumer<PassengerInfoViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactInfoSection(vm),
                const SizedBox(height: 24),
                _buildPassengerInfoSection(vm),
                const SizedBox(height: 16),
                _buildSaveContactSwitch(vm),
                const SizedBox(height: 24),
                _buildTotalAmountExpansionTile(vm),
                const SizedBox(height: 16),
                _buildContinueButton(vm),
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
          onPressed: null, // No action specified
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
        _buildSectionTitle('CONTACT INFORMATION'),
        _buildDescription(
          'Contact information will be used to confirm booking or receive notification from airlines/ agency in case the flight changes.',
        ),
        const SizedBox(height: 16),
        _buildTextField('Phone number', _phoneController,
                (val) => vm.updateContactInfo(phoneNumber: val)),
        const SizedBox(height: 12),
        _buildTextField('Email', _emailController, (val) => vm.updateContactInfo(email: val)),
      ],
    );
  }

  Widget _buildPassengerInfoSection(PassengerInfoViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('PASSENGER INFORMATION'),
        _buildDescription(
          'You must enter your full name with the same order as one in your Passport/ ID card/ TCR for adult or Children’s Birth certificate.',
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.allPassengers.length,
          itemBuilder: (context, index) {
            final passenger = vm.allPassengers[index];
            return _buildPassengerCard(index, passenger, vm);
          },
        ),
      ],
    );
  }

  Widget _buildSaveContactSwitch(PassengerInfoViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Save passenger contact', style: TextStyle(fontWeight: FontWeight.w500)),
        Switch(
          value: vm.saveContactInfo,
          onChanged: (value) => vm.toggleSaveContactInfo(value),
        ),
      ],
    );
  }

  Widget _buildTotalAmountExpansionTile(PassengerInfoViewModel vm) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('${widget.ticketPrice}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
      children: <Widget>[
        Container(
          width: 379,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Color(0xFFE3E8F7)
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
                          widget.logoAirPort,
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        Text(widget.routerTrip),
                      ],
                    ),
                    Text('${widget.ticketPrice}'),
                  ],
                ),
              ),
              SizedBox(height: 2,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  thickness: 1,
                  color: AppColors.neutralColor,
                ),
              ),
              SizedBox(height: 2,),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ticket price'),
                    Text('${widget.ticketPrice}'),
                  ],
                ),
              ),
            ],
          )
        ),
        SizedBox(height: 12,),
      ],

    );
  }

  Widget _buildContinueButton(PassengerInfoViewModel vm) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          vm.logInfo();
          // Add navigation or further action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: const Text('Continue'),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  Widget _buildDescription(String text) {
    return Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey));
  }

  Widget _buildTextField(
      String label, TextEditingController controller, ValueChanged<String> onChanged) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildPassengerCard(
      int index, Passenger passenger, PassengerInfoViewModel vm) {
    final lastNameController = _lastNameControllers[index];
    final firstNameController = _firstNameControllers[index];
    final dobController = _dobControllers[index];
    final documentNumberController = _documentNumberControllers[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          initiallyExpanded: true,
          title: Text('Passenger ${index + 1} - ${passenger.type}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          children: [
            const SizedBox(height: 12),
            _buildTextField('Last name', lastNameController,
                    (val) => vm.updatePassenger(index: index, lastName: val)),
            const SizedBox(height: 12),
            _buildTextField('Middle & First name', firstNameController,
                    (val) => vm.updatePassenger(index: index, firstName: val)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
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
                Expanded(
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

  Widget _buildGenderDropdown(
      Passenger passenger, int index, PassengerInfoViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender'),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          value: passenger.gender,
          items: ['Male', 'Female'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (val) => vm.updatePassenger(index: index, gender: val),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(Passenger passenger, int index,
      PassengerInfoViewModel vm, TextEditingController dobController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of Birth'),
        TextField(
          controller: dobController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'DD/MM/YYYY',
          ),
          onChanged: (val) {
            vm.updatePassenger(index: index, dateOfBirthRaw: val);
          },
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: passenger.dateOfBirth ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
              dobController.text = formattedDate;
              vm.updatePassenger(index: index, dateOfBirth: pickedDate);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDocumentTypeDropdown(
      Passenger passenger, int index, PassengerInfoViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Passport/ID'),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          value: passenger.documentType,
          items: ['ID Card', 'Passport'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (val) => vm.updatePassenger(index: index, documentType: val),
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
          controller: documentNumberController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input Number',
          ),
          onChanged: (val) => vm.updatePassenger(index: index, documentNumber: val),
        ),
      ],
    );
  }
}