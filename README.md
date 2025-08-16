# Lettergram (Retro Messenger)

레터감성의 메신저 데모. iPhone 메모앱 느낌의 간결한 UI와 “편지 장면”에 집중한 읽기 경험을 제공합니다.

## 주요 기능
- 받은/보낸/임시/문집 우체통 탭 UI (열림/닫힘 봉투 아이콘으로 상태 표시)
- 편지 열람: 본문 중심 레이아웃(시간 → 발신자 이름 → 전화번호)
- 답장 화면: 종이/잉크 없이 간결한 메모장 입력, 프롬프트 힌트 토글
- 다크 테마 기본 적용(읽기 대비 최적화)
- Firebase 미설정이어도 UI 미리보기 가능(실사용 시 Firebase 설정)

## Demo 화면
<img width="421" height="843" alt="image" src="https://github.com/user-attachments/assets/322b058b-ea83-41a0-af62-f84efb0f21f0" />

<img width="425" height="844" alt="image" src="https://github.com/user-attachments/assets/ed162bd8-fdd3-474b-9bfc-8705e4c25a92" />


## 빠른 실행(웹 미리보기 + iPhone 프레임)
```
flutter pub get
flutter run -d chrome
```
실행 후 상단 Device Preview 툴바에서 iOS > iPhone 15 Pro Max를 선택하면 아이폰 화면 비율로 미리볼 수 있습니다. 저장 시 Hot Reload로 즉시 반영됩니다.

## 화면 흐름(요약)
- 우체통(홈)
  - 상단: 대제목(우체통), 검색, 세그먼트(받은/보낸/임시/문집)
  - 받은함: 봉투 아이콘(닫힘=미개봉, 열림=개봉), 제목 중심 타이포
  - 항목 탭 → 편지 열람으로 이동(`/letter/:id`)
- 편지 열람(`/letter/:id`)
  - 구성: 본문 → ‘3:12 PM’ → 발신자 이름(세미볼드) → 전화번호
  - 하단: [메뉴] [확인] [답장] (확인=받은함으로 이동)
- 답장 작성(`/compose/:id`)
  - 프롬프트 힌트 토글만 제공, 박스 없는 입력 영역(메모장 스타일)

## iOS(TestFlight) 배포 개요(Codemagic)
- 레포에 `codemagic.yaml` 포함(워크플로: `ios_testflight`)
- App Store Connect에서 앱 생성: 번들 ID `com.theeojeong.lettergram`, 이름 `lettergram`
- Codemagic 시크릿 등록: `IOS_DEVELOPMENT_TEAM`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_KEY_IDENTIFIER`, `APP_STORE_CONNECT_PRIVATE_KEY`
- 빌드 후 TestFlight Processing(5~20분) → 내부 테스터 초대 → iPhone TestFlight 앱으로 설치

## 번들/패키지 식별자
- iOS: `com.theeojeong.lettergram`
- Android: `com.theeojeong.lettergram`

## 로컬 개발 팁
- Firebase 없이도 UI는 동작합니다. 실사용 시 `google-services.json`/`GoogleService-Info.plist` 추가.
- iOS 최소 버전: 13.0
- 웹에서 같은 네트워크의 iPhone으로 접속하려면:
  ```
  flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
  ```
  iPhone Safari에서 `http://<PC-IP>:8080` 접속

## 테스트
```
flutter test
```

## 라이선스/개인정보
- 내부 데모용. 외부 배포 시 앱 내 계정 삭제/정책 링크/권한 고지 등을 점검하세요.
