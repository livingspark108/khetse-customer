class OrderReview {
  int? id;
  int? orderId;
  int? vegetablesFruitsQuality;
  int? deliveryExperience;
  int? packagingQuality;
  int? hygiene;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? reviewerName;

  OrderReview({
    this.id,
    this.orderId,
    this.vegetablesFruitsQuality,
    this.deliveryExperience,
    this.packagingQuality,
    this.hygiene,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.reviewerName,
  });

  factory OrderReview.fromJson(Map<String, dynamic> json) {
    return OrderReview(
      id: json['id'],
      orderId: json['order_id'],
      vegetablesFruitsQuality: json['vegetables_fruits_quality'],
      deliveryExperience: json['delivery_experience'],
      packagingQuality: json['packaging_quality'],
      hygiene: json['hygiene'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      reviewerName: json['reviewer_name'],
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
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'reviewer_name': reviewerName,
    };
  }
}
