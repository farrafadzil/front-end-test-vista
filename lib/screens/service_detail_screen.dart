import 'package:flutter/material.dart';
import '../models/service.dart';

class ServiceDetailScreen extends StatelessWidget {
  final Service service;

  const ServiceDetailScreen({super.key, required this.service});

  Widget buildDetailItem(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          SizedBox(
            width: 120, 
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
        "Service Details",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,              
        ),
      ),
        backgroundColor: Colors.orangeAccent,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  "Service Information",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
                const Divider(thickness: 1.5),
                const SizedBox(height: 10),

                // Service Name
                buildDetailItem("Service Name", service.name),

                // Service Description
                buildDetailItem("Description", service.description),

                // Service Price
                buildDetailItem(
                  "Price",
                  "RM ${service.price.toStringAsFixed(2)}",
                  valueColor: Colors.green,
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
