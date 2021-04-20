class Recommendation {
  List<DemandInfo> recomendedDemand;

  Recommendation({this.recomendedDemand});

  Recommendation.fromJson(Map<String, dynamic> json) {
    recomendedDemand = (json['recomended_demand'] as List)
        .map((e) => DemandInfo.fromJson(e))
        .toList();
  }
}

class DemandInfo {
  String demandId;
  String userOwnerId;
  double similarity;

  DemandInfo({this.demandId, this.userOwnerId, this.similarity});

  DemandInfo.fromJson(Map<String, dynamic> json) {
    demandId = json['demand_id'];
    userOwnerId = json['user_owner_id'];
    similarity = json['similarity'].toDouble();
  }
}
