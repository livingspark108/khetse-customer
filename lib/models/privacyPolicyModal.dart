class PrivacyPolicy {
  int? policyId;

  String? title;
  String? description;
  PrivacyPolicy({
    this.policyId,
    this.title,
    this.description,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) => PrivacyPolicy(
        title: "Privacy Policy",
        description: json["html"],
      );
  Map<String, dynamic> toJson() => {
        "about_id": policyId,
        "title": title,
        "description": description,
      };
}
