import 'profile.dart';

class Chore {
  final int id;
  final String name;
  final String description;
  final List<Profile> assignedProfiles;
  final bool rotation;
  final String repetition;
  final String every;
  final List<int> days;

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
      'assignedProfiles': assignedProfiles.map((profile) => profile.toMap()).toList(),
      'rotation': rotation ? 1 : 0,
      'repetition': repetition,
      'every': every,
      'days': days.join(','),
    };
  }

  factory Chore.fromMap(Map<String, dynamic> map, List<Profile> allProfiles) {
    List<String> profileIds = (map['assignedProfiles'] as String).split(',');
    List<Profile> profiles = allProfiles.where((profile) => profileIds.contains(profile.id.toString())).toList();

    List<int> days = (map['days'] as String).split(',').map((day) => int.parse(day)).toList();

    return Chore(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      assignedProfiles: profiles,
      rotation: map['rotation'] == 1,
      repetition: map['repetition'],
      every: map['every'],
      days: days,
    );
  }

  Chore copyWith({
    int? id,
    String? name,
    String? description,
    List<Profile>? assignedProfiles,
    bool? rotation,
    String? repetition,
    String? every,
    List<int>? days,
  }) {
    return Chore(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      assignedProfiles: assignedProfiles ?? this.assignedProfiles,
      rotation: rotation ?? this.rotation,
      repetition: repetition ?? this.repetition,
      every: every ?? this.every,
      days: days ?? this.days,
    );
  }
}
