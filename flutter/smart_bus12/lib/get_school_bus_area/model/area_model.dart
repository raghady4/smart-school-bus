class Area {
  final int areaId;
  final dynamic name;
  final dynamic description;
  

  Area({
    required this.areaId,
    required this.name,
    required this.description,
   
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      areaId: json['area_id'],
      name: json['name'],
      description: json['description'],
   
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area_id': areaId,
      'name': name,
      'description': description,
  };
  }
}

