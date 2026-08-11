// class HandleApi {
//   /// ✅ التحقق إذا كان الريسبونس ناجح
//   static bool isSuccess(dynamic response) {
//     return response != null &&
//         response.statusCode != null &&
//         response.statusCode == 200;
//   }

//   /// ✅ استخراج رسائل الأخطاء من response API
//   static String parseErrors(
//     dynamic responseData, {
//     String defaultMessage = "فشل",
//   }) {
//     if (responseData != null && responseData['errors'] != null) {
//       final Map<String, dynamic> errors =
//           responseData['errors'] as Map<String, dynamic>;
//       final List<String> messages = [];

//       errors.forEach((key, value) {
//         if (value is List) {
//           for (var msg in value) {
//             messages.add(msg.toString());
//           }
//         }
//       });

//       if (messages.isNotEmpty) {
//         return messages.join("\n"); // تفصل كل رسالة بسطر جديد
//       }
//     }
//     return defaultMessage;
//   }
// }
