import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import '../providers/service_provider.dart';
import '../models/company.dart';

class CreateServiceScreen extends StatefulWidget {
  @override
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String serviceName = '';
  String serviceDescription = '';
  String price = '';
  Company? selectedCompany;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServiceProvider>(context);
    final companyProvider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Service",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 20,               
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 2,
      ),
      body: Center(
        child: provider.isLoading
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.orangeAccent.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "New Service",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Service Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.miscellaneous_services),
                            ),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                            onSaved: (v) => serviceName = v!,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Service Description",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.description),
                            ),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                            onSaved: (v) => serviceDescription = v!,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Price",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.isEmpty) return "Required";
                              if (double.tryParse(v) == null)
                                return "Must be a number";
                              return null;
                            },
                            onSaved: (v) => price = v!,
                          ),
                          SizedBox(height: 20),
                       DropdownButtonFormField<Company>(
                          value: selectedCompany,
                          decoration: InputDecoration(
                            labelText: "Select Company",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: Icon(Icons.business),
                          ),
                          items: companyProvider.companies.map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text("${c.name} (${c.registrationNumber})"),
                            ),
                          ).toList(),
                          onChanged: (c) => setState(() => selectedCompany = c),
                          validator: (v) => v == null ? "Please select a company" : null,
                        ),
                          SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: provider.isLoading
                                  ? SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(Icons.check),
                              label: Text(
                                provider.isLoading
                                    ? "Creating..."
                                    : "Create Service",
                                style: TextStyle(fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: provider.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      if (selectedCompany == null) return;

                                      bool success = await provider.createService(
                                        name: serviceName,
                                        description: serviceDescription,
                                        price: double.parse(price),
                                        companyId: selectedCompany!.id,
                                      );

                                      if (success) {
                                        // popup bila success
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            title: Row(
                                              children: [
                                                Icon(Icons.check_circle, color: Colors.green, size: 28),
                                                SizedBox(width: 8),
                                                Text("Success!"),
                                              ],
                                            ),
                                            content: Text(
                                              "Service \"$serviceName\" has been created successfully.",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context); // tutup popup
                                                  Navigator.pop(context); // balik ke page sebelum ni
                                                },
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(color: Colors.orangeAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        // display popup bila fail
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            title: Row(
                                              children: [
                                                Icon(Icons.error, color: Colors.red, size: 28),
                                                SizedBox(width: 8),
                                                Text("Failed"),
                                              ],
                                            ),
                                            content: Text(
                                              "Failed to create service. Please try again.",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(color: Colors.orangeAccent),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
