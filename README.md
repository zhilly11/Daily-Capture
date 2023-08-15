# 🏞️ 데일리 캡처
>오늘 하루를 기억할 수 있는 사진들과 함께 그날의 기록을 작성해보세요.

<br>

## 📜 목차
1. [프로젝트 및 개발자 소개](#-프로젝트-및-개발자-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [실행화면](#-실행-화면)
4. [구현 상세](#-구현-상세)
5. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
6. [프로젝트 수행 중 핵심 경험](#-프로젝트-수행-중-핵심-경험)

<br>

## 🗣 프로젝트 및 개발자 소개
>소개 : 
프로젝트 기간 : 2023-07 ~ 2023-08 (4주)

|[최지혁(@zhilly)](https://github.com/zhilly11)|[이주명(@vetto)](https://github.com/vetto)|
|:---:|:---:|
|<img src = "https://i.imgur.com/LI4k2B7.jpg" width=300 height=300>|<img src = "https://cdn.discordapp.com/attachments/535779947118329866/1055718870951940146/1671110054020-0.jpg" width=300 height=300>|


<br>

## ⚙️ 개발환경 및 라이브러리
- `iOS DeploymentTarget` : `16.0`
- `CocoaPod` : `1.12.1`
- `RxSwift` : `6.5.0`
- `RxCocoa` : `6.5.0`
- `SnapKit` : `5.6.0`

<br>

## 💻 실행 화면

| 메인 화면 | 작성화면1 | 작성화면2 | 검색화면 |
| :--------: | :--------: | :--------: | :--------: | 
| <img src = "https://hackmd.io/_uploads/S1fVZOv32.png" width=300 height=430> | <img src = "https://hackmd.io/_uploads/H193f_D2h.jpg" width=300 height=430> | <img src = "https://hackmd.io/_uploads/HJqJ7OP22.jpg" width=300 height=430> | <img src = "https://hackmd.io/_uploads/HkNlm_vhn.png" width=300 height=430> |


<br>

## 📚 구현 상세
- 기획부터 UI구성, 개발까지 진행한 사진 일기장 앱
- RxSwift, RxCocoa를 활용하여 MVVM 아키텍처로 구현
- iOS16에 공개된 UICalendarView를 활용하여 달력 기능을 구현
- CoreData를 활용해 사용자의 데이터를 관리하는 객체를 구현
- Code와 StoryBoard 두가지를 활용하여 UI 구현
- TableView Static Cell을 활용하여 화면 구현
- Custom Floating Button 구현

## 🎯 트러블 슈팅 및 고민
### CoreData 모델 구현 중 보안설정 에러 
- CoreData transformable한 변수를 만들때 보안설정을 해줘야하는 경고 발생했다.
- transformer에서 NSSecureUnarchiveFromData값으로 설정해주었다.
![](https://hackmd.io/_uploads/HkXsS_w2h.png)

### CoreData 'Create NSMangedObject Subclass' 버그
- CoreData NSMangedObject Subclass 파일을 만들때 `xcworkspace` 환경에서 만들면 설정한 folder로 생성 되지 않고 프로젝트 최상위로 생성 되어서 파일 위치를 옮기지 못하고 복사할 때에도 파일이 두개처럼 보이는 버그가 존재했다. 실제로는 이동이 되나 xcode상에서는 계속 존재했다.
- `xcodeproj` 환경에서 작업하니 정상 동작 하였다.

### 의존성 관리 도구
- 라이브러리 의존성 도구를 어떤것으로 사용할지 고민했다.
- SPM으로 RxSwift를 설치하기에는 종속성 에러가 발생한다고 문서에 기재되어있어 CocoaPods을 사용하기로 결정했다.

### TableView Static Cell
- Static Cell로 작업을 해야하는 상황에서 코드로 UI를 작성할 때 비효율 적인 코드들이 많이 발생했다.
- Static Cell을 활용해야하는 View는 StoryBoard를 활용해서 UI를 구현했다.

### NavigationBar에 Search Bar 추가
- NavigationBar에 Search Bar 추가할때 Title View가 없어지지 않는 문제가 발생했다.
- 따로 Search Bar를 구현해 레이아웃을 잡아주었다.

<br>

## 💡 프로젝트 수행 중 핵심 경험

- `RxSwift`를 활용한 `MVVM` 패턴 구현
- `SnapKit`을 이용한 `AutoLayout` 구현
- `Code`와 `StoryBoard`를 병합하여 UI 구현
- `CoreData`를 활용한 사용자 데이터 관리
- `CocoaPod`을 활용한 라이브러리 의존성 관리
- **`WWDC 22`** 에서 공개된 `UICalendarView`를 활용
