import 'package:beta_pm/controllers/MaintainerContoller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/Maintainer.dart';

class MaintainerPage extends StatelessWidget {
  final String maintenanceId; // Maintenance ID

  final MaintainerController controller = Get.put(MaintainerController());
  final RxList<String> selectedMaintainers = <String>[].obs;
  MaintainerPage({Key? key, required this.maintenanceId}) : super(key: key);

  // final TextEditingController scheduledDateController = TextEditingController();
  // final TextEditingController estimatedCompletionTimeController =
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Maintainers')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.maintainers.isEmpty) {
          return Center(child: Text('No maintainers found'));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.maintainers.length,
                  itemBuilder: (context, index) {
                    final maintainer = controller.maintainers[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Obx(
                          () => Checkbox(
                            value: selectedMaintainers.contains(maintainer.id),
                            onChanged: (bool? value) {
                              if (value == true) {
                                selectedMaintainers.add(maintainer.id);
                              } else {
                                selectedMaintainers.remove(maintainer.id);
                              }
                            },
                          ),
                        ),
                        title: Text(maintainer.name),
                        subtitle: Text(maintainer.email),
                        trailing: Text(maintainer.status),
                      ),
                    );
                  },
                ),
              ),
              Obx(
                () => ElevatedButton(
                  onPressed:
                      selectedMaintainers.isEmpty
                          ? null
                          : () => _onPrepareButtonPressed(context),
                  child: Text('Prepare'),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  void _onPrepareButtonPressed(BuildContext context) {
    DateTime? scheduledDate;
    DateTime? estimatedCompletionDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Scheduled Date: ${scheduledDate != null ? '${scheduledDate?.toLocal()}'.split(' ')[0] : 'Select Date'}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: scheduledDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != scheduledDate) {
                    scheduledDate = pickedDate;
                  }
                },
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  'Estimated Completion Time: ${estimatedCompletionDate != null ? '${estimatedCompletionDate?.toLocal()}'.split(' ')[0] : 'Select Date'}',
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: estimatedCompletionDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null &&
                      pickedDate != estimatedCompletionDate) {
                    estimatedCompletionDate = pickedDate;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (scheduledDate != null && estimatedCompletionDate != null) {
                  Navigator.of(context).pop();
                  // Use null-aware operator to call the method with non-nullable types
                  _assignMaintainers(
                    scheduledDate!,
                    estimatedCompletionDate!,
                  ); // Use '!' to assert non-null
                } else {
                  Get.snackbar('Error', 'Please select both dates.');
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _assignMaintainers(
    DateTime scheduledDate,
    DateTime estimatedCompletionDate,
  ) async {
    try {
      final payload = {
        "maintainerId": selectedMaintainers.first,
        "scheduledDate":
            scheduledDate.toIso8601String(), // Convert to ISO 8601 format
        "estimatedCompletionTime":
            estimatedCompletionDate
                .toIso8601String(), // Convert to ISO 8601 format
      };
      print(payload);
      final response = await controller.assignMaintainers(
        payload,
        maintenanceId,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Maintainers assigned successfully');
      } else {
        Get.snackbar('Error', 'Failed to assign maintainers');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }
}
