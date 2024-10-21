import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

class ApiService {
  Future<List<dynamic>?> uploadProperSpeaker(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://172.29.64.54:8000/upload-proper-speaker/'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      var result = json.decode(responseData.body);
      print("적합한 화자 데이터가 처리되었습니다: ${result['info']}");
      return result['mfcc'];
    } else {
      print("적합한 화자 업로드 에러: ${response.statusCode}");
      return null;
    }
  }

  Future<List<dynamic>?> uploadCompareSpeaker(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http:/172.29.64.54:8000/upload-compare-speaker/'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      var result = json.decode(responseData.body);
      print("비교 대상 화자 데이터가 처리되었습니다: ${result['info']}");
      return result['mfcc'];
    } else {
      print("비교 화자 업로드 에러: ${response.statusCode}");
      return null;
    }
  }
}


//   // 두 화자의 MFCC를 비교
//   Future<Map<String, dynamic>?> compareFiles(File file1, File file2) async {
//     // 두 파일의 MFCC를 각각 업로드하여 가져옴
//     var mfcc1 = await uploadProperSpeaker(file1);
//     var mfcc2 = await uploadCompareSpeaker(file2);
//
//     // MFCC 비교 요청
//     if (mfcc1 != null && mfcc2 != null) {
//       var request = await http.post(
//         Uri.parse('http://127.0.0.1:8000/compare-mfcc/'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'mfcc1': mfcc1,
//           'mfcc2': mfcc2,
//         }),
//       );
//
//       if (request.statusCode == 200) {
//         var result = json.decode(request.body);
//         bool isSameSpeaker = result['is_same_speaker'];
//         double similarity = result['similarity_score'];
//         print("유사도: $similarity, 같은 화자: $isSameSpeaker");
//         return {
//           'is_same_speaker': isSameSpeaker,
//           'similarity_score': similarity,
//         };
//       } else {
//         print("MFCC 비교 에러: ${request.statusCode}");
//       }
//     } else {
//       print("MFCC 추출 오류: 하나 이상의 파일에서 MFCC를 가져오는 데 실패했습니다.");
//     }
//     return null; // 에러 발생 시 null 반환
//   }

