import 'package:flutter_test/flutter_test.dart';
import '../lib/models/profile.dart';

void main() {
  test('Profile model should create an instance with given parameters', () {
    final profile = Profile(
      id: 1,
      name: 'John Doe',
      color: 'Red',
      photo: 'path/to/photo.jpg',
    );

    expect(profile.id, 1);
    expect(profile.name, 'John Doe');
    expect(profile.color, 'Red');
    expect(profile.photo, 'path/to/photo.jpg');
  });

  test('Profile model should convert to map correctly', () {
    final profile = Profile(
      id: 1,
      name: 'John Doe',
      color: 'Red',
      photo: 'path/to/photo.jpg',
    );

    final profileMap = profile.toMap();

    expect(profileMap['id'], 1);
    expect(profileMap['name'], 'John Doe');
    expect(profileMap['color'], 'Red');
    expect(profileMap['photo'], 'path/to/photo.jpg');
  });

  test('Profile model should be created from map correctly', () {
    final profileMap = {
      'id': 1,
      'name': 'John Doe',
      'color': 'Red',
      'photo': 'path/to/photo.jpg',
    };

    final profile = Profile.fromMap(profileMap);

    expect(profile.id, 1);
    expect(profile.name, 'John Doe');
    expect(profile.color, 'Red');
    expect(profile.photo, 'path/to/photo.jpg');
  });
}
