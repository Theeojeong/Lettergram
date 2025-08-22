# Lettergram (Retro Messenger)

피처폰(2G/3G) 감성의 문자 메시지(SMS/MMS) 데모. “목록 → 단일 메시지 1건 풀스크린” 읽기 경험과 “새 메시지: 수신인 → 본문 → (옵션) 첨부 → 전송” 흐름을 재현합니다.

## 주요 기능
- 메시지 홈: 새 메시지 작성(SMS/MMS) / 내 메시지(보조함 목록)
- 내 메시지: 받은함(Inbox) 기본 + Drafts/Outbox/Sentbox/Templates/Broadcast/Memory 상태(선택)
- 읽기: 목록 → 항목 선택 → 단일 메시지 전체화면, 좌/우 이동 버튼(데모)
- 쓰기: 수신인(번호) 입력 → 본문 입력 → (옵션) 멀티미디어 첨부(데모) → 전송
- 다크 테마, Firebase 미설정 상태에서도 UI 미리보기 가능

## 빠른 실행(웹 미리보기 + iPhone 프레임)
```
flutter pub get
flutter run -d chrome
```
실행 후 상단 Device Preview 툴바에서 iOS > iPhone 15 Pro Max를 선택하면 아이폰 화면 비율로 미리볼 수 있습니다. 저장 시 Hot Reload로 즉시 반영됩니다.

## 화면 흐름(요약)
- 대기화면 → [메뉴] → 메시지(`/`)
  - 새 메시지 작성 → 문자(SMS/MMS) → `/compose/new`
  - 내 메시지 → `/my`
    - 받은 편지함(Inbox) → `/inbox`
      - [목록] 날짜/번호/미리보기 → 항목 선택 → [단일 메시지 보기](`/letter/:id`)
- 단일 메시지 보기(`/letter/:id`)
  - 한 화면에 상대 메시지 1건만 표시, 이전/다음 이동(데모)
- 새 메시지 작성(`/compose/:id`)
  - 1) 수신인(번호) 2) 본문 3) (옵션) 멀티미디어 첨부 4) 전송

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
