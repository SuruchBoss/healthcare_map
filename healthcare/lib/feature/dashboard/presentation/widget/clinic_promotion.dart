import 'package:flutter/material.dart';
import 'package:healthcare/feature/clinicdetail/presentation/clinic_detail_page.dart';
import 'package:healthcare/model/clinicmodel.dart';
import 'package:healthcare/model/promotionmodel.dart';
import 'package:healthcare/widget/skeleton_loader.dart';

class ClinicPromotion extends StatelessWidget {
  final int customerId;

  const ClinicPromotion({super.key, required this.customerId});

  Future<void> _goToClinicDetailPage(
      BuildContext context, String clinicName) async {
    final clinics = await getClinics();
    final matches = clinics.where((c) => c.name == clinicName);
    if (matches.isEmpty || !context.mounted) return;
    final model = matches.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClinicDetailPage(
          model: model,
          customerId: customerId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PromotionModel>>(
      future: getPromotions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SkeletonColumn(count: 3, itemHeight: 190);
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          final promotions = snapshot.data!;

          if (promotions.isEmpty) {
            return Center(
              child: Text(
                "No promotions right now",
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemCount: promotions.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final promotion = promotions[index];

              return Center(
                child: TextButton(
                  onPressed: () =>
                      _goToClinicDetailPage(context, promotion.clinicName),
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
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              promotion.imageUrl,
                              width: 450,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    promotion.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(promotion.description),
                                  const SizedBox(height: 4),
                                  Text(
                                    promotion.clinicName,
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '-${promotion.discountPercent}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
