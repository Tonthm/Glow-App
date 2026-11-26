import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/task_status.dart';

void main() {
  final now = DateTime(2026, 11, 26, 21);

  TaskState state({bool done = false, DateTime? due}) =>
      taskState(done: done, due: due, now: now);

  test('finished is finished, however late', () {
    expect(state(done: true), TaskState.done);
    expect(state(done: true, due: DateTime(2026, 1, 1)), TaskState.done);
  });

  test('missed only once the due day is over', () {
    expect(state(due: DateTime(2026, 11, 25)), TaskState.missed);
    expect(state(due: DateTime(2026, 11, 26)), TaskState.doing);
    expect(state(due: DateTime(2026, 11, 27)), TaskState.doing);
  });

  test('the time on the due date does not matter', () {
    expect(
      taskState(
        done: false,
        due: DateTime(2026, 11, 26),
        now: DateTime(2026, 11, 26, 23, 59),
      ),
      TaskState.doing,
    );
    expect(
      taskState(
        done: false,
        due: DateTime(2026, 11, 26),
        now: DateTime(2026, 11, 27),
      ),
      TaskState.missed,
    );
  });

  test('with no due date it can never be missed', () {
    expect(state(), TaskState.doing);
  });

  test('progress counts ticked steps', () {
    expect(stepProgress(const [true, false, true, false, false]), (2, 5));
    expect(stepProgress(const []), (0, 0));
  });
}
