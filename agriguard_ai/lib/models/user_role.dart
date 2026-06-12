enum UserRole {
  farmer,
  buyer;

  String get label => switch (this) {
        UserRole.farmer => 'Farmer',
        UserRole.buyer => 'Buyer / Aggregator',
      };

  String get welcome => switch (this) {
        UserRole.farmer => 'Welcome Farmer',
        UserRole.buyer => 'Welcome Buyer',
      };
}
