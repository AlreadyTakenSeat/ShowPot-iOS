# ShowPot
> 내한 공연 정보, 티켓팅 알림

## 소개
![최종](https://github.com/user-attachments/assets/3e3ea117-4900-48b0-9c81-1531445da3de)


## 기능
- 소셜로그인 기능 (카카오, 애플)
- 티켓팅 임박한 공연 및 추천 공연 조회 기능
- 전체 공연 목록 조회 기능
- 공연 세부 정보 조회 기능
- 공연 티켓팅 알림 시간(5분 전, 10분 전 30분 전, 60분 전) 설정 기능
- 알림 설정한 공연 조회 기능
- 관심 공연 설정 기능
- 장르 구독 및 구독 관리 기능
- 아티스트 구독 및 구독 관리 기능
- 아티스트 및 공연 검색 기능

| 티켓팅 예정 및 추천 공연 | 티켓팅 알림 설정 | 알림 설정한 공연 조회 | 장르 구독 | 
|:----------:|:----------:|:----------:|:----------:|
![Simulator Screen Recording - iPhone 16 Pro - 2025-04-24 at 00 44 21](https://github.com/user-attachments/assets/968b3d63-5f39-464f-8315-831100d09ab3) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-04-23 at 21 38 44](https://github.com/user-attachments/assets/f02b1a87-db75-4bcd-8cef-f0a211305f16) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-04-23 at 21 39 12](https://github.com/user-attachments/assets/7e2086d6-fab2-4864-a6d0-e77e8481aacd)  | ![Simulator Screen Recording - iPhone 16 Pro - 2025-04-23 at 21 27 30](https://github.com/user-attachments/assets/df9f0085-ac25-4630-8303-15bb27c89bcf)
| 아티스트 구독 | 아티스트 및 공연 검색 | 카카오 로그인 | 애플 로그인 |
![Simulator Screen Recording - iPhone 16 Pro - 2025-04-23 at 21 27 52](https://github.com/user-attachments/assets/841848bf-5927-4b93-87b7-f7191afc81d8) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-04-24 at 00 45 32](https://github.com/user-attachments/assets/96b5791d-ece8-4959-b08c-53323025b4ab) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-04-23 at 21 42 55](https://github.com/user-attachments/assets/6cd80104-39e4-4bb2-9d04-428254ebe92c) | ![Simulator Screen Recording - iPhone 16 Pro - 2025-04-23 at 21 43 27](https://github.com/user-attachments/assets/b8d83d24-2857-45d0-a803-22b00fa5643d)



## 기술
> `UIKit`, `MVVM`, `SnapKit`, `Kingfisher`, `Alamofire`, `Swift Concurrency`, `RxSwift`, `Unidirectional Architecture`, `Swift Dependencies`, `Clean Architecture`, `KakaoSDK`
- 직접 설계해 오픈소스로 배포한 단방향 아키텍처([RxCompse](https://github.com/ShapeKim98/RxCompose))를 이번 프로젝트에 적용하여 라이브러리의 적용 가능성과 실효성을 검증했습니다.
- 탭바의 클릭 이벤트를 `BehaviorSubject`로 방출하고, 이를 `UITabBarController`의 `selectedIndex`에 바인딩하여 커스텀 탭바를 구현했습니다.
- `DTO`를 활용해 외부 데이터를 클라이언트 기능에 적합한 형태로 가공하고, 외부 변경 사항에 유연하게 대응했습니다.
- `Data` 단의 주요 기능을 `Repository`로 추상화하여 비즈니스 로직과의 결합도를 낮추고, 재사용성을 높였습니다.
- `Feature` 단에 필요한 로직을 `UseCase`로 명시하여 `Feature` 계층과 `Data` 계층 간 의존성을 분리했습니다.
- `Swift Dependencies`의 `testValue`를 활용해 테스트 가능한 환경을 구성하고, `previewValue`를 통해 프리뷰 환경에서 목업 데이터를 제공하여 불필요한 API 호출을 줄였습니다.
- `Repository`를 `Protocol`이 아니라 메서드들을 클로저 형태로 인스턴스에 주입받는 구조체로 추상화하여, `Repository`의 인스턴스 접근을 통해 `UseCase`가 불필요한 의존 없이 꼭 필요한 메서드만 활용할 수 있도록 구성했습니다.
- `Router Pattern`과 `Generic`을 활용하여 네트워크 코드 추상화함으로써 `Alamofire` 기반 코드의 재사용성을 높였습니다.
- `Compositional Layout`을 활용해 하나의 화면에서 다양한 섹션과 각기 다른 셀 구성을 유연하게 지원했습니다.
- `visibleItemsInvalidationHandler`를 사용해 셀의 위치를 동적으로 계산하고, 위치에 따라 투명도 및 크기가 변하는 캐러셀(Carousel) 뷰를 구현했습니다.
