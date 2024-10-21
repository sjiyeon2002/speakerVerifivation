import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'fastapi.dart'; // ApiService 클래스 import

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

AudioPlayer player = AudioPlayer(); // 오디오 플레이어 객체 만들기

class _HomeState extends State<Home> {
  String? _selectedFileName1; // 첫 번째 음성파일 이름
  String? _selectedFileName2; // 두 번째 음성파일 이름
  List<dynamic>? _mfcc1; // 첫 번째 파일의 MFCC 결과
  List<dynamic>? _mfcc2; // 두 번째 파일의 MFCC 결과
  File? _audioFile1; // 첫 번째 음성파일
  File? _audioFile2; // 두 번째 음성파일

  final ApiService _apiService = ApiService(); // ApiService 인스턴스 생성

  /*확장자검사 및 파일업로드 구역*/
  Future<void> _openFilePicker1() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'm4a', 'mp4'],
    );
    if (result != null) {
      final extension = result.files.single.extension;
      if (extension == 'mp3' || extension == 'm4a' || extension == 'mp4') {
        setState(() {
          _selectedFileName1 = result.files.single.name;
          _audioFile1 = File(result.files.single.path!);
        });
        await _extractMFCC1();  // FastAPI 통신
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('첫 번째 파일의 확장자 에러')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('첫 번째 파일이 선택되지 않았습니다.')),
      );
    }
  }

  Future<void> _openFilePicker2() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'm4a', 'mp4'],
    );
    if (result != null) {
      final extension = result.files.single.extension;
      if (extension == 'mp3' || extension == 'm4a' || extension == 'mp4') {
        setState(() {
          _selectedFileName2 = result.files.single.name;
          _audioFile2 = File(result.files.single.path!);
        });
        await _extractMFCC2();  // FastAPI 통신
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('두 번째 파일의 확장자 에러')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('두 번째 파일이 선택되지 않았습니다.')),
      );
    }
  }

  /*fastapi로 보내서 mfcc추출하는 구역*/
  Future<void> _extractMFCC1() async {
    if (_audioFile1 == null) return;
    print("적합한 화자 업로드 요청을 보냅니다: ${_audioFile1!.path}");
    final mfcc = await _apiService.uploadProperSpeaker(_audioFile1!);
    print("서버로부터 받은 MFCC 데이터: $mfcc");
    if (mfcc != null) {
      setState(() {
        _mfcc1 = mfcc; // MFCC 결과 저장
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('첫 번째 파일의 MFCC 추출에 실패했습니다.')),
      );
    }
  }

  Future<void> _extractMFCC2() async {
    if (_audioFile2 == null) return;
    print("적합한 화자 업로드 요청을 보냅니다: ${_audioFile1!.path}");
    final mfcc = await _apiService.uploadCompareSpeaker(_audioFile2!);
    print("서버로부터 받은 MFCC 데이터: $mfcc");
    if (mfcc != null) {
      setState(() {
        _mfcc2 = mfcc; // MFCC 결과 저장
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('두 번째 파일의 MFCC 추출에 실패했습니다.')),
      );
    }
  }

  /*앱 화면 구성하는 구역*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "화자검증 어플리케이션 데모버전",
          style: TextStyle(fontSize: 16), // 글자 크기 키움
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE0E0),
              Color(0xFFE0F7FA),
            ],
            stops: [0.5, 0.5],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // 첫 번째 파일 업로드 버튼
              Column(
                children: [
                  const Text(
                    '적합한 화자의 파일 업로드',
                    style: TextStyle(fontSize: 18), // 글자 크기 키움
                  ),
                  ElevatedButton(
                    onPressed: _openFilePicker1,
                    child: const Text('파일 선택', style: TextStyle(fontSize: 20)), // 버튼 텍스트 크기 키움
                  ),
                  _selectedFileName1 != null
                      ? Text('선택된 파일: $_selectedFileName1', style: const TextStyle(fontSize: 18)) // 글자 크기 키움
                      : Container(),
                  if (_mfcc1 != null)
                    const Text('특징 추출이 완료되었습니다.', style: TextStyle(fontSize: 18)), // 글자 크기 키움
                ],
              ),

              // "비교하기" 버튼
              ElevatedButton(
                onPressed: () {}, // 아직 기능 없음
                child: const Text('비교하기', style: TextStyle(fontSize: 20)), // 버튼 텍스트 크기 키움
              ),

              // 두 번째 파일 업로드 버튼
              Column(
                children: [
                  const Text(
                    '비교 대상 화자의 파일 업로드',
                    style: TextStyle(fontSize: 18), // 글자 크기 키움
                  ),
                  ElevatedButton(
                    onPressed: _openFilePicker2,
                    child: const Text('파일 선택', style: TextStyle(fontSize: 20)), // 버튼 텍스트 크기 키움
                  ),
                  _selectedFileName2 != null
                      ? Text('선택된 파일: $_selectedFileName2', style: const TextStyle(fontSize: 18)) // 글자 크기 키움
                      : Container(),
                  if (_mfcc2 != null)
                    const Text('특징 추출이 완료되었습니다', style: TextStyle(fontSize: 18)), // 글자 크기 키움
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
