import 'package:flutter/material.dart';
import 'package:healthcare/feature/clinicdetail/presentation/clinic_detail_page.dart';
import 'package:healthcare/model/clinicmodel.dart';

class ClinicPromotion extends StatelessWidget {
  const ClinicPromotion({super.key});

  void _goToClinicDetailPage(BuildContext context, ClinicModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClinicDetailPage(
          model: model,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClinicModel>>(
      future: getClinics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          final clinics = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemCount: clinics.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final model = clinics[index];

              return Center(
                child: TextButton(
                  onPressed: () => _goToClinicDetailPage(
                    context,
                    model,
                  ),
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 1),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          model.imageUrl!,
                          width: 450,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        Text(model.name),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
