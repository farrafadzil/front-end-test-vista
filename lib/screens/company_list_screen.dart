import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/company_provider.dart';
import 'service_detail_screen.dart';


class CompanyListScreen extends StatefulWidget {
  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CompanyProvider>(context, listen: false);
      provider.fetchCompanies();
    });
  }

@override
Widget build(BuildContext context) {
  final provider = Provider.of<CompanyProvider>(context);

  return Scaffold(
    appBar: AppBar(
       title: const Text(
          "Companies",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,               
          ),
       ),
      backgroundColor: Colors.blueAccent,
    ),
    body: provider.isLoading
        ? const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          )
        : provider.errorMessage != null
            ? Center(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
            : provider.companies.isEmpty
                ? const Center(
                    child: Text(
                      "No companies found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: provider.companies.length,
                    itemBuilder: (ctx, i) {
                      final company = provider.companies[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ExpansionTile(
                          leading: const Icon(Icons.business,
                              color: Colors.blueAccent),
                          title: Text(
                            company.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "Reg: ${company.registrationNumber}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          children: company.services.isEmpty
                              ? [
                                  const ListTile(
                                    title: Text("No services available"),
                                  )
                                ]
                    : company.services.map((s) {
                        return ListTile(
                          leading: Icon(Icons.miscellaneous_services, color: Colors.orange),
                          title: Text(s.name), 
                          
                          trailing: Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Navigate ke detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceDetailScreen(service: s),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      ),
                    );
                  },
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "createCompany",
            icon: Icon(Icons.business),
            label: Text("Add Company"),
            backgroundColor: Colors.blueAccent,
            onPressed: () => Navigator.pushNamed(context, '/create-company'),
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "createService",
            icon: Icon(Icons.miscellaneous_services),
            label: Text("Add Service"),
            backgroundColor: Colors.orangeAccent,
            onPressed: () => Navigator.pushNamed(context, '/create-service'),
          ),
        ],
      ),
    );
  }
}
