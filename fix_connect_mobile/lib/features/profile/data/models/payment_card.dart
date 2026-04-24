enum CardBrand { visa, mastercard }

class PaymentCard {
  final String id;
  final CardBrand brand;
  final String last4;
  final String expiry;
  final String holderName;
  bool isDefault;

  String get brandName => brand == CardBrand.visa ? 'Visa' : 'Mastercard';

  PaymentCard({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.holderName,
    required this.isDefault,
  });
}
