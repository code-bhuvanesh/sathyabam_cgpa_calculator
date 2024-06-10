// import '/models/course.dart';

// class Branch {
//   Branch({
//     required this.branchName,
//     required this.courses,
//   });
//   String branchName;
//   List<Course> courses;

//   factory Branch.fromJson(String name, Map json) {
//     return Branch(branchName: name, courses: []);
//   }

//   List<Course> _jsonToCourses(Map<String, dynamic> json) {
//     return json.entries
//         .map(
//           (e) => Course.fromJson(
//             e.key,
//             e.value,
//           ),
//         )
//         .toList();
//   }
// }
