class Farm {
  final int id;
  final String name;
  final String crop;
  final String area;
  final String location;
  final String? predictedYield;
  final String? yieldPerAcre;

  Farm({
    required this.id,
    required this.name,
    required this.crop,
    required this.area,
    required this.location,
    this.predictedYield,
    this.yieldPerAcre,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'crop': crop,
        'area': area,
        'location': location,
        'predictedYield': predictedYield,
        'yieldPerAcre': yieldPerAcre,
      };

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
        id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
        name: json['name'] ?? '',
        crop: json['crop'] ?? '',
        area: json['area'] ?? '',
        location: json['location'] ?? '',
        predictedYield: json['predictedYield'],
        yieldPerAcre: json['yieldPerAcre'],
      );
}
