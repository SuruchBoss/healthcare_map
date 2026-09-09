const _pointsPerBooking = 10;
const _silverAtBookings = 3;
const _goldAtBookings = 6;

class LoyaltyInfo {
  final String tier;
  final int points;
  final int bookingCount;
  final String? nextTier;
  final int? bookingsToNextTier;

  const LoyaltyInfo({
    required this.tier,
    required this.points,
    required this.bookingCount,
    this.nextTier,
    this.bookingsToNextTier,
  });
}

LoyaltyInfo calculateLoyalty(int bookingCount) {
  final points = bookingCount * _pointsPerBooking;

  if (bookingCount >= _goldAtBookings) {
    return LoyaltyInfo(
      tier: 'Gold',
      points: points,
      bookingCount: bookingCount,
    );
  }

  if (bookingCount >= _silverAtBookings) {
    return LoyaltyInfo(
      tier: 'Silver',
      points: points,
      bookingCount: bookingCount,
      nextTier: 'Gold',
      bookingsToNextTier: _goldAtBookings - bookingCount,
    );
  }

  return LoyaltyInfo(
    tier: 'Bronze',
    points: points,
    bookingCount: bookingCount,
    nextTier: 'Silver',
    bookingsToNextTier: _silverAtBookings - bookingCount,
  );
}
