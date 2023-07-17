
class PetModel {
  String? name;
  String? url;
  String? species;
  int? age;
  String? gender;
  bool? favorite;

  PetModel(
      {this.name,
      this.url,
      this.species,
      this.age,
      this.gender,
      this.favorite});

  PetModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    species = json['Species'];
    age = json['age'];
    gender = json['gender'];
    favorite = json['favorite '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['Species'] = species;
    data['age'] = age;
    data['gender'] = gender;
    data['favorite '] = favorite;
    return data;
  }
}
