# Retro Messenger

2014년 피처폰 UI를 재현한 OTT 메신저 데모.

## 기능
- Firestore 기반 대화/메시지
- Cloud Functions 푸시 알림
- 오프라인 퍼스트
- Android POST_NOTIFICATIONS 권한
- iOS Push/Background 설정

## 개발 환경
Flutter 3 (Dart 3) 필요. Firebase 프로젝트를 구성하고 `google-services.json` / `GoogleService-Info.plist`를 각각 플랫폼에 추가하세요.

## 실행
```
flutter pub get
flutter run
```

## 테스트
```
flutter test
```

## 배포 주의
- iOS: Push Notification, Background Modes 활성화, PrivacyInfo.xcprivacy 제공
- Android: targetSdk 34, App/Privacy manifest 작성
- 선택 모듈 sms_import 는 Android 플레버에서만 포함

## 개인정보
- 앱 내 계정 삭제 기능 제공
- 개인정보 처리방침 링크 포함
