class Profile {
  final int id;
  final String name;
  final String color;
  final String photo;

  Profile({required this.id, required this.name, required this.color, required this.photo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'photo': photo,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      photo: map['photo'],
    );
  }
}
