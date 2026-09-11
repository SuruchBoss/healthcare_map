import 'package:flutter/material.dart';
import 'package:healthcare/feature/dashboard/presentation/widget/clinic_history.dart';
import 'package:healthcare/feature/dashboard/presentation/widget/clinic_promotion.dart';
import 'package:healthcare/feature/dashboard/presentation/widget/upcomingevent.dart';
import 'package:healthcare/feature/landingpage/presentation/landingpage.dart';
import 'package:healthcare/feature/mybooking/presentation/mybookingpage.dart';
import 'package:healthcare/feature/searchingpage/presentation/searchingpage.dart';
import 'package:healthcare/model/bookingmodel.dart';
import 'package:healthcare/model/customermodel.dart';
import 'package:healthcare/theme/app_theme.dart';
import 'package:healthcare/util/loyalty.dart';

class DashBoard extends StatefulWidget {
  final CustomerModel customer;
  const DashBoard({
    super.key,
    required this.customer,
  });

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int get _customerId => int.parse(widget.customer.id);

  void _logOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingPage(),
      ),
    );
  }

  Future<void> _goToSearchPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchingPage(customerId: _customerId),
      ),
    );
    // A booking may have been made while away; refresh loyalty tier,
    // upcoming events, and history.
    if (mounted) setState(() {});
  }

  Future<void> _goToMyBookingPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyBookingPage(customerId: _customerId),
      ),
    );
    // A booking may have been made or cancelled while away.
    if (mounted) setState(() {});
  }

  void _showLoyaltyDialog(BuildContext context, LoyaltyInfo loyalty) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Loyalty Program'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tier: ${loyalty.tier}'),
              Text('Points: ${loyalty.points}'),
              const SizedBox(height: 8),
              if (loyalty.nextTier != null)
                Text(
                    'Book ${loyalty.bookingsToNextTier} more time(s) to reach ${loyalty.nextTier}!')
              else
                const Text("You've reached the highest tier!"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                  width: screenWidth,
                  padding: const EdgeInsets.only(
                    top: 64,
                    left: 24,
                    right: 16,
                    bottom: 24,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello, ${widget.customer.firstName} ${widget.customer.lastName}",
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    "Member level:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  FutureBuilder<int>(
                                    future: getBookingCount(_customerId),
                                    builder: (context, snapshot) {
                                      final loyalty = calculateLoyalty(
                                          snapshot.data ?? 0);
                                      return GestureDetector(
                                        onTap: () =>
                                            _showLoyaltyDialog(context, loyalty),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            loyalty.tier,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () => _logOut(),
                            icon: const Icon(
                              Icons.logout_outlined,
                              color: Colors.white,
                              size: 26.0,
                            ),
                          ))
                    ],
                  )),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _DashboardActionCard(
                        onTap: _goToSearchPage,
                        backgroundImage: "assets/search_bg.png",
                        color: AppColors.primary,
                        icon: Icons.search_rounded,
                        label: "Clinic Near You",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DashboardActionCard(
                        onTap: _goToMyBookingPage,
                        backgroundImage: "assets/booking_bg.png",
                        color: AppColors.secondary,
                        icon: Icons.calendar_month_rounded,
                        label: "My Booking",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Upcoming appointment",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              UpcomingEventsWidget(customerId: _customerId),
              const SizedBox(height: 32),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Previous clinic",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: screenWidth,
                height: 130,
                child: ClinicHistory(customerId: _customerId),
              ),
              const SizedBox(height: 16),
              const Divider(height: 32, thickness: 1, indent: 20, endIndent: 20),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Promotion",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ClinicPromotion(customerId: _customerId),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardActionCard extends StatelessWidget {
  final VoidCallback onTap;
  final String backgroundImage;
  final Color color;
  final IconData icon;
  final String label;

  const _DashboardActionCard({
    required this.onTap,
    required this.backgroundImage,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(color, BlendMode.multiply),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
