// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlantModel{
  static List<Plant> plants=[];
  Plant getByName(String name) => plants.firstWhere((element) => element.name == name, orElse: null);

}
class Plant {
  final int id;
  final String name;
  final String about;
  final String usage;
  final String growth;
  Plant({
    required this.id,
    required this.name,
    required this.about,
    required this.usage,
    required this.growth
  });

  Plant copyWith({
    int? id,
    String? name,
    String? about,
    String? usage,
    String? growth,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      about: about ?? this.about,
      usage: usage ?? this.usage,
      growth: growth ?? this.growth,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'about': about,
      'usage': usage,
      'growth': growth,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as int,
      name: map['name'] as String,
      about: map['about'] as String,
      usage: map['usage'] as String,
      growth: map['growth'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Plant.fromJson(String source) => Plant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Plant(id: $id, name: $name, about: $about, usage: $usage, growth: $growth)';
    }

  @override
  bool operator ==(covariant Plant other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.about == about &&
      other.usage == usage &&
      other.growth == growth;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      about.hashCode ^
      usage.hashCode ^
      growth.hashCode;
  }
}
