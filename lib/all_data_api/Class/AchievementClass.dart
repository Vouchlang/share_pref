class AchievementData {
  List<AchievementTypeData> achievementData;

  AchievementData({required this.achievementData});

  factory AchievementData.fromJson(Map<String, dynamic> json) {
    return AchievementData(
      achievementData: (json['achievement_data'] as List<dynamic>)
          .map((e) => AchievementTypeData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievement_data': achievementData.map((e) => e.toJson()).toList(),
    };
  }
}

class AchievementTypeData {
  String achievementType;
  List<AchievementImageData> data;

  AchievementTypeData({required this.achievementType, required this.data});

  factory AchievementTypeData.fromJson(Map<String, dynamic> json) {
    return AchievementTypeData(
      achievementType: json['achievement_type'],
      data: (json['data'] as List<dynamic>)
          .map((e) => AchievementImageData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'achievement_type': achievementType,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class AchievementImageData {
  String image;

  AchievementImageData({required this.image});

  factory AchievementImageData.fromJson(Map<String, dynamic> json) {
    return AchievementImageData(
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
    };
  }
}
