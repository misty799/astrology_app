class Astrologer {
  late String firstName;
  late String lastName;
  late List<String> languages;
  late double experience;
  late List<String> skills;
  late String imageUrl;
  late double minimumCallDurationCharges;
  late double minimumCallDuration;
  late double price;
  Astrologer(
      {required this.firstName,
      required this.lastName,
      required this.languages,
      required this.experience,
      required this.skills,
      required this.imageUrl,
      required this.minimumCallDurationCharges});
  Astrologer.fromMap(Map<String, dynamic> map) {
    firstName = map['firstName'];
    lastName = map['lastName'];
    experience = map['experience'];

    minimumCallDurationCharges = map['minimumCallDurationCharges'];
    minimumCallDuration = map['minimumCallDuration'].toDouble();

    price = (minimumCallDurationCharges ~/ minimumCallDuration).toDouble();
    languages = [];
    for (var element in map["languages"]) {
      languages.add(Language.fromMap(element).name);
    }
    skills = [];
    for (var element in map["skills"]) {
      skills.add(Skill.fromMap(element).name);
    }
    imageUrl = map['images']['medium']['imageUrl'];
  }
}

class Language {
  late int id;
  late String name;
  Language.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}

class Skill {
  late int id;
  late String name;
  late String description;
  Skill.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    description = map['description'];
  }
}

class Images {
  late String imageUrl;
  late int id;
  Images.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    imageUrl = map['imageUrl'];
  }
}
