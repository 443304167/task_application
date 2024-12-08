// class UserTask {
//   final String id;
//   final String title;
//   String? description;
//   DateTime? startingDate;
//   final String imagePath;
//   bool isDone;

//   UserTask(
//     this.id,
//     this.title,
//     this.description,
//     this.startingDate, {
//     this.imagePath = 'assets/images/self.png',
//     this.isDone = false,
//   });
// }
class UserTask {
  final String id;
  final String title;
  final String? description;
  final DateTime? startingDate;
  final String imagePath;
  final String priority; // الأولوية
  final String focusLevel; // مستوى التركيز
  bool isDone;

  UserTask(
    this.id,
    this.title,
    this.description,
    this.startingDate, {
    required this.imagePath,
    required this.priority, // الإضافة الجديدة
    required this.focusLevel, // الإضافة الجديدة
    this.isDone = false,
  });
}
