import 'package:beta_pm/controllers/MaintenanceController.dart';
import 'package:beta_pm/screens/maintenance/list_of_maintenance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/maintenance_controller.dart';

class MaintenanceRequestsScreen extends StatelessWidget {
  final MaintenanceController controller = Get.put(MaintenanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Maintenance Requests',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF87CEEB),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.maintenanceRequests.isEmpty) {
          return const Center(child: Text('No Maintenance Requests Found'));
        }

        return ListView.builder(
          itemCount: controller.maintenanceRequests.length,
          itemBuilder: (context, index) {
            final request = controller.maintenanceRequests[index];

            return Card(
              margin: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(
                          request.tenantName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Request: ${request.typeOfRequest}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Description: ${request.description}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Urgency: ${request.urgencyLevel}',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            request.urgencyLevel == 'Urgent'
                                ? Colors.red
                                : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to Update Screen

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MaintainerPage(
                                      maintenanceId: request.id,
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Assign'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            controller.deleteMaintenanceRequest(request.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
