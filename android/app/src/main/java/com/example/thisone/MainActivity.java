package com.example.thisone;  // 패키지명 변경

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Flutter 기본 스플래쉬 화면을 비활성화
        getSplashScreen().remove();
    }
}
