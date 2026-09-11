import 'package:flutter/material.dart';
import 'package:healthcare/feature/clinicdetail/presentation/clinic_detail_page.dart';
import 'package:healthcare/model/clinicmodel.dart';
import 'package:healthcare/theme/app_theme.dart';
import 'package:healthcare/widget/skeleton_loader.dart';

class ClinicHistory extends StatelessWidget {
  final int customerId;

  const ClinicHistory({super.key, required this.customerId});

  void _goToClinicDetailPage(BuildContext context, ClinicModel model) {
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
    return FutureBuilder<List<ClinicModel>>(
      future: getRecentlyBookedClinics(customerId: customerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SkeletonRow(count: 3, itemWidth: 120, itemHeight: 100);
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        } else {
          final clinics = snapshot.data!;

          if (clinics.isEmpty) {
            return Center(
              child: Text(
                "You haven't booked any clinic yet",
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: clinics.length,
            itemBuilder: (context, index) {
              final model = clinics[index];

              return Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _goToClinicDetailPage(context, model),
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.background,
                            height: 44,
                            child: Image.asset(
                              model.imageUrl!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          model.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
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
