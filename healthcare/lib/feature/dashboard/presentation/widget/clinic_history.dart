import 'package:flutter/material.dart';
import 'package:healthcare/model/clinicmodel.dart';

class ClinicHistory extends StatelessWidget {
  const ClinicHistory({super.key});

  static const List<ClinicModel> clinics = [
    ClinicModel(
      id: "001",
      name: "Flutter Clinic",
      detail: "SkinCare and everyday looks",
      phone: "021112222",
      lat: "13.6436432",
      lon: "100.2481067",
      imageUrl: "assets/clinic/clinic_1.png",
    ),
    ClinicModel(
      id: "002",
      name: "ReactJS Clinic",
      detail: "SkinCare and Someday looks",
      phone: "021113333",
      lat: "13.7436432",
      lon: "100.2481367",
      imageUrl: "assets/clinic/clinic_2.png",
    ),
    ClinicModel(
      id: "003",
      name: "Python Clinic",
      detail: "Dermartology",
      phone: "021114444",
      lat: "13.7836432",
      lon: "100.2481367",
      imageUrl: "assets/clinic/clinic_3.png",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: clinics.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final model = clinics[index];

          return TextButton(
            onPressed: null,
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 1),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            child: Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  Image.asset(
                    model.imageUrl!,
                    width: 120,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Text(model.name),
                ],
              ),
            ),
          );
        });
  }
}
