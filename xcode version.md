# 개요

2020년 6월 22일, xcode 버전이 12로 올라가면서 버전 11보다 더 많은 기능을 제공하게 됐다.

xcode 12에는 iOS 14, iPadOS 14, tvOS 14, watchOS 7, swift 5.3에 대한 SDK 들이 추가되었다. 

또한 텍스트의 사이즈가 시스템이 지정한 크기와 일치하게, 작게, 중간, 크게로 설정할 수 있게 됐다.

macOS Big Sur에 최적화된 디자인으로 바뀌었다.



## 유니버셜 앱에 대한 지원 확장

유니버셜 앱이란 iOS, ipadOS, 맥OS 모두를 지원하는 앱을 말하는데, xcode12부터 Apple 실리콘 맥북(m1칩 맥북)을 지원하는 앱을 만들 수 있게 되었다. xcode12를 사용하기 위해서는 OS 버전이 최소 macOS catalina 10.15.4 이상이어야 한다.



<br>



## swiftUI

swiftUI에 대한 지원이 확장됐다. xcodeproj 파일을 만들 때 최초로 라이프 사이클이 UIKit 기반인지 SwiftUI 기반의 앱인지 물어보는 칸도 생겼다. Swift UI 뷰를 다른 개발자와 공유할 수 있게 됐다.



<br>



<img src="https://miro.medium.com/max/954/1*HEEN6bsghNdC0RMdM-tGOQ.jpeg">



<br>



## 네비게이터 글꼴 사이즈

xcode를 켜면 기본적으로 왼쪽에 파인더, 가운데에 코드, 오른쪽에 속성창이 뜬다.

여기서 왼쪽에 있는 것을 네비게이터라고 하는데, 해당 네비게이터의 글꼴 및 아이콘 사이즈를 설정할 수 있게 됐다. 글자크기는 finder 설정 기반이다.



<br>



<img width="955" alt="스크린샷 2021-06-02 오후 3 08 04" src="https://user-images.githubusercontent.com/41955126/120438727-b1409600-c3bc-11eb-85f5-34c909391b03.png">



<br>





<img width="954" alt="스크린샷 2021-06-02 오후 3 08 20" src="https://user-images.githubusercontent.com/41955126/120432189-86524400-c3b4-11eb-977c-3cf87d8eef1a.png">



<br>



## 코드완성

코드 자동완성이 좀더 빨라졌다. 좀더 간소하고 필수적인 정보를 제공하여 자동완성이 화면에 뜨는 속도를 높였다. 



<br>



## xcode Organizer 기능향상

- 막대그래프 및 scroll-hitch 메트릭스를 표시한다. 이 메트릭을 이용해 애니메이션 delay가 얼마나 일어나는지 확인할 수 있다. scrolling 섹션의 Metrics Organzier 윈도우에서 확인 가능하다.

- xcode organizer가 이제 진단 보고서를 제공한다. 이 리포트를 이용해 앱을 최적화할 수 있다. 해당 보고서는 Reports 섹션의 Disk Writes item을 선택하면 된다.



<br>



## 시뮬레이터

- 이제 시뮬레이터를 full-screen 모드로 실행할 수 있고, 시뮬레이터를 xcode 위에 바로 띄워놓을 수 있다. 이를 위해서는 Window 섹션의 Stay On Top을 클릭하면 된다.
- 시뮬레이터는 맥북(아이맥) 자체 오디오를 사용한다. 이것의 설정을 변경하려면 ` I/O -> Audio Input -> System`의 설정을 변경하면 된다.
- watchOS7의 시뮬레이터가 64비트 프로세스를 지원한다. 시뮬레이터가 64비트인지 확인하기 위해서는 `ARCHS` 가 default로 설정되어 있는지 확인하면 된다.
- 시뮬레이터가 내 주변 기기들과의 거리 및 방향을 나타내는 기능을 제공한다. 두 개의 시뮬레이터를 띄워놓은 경우 다음과 같이 방향 정보 및 거리가 출력된다.



<br>



<img src="https://miro.medium.com/max/1400/1*jT76eBALE4hq4zlhvZkq-w.jpeg">

이에 대한 자세한 설명 [링크]([Meet Nearby Interaction - WWDC 2020 - Videos - Apple DeveloperThe Nearby Interaction framework streams distance and direction between opted-in Apple devices containing the U1 chip…developer.apple.com](https://developer.apple.com/videos/play/wwdc2020/10668/))



<br>



## Swift Packages

- Swift Pacakges의 타겟 의존성에 대한 조건을 걸 수 있다. 
- Swift Packages는 이미지, 애셋 카탈로그, 스토리보드 외 많은 파일들을 포함시킬 수 있다.([설명링크](https://developer.apple.com/documentation/swift_packages/bundling_resources_with_a_swift_package))



<br>



## Playgrounds

- Xcode Playgrounds가 이제 Swift Pacakges와 framework를 import할 수 있게 됐다. playground의 File Inspector에 있는 `Build Active Scheme` 체크박스를 선택하면 된다.  이 경우 active scheme 이 package나 fraework 타겟을 제대로 build하는지 확인하자.
- Xcode의 Report Navigator가 이제 Playground build log를 포함한다.
- playgrounds가 이제 asset catalog를 지원한다.



<br>



## 인터페이스 빌더

- Find & Replace에 attributed string literal 검색을 포함한다.
- 인터페이스 빌더가 이제 현재 시간 옵션인 `NSDatePicker`를 가진다.
- macOS 11에서 SF 심볼이 추가되었다.
- macOS 11의 NSView에 safeAreaLayoutGuide가 지원된다.
- UIButton이 dismiss



<br>



## 맥 카탈리스트(Catalyst)

- Mac idiom은 앱의 유저 인터페이스를 100% 맥 사이즈로 표현한다. 
- 더 많은 프레임워크가 사용가능해졌다. HomeKit과 AVCapture 등.
- 키보드 API와 OS의 통합으로 키보드를 통한 앱 컨트롤이 더 용이해졌다.
- Mac Catalyst를 가지고 만든 앱은 OS 버젼 Big Sur만의 느낌이 나도록 바뀌었다.



<br>



## 기타

앱 클립은 더 빠르게 설치될 수 있도록 바뀌었고, StoreKit 테스팅 프레임워크 및 트랜잭션 메니저는 in-app 구매 테스트를 좀 더 쉽게 할 수 있도록 개선됐다.



<br>



출처

- https://developer.apple.com/xcode/whats-new/
- https://developer.apple.com/kr/xcode/
- https://developer.apple.com/kr/xcode/whats-new/

