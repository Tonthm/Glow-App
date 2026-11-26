import 'package:material_ui/material_ui.dart';

import '../../core/birth_date.dart';
import '../../core/card_config.dart';
import '../../data/database.dart';
import '../../theme/tokens.dart';

/// What the user has typed about themselves. Used by the first screen and by
/// the card's editor.
class ProfileInput {
  final TextEditingController name;
  final TextEditingController birthDate;
  final TextEditingController school;
  final TextEditingController classYear;

  ProfileInput([CardProfileRow? saved])
    : name = TextEditingController(text: saved?.displayName ?? ''),
      birthDate = TextEditingController(
        text: saved?.birthDate == null
            ? ''
            : formatBirthDate(saved!.birthDate!),
      ),
      school = TextEditingController(text: saved?.school ?? ''),
      classYear = TextEditingController(text: saved?.classYear ?? '');

  void dispose() {
    name.dispose();
    birthDate.dispose();
    school.dispose();
    classYear.dispose();
  }
}

String birthDateProblemMessage(BirthDateProblem problem) => switch (problem) {
  BirthDateProblem.format =>
    'ใส่เป็น วัน/เดือน/ปี 4 หลัก เช่น 5/3/2551 หรือ 05032551',
  BirthDateProblem.noSuchDay => 'ไม่มีวันที่นี้ในปฏิทิน ลองตรวจอีกครั้ง',
  BirthDateProblem.future => 'วันเกิดต้องไม่อยู่ในอนาคต',
  BirthDateProblem.tooLongAgo => 'ลองตรวจปีเกิดอีกครั้ง',
};

/// Name, birth date, school and class year.
class ProfileFields extends StatelessWidget {
  final ProfileInput input;
  final String? nameError;
  final String? birthDateError;

  const ProfileFields({
    super.key,
    required this.input,
    this.nameError,
    this.birthDateError,
  });

  @override
  Widget build(BuildContext context) {
    Widget field(
      TextEditingController controller,
      String label, {
      int? max,
      String? error,
      String? helper,
      TextInputType? keyboard,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: GlowSpacing.md),
      child: TextField(
        controller: controller,
        maxLength: max,
        keyboardType: keyboard,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          counterText: '',
          errorText: error,
          errorMaxLines: 2,
          helperText: helper,
          helperMaxLines: 2,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        field(input.name, 'ชื่อ', max: maxCardNameLength, error: nameError),
        field(
          input.birthDate,
          'วันเกิด (ว/ด/ปปปป)',
          error: birthDateError,
          helper: 'เช่น 5/3/2551 หรือ 05032551 ใช้ปรับเป้าชั่วโมงนอน',
          keyboard: TextInputType.datetime,
        ),
        field(
          input.school,
          'โรงเรียนหรือมหาวิทยาลัย',
          max: maxCardSchoolLength,
        ),
        field(input.classYear, 'ชั้นปี', max: maxCardClassLength),
      ],
    );
  }
}
