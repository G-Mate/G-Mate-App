import 'package:flutter_test/flutter_test.dart';
import 'package:g_mate/features/admin/presentation/bloc/admin_tour_edit_cubit.dart';
import 'package:g_mate/features/place/data/in_memory_place_repository.dart';
import 'package:g_mate/features/tour/data/in_memory_tour_repository.dart';
import 'package:g_mate/features/tour/data/seed_tours.dart';
import 'package:g_mate/features/tour/domain/tour.dart';

void main() {
  late InMemoryTourRepository tours;

  setUp(() => tours = InMemoryTourRepository());

  Future<AdminTourEditCubit> build(String? key) async {
    final cubit = AdminTourEditCubit(
      tours: tours,
      places: InMemoryPlaceRepository(),
      tourKey: key,
      now: () => DateTime.fromMillisecondsSinceEpoch(42),
    );
    await cubit.load();
    addTearDown(cubit.close);
    return cubit;
  }

  List<String> keysOf(Tour tour) => [for (final s in tour.stops) s.placeKey];

  test('들를 곳 순서를 바꾸고 빼고 넣으면 설명은 그대로 따라간다', () async {
    final first = seedTours.first;
    final cubit = await build(first.key);

    cubit
      ..moveStop(3, 0)
      ..removeStop(2)
      ..addStop('science_lab')
      ..addStop('science_lab');
    final tour = cubit.state.tour!;
    expect(keysOf(tour), [
      'auditorium',
      'admin_office',
      'library',
      'science_lab',
    ]);
    expect(tour.stops.first.lines, first.stops.last.lines);
  });

  test('저장하면 저장소에 남고 이름 앞뒤 빈칸은 뺀다', () async {
    final cubit = await build(seedTours.first.key);
    cubit
      ..changeName('  새 이름 ')
      ..changeDuration(const Duration(minutes: 30));
    await cubit.save();

    expect(cubit.state.isSaved, isTrue);
    final saved = await tours.getTour(seedTours.first.key);
    expect(saved!.name, '새 이름');
    expect(saved.duration, const Duration(minutes: 30));
  });

  test('새 코스는 이름과 들를 곳이 있어야 저장되고 목록 끝에 붙는다', () async {
    final cubit = await build(null);
    expect(cubit.state.isNew, isTrue);
    expect(cubit.state.canSave, isFalse);

    cubit.changeName('도서관만');
    expect(cubit.state.canSave, isFalse);
    cubit.addStop('library');
    expect(cubit.state.canSave, isTrue);
    await cubit.save();

    final all = await tours.getTours();
    expect(all, hasLength(seedTours.length + 1));
    expect(all.last.key, 'tour_42');
    expect(keysOf(all.last), ['library']);
  });
}
