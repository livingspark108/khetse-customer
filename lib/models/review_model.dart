class ReviewModel {
  final int id;
  final int orderId;
  final int vegetablesFruitsQuality;
  final int deliveryExperience;
  final int packagingQuality;
  final int hygiene;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.vegetablesFruitsQuality,
    required this.deliveryExperience,
    required this.packagingQuality,
    required this.hygiene,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      orderId: json['order_id'],
      vegetablesFruitsQuality: json['vegetables_fruits_quality'],
      deliveryExperience: json['delivery_experience'],
      packagingQuality: json['packaging_quality'],
      hygiene: json['hygiene'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'vegetables_fruits_quality': vegetablesFruitsQuality,
      'delivery_experience': deliveryExperience,
      'packaging_quality': packagingQuality,
      'hygiene': hygiene,
    };
  }
}
