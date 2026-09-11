import 'package:flutter/material.dart';
import 'package:healthcare/feature/clinicdetail/presentation/clinic_detail_page.dart';
import 'package:healthcare/model/clinicmodel.dart';
import 'package:healthcare/model/promotionmodel.dart';
import 'package:healthcare/theme/app_theme.dart';
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
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: promotions.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final promotion = promotions[index];

              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () =>
                      _goToClinicDetailPage(context, promotion.clinicName),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 140,
                              color: AppColors.background,
                              child: Image.asset(
                                promotion.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    promotion.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    promotion.description,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.local_hospital_rounded,
                                        size: 14,
                                        color: AppColors.secondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        promotion.clinicName,
                                        style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '-${promotion.discountPercent}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
