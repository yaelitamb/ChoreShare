class Chore {
  final int id;
  final String name;
  final String description;
  final List<int> assignedProfiles;
  final bool rotation;
  final String repetition;
  final String every;
  final List<String> days;

  Chore({
    required this.id,
    required this.name,
    required this.description,
    required this.assignedProfiles,
    required this.rotation,
    required this.repetition,
    required this.every,
    required this.days,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'assignedProfiles': assignedProfiles.join(','),
      'rotation': rotation ? 1 : 0,
      'repetition': repetition,
      'every': every,
      'days': days.join(','),
    };
  }

  factory Chore.fromMap(Map<String, dynamic> map) {
    return Chore(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      assignedProfiles: map['assignedProfiles'].split(',').map((id) => int.parse(id)).toList(),
      rotation: map['rotation'] == 1,
      repetition: map['repetition'],
      every: map['every'],
      days: map['days'].split(','),
    );
  }
}
