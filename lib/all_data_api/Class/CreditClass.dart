class Credit {
  final String totalCredit, yourCredit;

  Credit({
    required this.totalCredit,
    required this.yourCredit,
  });

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      totalCredit: json['total_credit'],
      yourCredit: json['your_credit'],
    );
  }
}
