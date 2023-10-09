# DWeather

## 📄프로젝트 소개
아이폰의 기본 날씨앱과 비슷하게 API를 통해 날씨정보를 보여줍니다.

## 🕰️개발기간
2023.08 ~ 2023.09

## 🖥️개발환경
xcode 14.3.1

iOS 16.4

## 📱주요기능

### 주소 확인
  CoreLocation을 이용해 현재 위치(위도, 경도) 확인.
  확인한 주소를 동으로 가공.
  
### 날씨 확인
  확인한 위치를 기반으로 날씨 API(OpenWeatherAPI)에서 현재 날씨, 시간별 날씨, 일별 날씨를 받아옴.
  
  현재 날씨를 맨 위에 현위치와 함께 표시.
  
  시간별 날씨를 향후 20시간만큼 한시간 단위로 표시.
  
  요일별 날씨를 향후 7일간, 하루마다 표시.
  
  현재 날씨에 대한 기타 내용(습도, 기압 등)을 표시.

## 기타

### 배운점
• CustomTableView를 이용해 뷰를 구성할 수 있었다.

• CustomTableView안에 Custom Collection View를 넣어 뷰를 구성할 수 있었다.

• URLSession을 어떻게 사용하는지, URLSession을 이용해 JSON데이터를 받아오고 파싱하는 방법까지 알았다.

• CoreLocation을 이용해 위도, 경도를 받아올 수 있었다.

• DateFormatter를 이용해 타임스탬프를 원하는 형태로 가공해 표시할 수 있었다.


### ⚙️기술 스택
• Swift

• MVC(리팩토링 중)

• TableView

• CollectionView

• URLSession

• CoreLocation

### 사용한 API
  OpenWeatherAPI
  
### 사용한 라이브러리
  Kingfisher

## 🏙️작동 화면
![Simulator Screenshot - iPhone 15 - 2023-09-30 at 12 05 29](https://github.com/jjw8959/DWeather/assets/76551806/29cf5045-d393-456e-ac4d-21d5f43d4c35)
![Simulator Screenshot - iPhone 15 - 2023-09-30 at 12 05 44](https://github.com/jjw8959/DWeather/assets/76551806/b957b41b-44ca-4b85-9b0e-7401ecd4d3c3)

https://github.com/jjw8959/DWeather/assets/76551806/959f8e25-7188-4106-8298-f2e3ae47adc6



