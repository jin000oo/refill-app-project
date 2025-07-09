# Re:fill
> **프랜차이즈 매장을 위한 실시간 재고 관리 및 자동 발주 추천 시스템**


## 프로젝트 소개

**Re:fill**은 프랜차이즈 매장의 비효율적인 재고 및 발주 관리를 개선하기 위해 개발된 스마트 모바일 앱입니다. 

### 개발 배경
- 팀원들의 실제 프랜차이즈 카페 아르바이트 경험에서 출발
- 수기/엑셀 기반 재고 관리의 한계와 발주 누락 문제 해결
- 날씨, 공휴일 등 외부 변수에 대한 체계적 대응 부족

### 핵심 기능

#### 실시간 재고 관리
- 실시간 재고 수량 확인 및 수정
- 최소 수량 기반 자동 경고 시스템
- 권한별 재고 관리 기능 차별화

#### 스마트 발주 시스템
- 날씨 및 공휴일 기반 수요 예측
- 재고 부족 품목 자동 감지
- 카테고리별 발주 목록 관리
- 자동 발주 시간 설정 기능

#### 역할 기반 권한 관리
- **점주(Owner)**: 전체 매장 관리, 팀원 관리, 발주 권한
- **매니저(Manager)**: 재고 관리, 발주 권한 
- **직원(Staff)**: 재고 확인, 채팅 참여

#### 실시간 매장 채팅
- 매장 단위 그룹 채팅
- 역할별 아이콘 표시
- 읽음/미읽음 상태 확인
- 알림 배지 시스템

#### 날씨 기반 예측
- 주간 날씨 예보 연동
- 날씨 변화에 따른 수요 예측
- 예측 데이터 기반 발주 추천

## 기술 스택

### Frontend
- **Flutter** - 크로스 플랫폼 모바일 앱 개발
- **Dart** - 프로그래밍 언어
- **Provider** - 상태 관리

### Backend & Database
- **Firebase Authentication** - 사용자 인증
- **Cloud Firestore** - NoSQL 데이터베이스
- **Firebase Cloud Functions** - 서버리스 백엔드 로직

### External APIs
- **OpenWeatherMap API** - 날씨 정보 연동
- **Google Sign-In** - 소셜 로그인

## 시스템 아키텍처

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Flutter App   │◄──►│    Firebase      │◄──►│  External APIs  │
│                 │    │                  │    │                 │
│ • 사용자 인터페이스 │    │ • Authentication │    │ • Weather API   │
│ • 상태 관리       │    │ • Firestore DB   │    │ • Geolocator    │
│ • 권한별 화면     │    │ • Cloud Functions│    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 주요 화면

### 인증 & 온보딩
- 스플래시 화면
- 로그인/회원가입
- 초대 코드 입력
- 매장 생성

### 메인 기능
- 권한별 홈 화면
- 재고 관리 화면
- 발주 화면
- 예측/추천 화면

### 커뮤니케이션
- 실시간 채팅
- 알림 시스템

### 설정 & 관리
- 권한별 설정 화면
- 팀원 관리 (점주 전용)
- 발주 이력 확인

## 팀 구성

| 역할 | 이름 | 담당 업무 |
|------|------|-----------|
| **팀장** | 전유진 | Firebase 인증, 발주 시스템, 실시간 채팅, 자동 발주, 전반적 기능 구현 |
| **UI/UX** | 곽유나 | 홈 화면 UI, 앱 아이콘, 스플래시 화면, 전체 디자인 |
| **Frontend** | 김서영 | 전체 UI 구조 설계, 주요 화면 구현, 컬러 통일, 발표 자료 |
| **Backend** | 양진영 | Google 로그인, 설정 기능, Cloud Functions, 자동 발주 시스템 |

## 설치 및 실행

### 필요 환경
- Flutter SDK (3.0.0 이상)
- Dart SDK (2.18.0 이상)
- Android Studio / Xcode
- Firebase 프로젝트 설정

### 설치 과정

1. **저장소 클론**
```bash
git clone https://github.com/your-username/refill-app-project.git
cd refill-app-project
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **Firebase 설정**
- Firebase 콘솔에서 프로젝트 생성
- `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) 추가
- Firebase Authentication, Firestore 활성화

4. **앱 실행**
```bash
flutter run
```

## 프로젝트 구조

```
lib/
├── chat_service/          # 채팅 관련 기능
├── google_auth_service/   # Google 인증
├── home_service/          # 홈 화면 관련
├── login_service/         # 로그인 기능
├── order_service/         # 발주 관련 기능
├── providers/             # 상태 관리
├── setting_service/       # 설정 기능
├── main.dart             # 앱 진입점
├── main_navigation.dart  # 네비게이션 설정
└── colors.dart          # 색상 정의
```

## 라이선스

이 프로젝트는 교육 목적으로 개발되었습니다.

---

**개발 기간**: 2025.03.10 ~ 2025.06.16  
**프로젝트 유형**: 산학프로젝트1 (교과)
**소속**: 조선대학교 AI소프트웨어학부 (컴퓨터공학전공)