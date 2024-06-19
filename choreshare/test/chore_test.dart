import 'package:flutter_test/flutter_test.dart';
import '../lib/models/chore.dart';

void main() {
  group('Chore model', () {
    test('should be created from map correctly', () {
      final choreMap = {
        'id': 1,
        'name': 'Wash dishes',
        'description': 'Wash dishes after dinner',
        'assignedProfiles': '1,2,3',
        'rotation': 1,
        'repetition': 'weekly',
        'every': '2',
        'days': 'Monday,Wednesday,Friday',
      };

      final chore = Chore.fromMap(choreMap);

      expect(chore.id, 1);
      expect(chore.name, 'Wash dishes');
      expect(chore.description, 'Wash dishes after dinner');
      expect(chore.assignedProfiles, [1, 2, 3]);
      expect(chore.rotation, true);
      expect(chore.repetition, 'weekly');
      expect(chore.every, '2');
      expect(chore.days, ['Monday', 'Wednesday', 'Friday']);
    });
  });
}
