import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../viewmodel/purchase_services_viewmodel/additional_services_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdditionalServicesScreen(),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.primaryColor,
    title: Text(
      'Purchase Additional Services',
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
  );
}

class AdditionalServicesScreen extends StatelessWidget {
  const AdditionalServicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdditionalServicesViewModel(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SGN → HAN", style: AppTextStyle.paragraph2.copyWith(color: AppColors.neutralColor)),
                  SizedBox(height: 8),
                  Text("Tue, April 01 • 05:00 - 07:10", style: AppTextStyle.paragraph2.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("VietJet Air (Eco)", style: AppTextStyle.paragraph2.copyWith(color: Colors.black)),
                      IconButton(
                        icon: Icon(Icons.expand_more),
                        onPressed: () {
                          // Hiển thị thông tin chi tiết khi nhấn nút
                          showTicketDetailsSheet(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  SizedBox(height: 20),
                  // Additional Services Section
                  Text("Additional Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        ServiceTile(icon: Icons.luggage, title: "Checked Baggage"),
                        Divider(),
                        ServiceTile(icon: Icons.event_seat, title: "Seat Selection"),
                        Divider(),
                        ServiceTile(icon: Icons.fastfood, title: "Meal"),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Insurance Services Section
                  Text("Insurance Services", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Consumer<AdditionalServicesViewModel>(
                    builder: (context, viewModel, child) => Card(
                      elevation: 2,
                      child: CheckboxListTile(
                        value: viewModel.comprehensiveInsurance,
                        onChanged: (value) => viewModel.toggleComprehensiveInsurance(value!),
                        title: Text("Comprehensive Travel Insurance"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Receive immediately 888,000 VND / person / trip for flights delayed over consecutive hours."),
                            Text("Protection against accident risks, lost luggage."),
                            Text("Property, compensation up to 200,000,000 VND."),
                            SizedBox(height: 5),
                            Text("35,000 vnd / passenger / trip", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Consumer<AdditionalServicesViewModel>(
                    builder: (context, viewModel, child) => Card(
                      elevation: 2,
                      child: CheckboxListTile(
                        value: viewModel.flightDelayInsurance,
                        onChanged: (value) => viewModel.toggleFlightDelayInsurance(value!),
                        title: Text("Flight Delay Insurance"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Receive immediately 500,000 VND / person / trip for flights delayed over 2 consecutive hours."),
                            SizedBox(height: 5),
                            Text("35,000 vnd / passenger / trip", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Total and Continue Button
            Consumer<AdditionalServicesViewModel>(
              builder: (context, viewModel, child) => Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.withOpacity(0.2))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("${viewModel.totalAmount.toStringAsFixed(0)} vnd", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("Includes taxes and fees", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => viewModel.continueAction(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Continue", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị thông tin chi tiết khi nhấn vào nút
  void showTicketDetailsSheet(BuildContext context) {
    // Hiển thị một BottomSheet hoặc một màn hình chi tiết ở đây
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Ticket Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                // Thêm các thông tin chi tiết vé ở đây
                Text("Details about flight SGN → HAN will go here."),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng BottomSheet
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ServiceTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: IconButton(
        icon: Icon(Icons.add_circle, color: Colors.blue),
        onPressed: () {
          Provider.of<AdditionalServicesViewModel>(context, listen: false).addService(title);
        },
      ),
    );
  }
}
