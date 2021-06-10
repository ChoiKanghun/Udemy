# Udemy - RxSwift

해당 Repository는 `RxSwift` 및 `RxCocoa`를 배우고 관련된 프로젝트를 남긴 공간입니다.

작업환경은 xcode 12.5, 언어는 swift5 입니다.

공부한 기록을 `Learning RxSwift` 폴더에 남겨두었습니다.



<br>



![UC-e9f93d96-2f28-421e-9c63-cb79e007367c](https://user-images.githubusercontent.com/41955126/121474689-60095580-c9ff-11eb-9f86-37ba42af2303.jpeg)



<br>



# Project 1 - CameraFilter



<br>



## 프로젝트 설명

RxSwift의 Observe + Subscribe 기능을 사용해보기 위해 만든 카메라 필터 앱입니다.

사진을 선택하고 filter 버튼을 누르면 선택한 사진에 특정 필터 기능이 적용됩니다.



<br>



예제)

![CameraFiltersimulation](https://user-images.githubusercontent.com/41955126/118944563-a420b180-b98f-11eb-9664-f176dc496793.gif)





<br>



## 프로젝트에서 RxSwift 를 사용한 부분

설명에 앞서 전제하고 싶은 것은 위의 이미지(gif)에도 나와있듯이 

첫 번째 화면의 '+' 버튼을 클릭하면 앨범에서 사진을 고를 수 있는 화면으로 넘어가고,

두 번째 화면에서 사진을 고르면 첫 번째 화면에서 해당 사진을 띄워줍니다.

그리고 첫 번째 화면에서 apply filter를 누르면 필터가 적용됩니다.

편의상 첫 번째 viewController를 firstViewController,

두 번째 viewController를 secondViewController라고 하겠습니다.



<br>



총 두 가지 부분에서 RxSwift를 사용해보았습니다.

RxSwift를 사용한 부분들을 차례로 설명하겠습니다.



<br>



### 1) 앨범에서 어떤 이미지를 선택한 경우 그것을 감지하도록 설정하는 데 사용

먼저 앨범리스트에 있는 이미지들 중 하나를 선택하는 경우 해당 이미지를 imageView에 넣기 위해 RxSwift를 사용하였습니다. 구체적으로는 먼저 앨범에서 사진을 고를 secondViewController에

```swift
    private let selectedPhotoSubject = PublishSubject<UIImage>()
		var selectedPhot: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
```





위와 같은 코드를 적어주어 Subject와 Observable 변수를 선언하고,



<br>



```swift
  	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController 
      					= segue.destination as? UINavigationController,
              let photosCollectionViewController 
      					= nextViewController.viewControllers.first 
      						as? PhotosCollectionViewController
        else { fatalError("segue destination is not found")}
        
        photosCollectionViewController.selectedPhot
            .subscribe(onNext: { [weak self] photo in
                DispatchQueue.main.async {
                    self?.updateUI(with: photo)
                }
            }).disposed(by: disposeBag)
    }


    private func updateUI(with photo: UIImage) {
        self.photoImageView.image = photo
        self.applyFilterButton.isHidden = false
    }
```

위의 코드를 통해 nextViewController의 selectedPhot 변수를 subscribe합니다. 

selectedPhot의 onNext로 어떤 데이터가 들어오면 해당 데이터(이미지)를 firstViewController의 imageView에 넣어줍니다. UI를 DispatchQueue에서 처리해주기 위해 DispatchQueue.main.async에 넣었습니다.



<br>



그리고 secondViewController에서 앨범의 사진을 클릭했을 때, 그러니까 정확히는 `didSelectItemAt` 함수가 호출될 때

`self?.selectedPhotoSubject.onNext(image)` 를 통해 onNext 메서드를 호출하여 firstViewController에서 선택한 이미지를 받아오도록 하였습니다.



<br>



### 2) FilterService가 이미지를 받아오는 데에 사용

원래는 filter기능을 구현한 함수를 FilterService.swift 라는 파일 안에 넣고, 다른 곳에서 호출하여 쓸 수 있게 했었습니다.

그 함수란 아래와 같은 것이었는데요.

```swift
		func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            if let cgImage = self.context.createCGImage(
                filter.outputImage!,
                from: filter.outputImage!.extent) {
                
                let processdImage
                    = UIImage(cgImage: cgImage,
                              scale: inputImage.scale,
                              orientation: inputImage.imageOrientation)
                completion(processdImage)
            }
        }
    }
```

위 코드는 어떤 `UIImage`를 받아서 이미지 필터 과정을 거친 후 필터링 된 이미지를 반환합니다.



<br>



이것을 RxSwift를 이용하여 `observable<UIImage>`를 만드는 것과 동시에 inputImage를 받고 해당 이미지를 filter시켜서 onNext() 메서드를 호출하도록 하였습니다. 그리고 그것을 firstViewController에서 filter버튼을 누를 때마다 구독하면 매번 filter된 이미지를 받아올 수 있습니다.

코드는 다음과 같았습니다:



<br>



FilterService.swift

```swift
		func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable<UIImage>.create { (observer) in
            self.applyFilter(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }

	  private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            if let cgImage = self.context.createCGImage(
                filter.outputImage!,
                from: filter.outputImage!.extent) {
                
                let processdImage
                    = UIImage(cgImage: cgImage,
                              scale: inputImage.scale,
                              orientation: inputImage.imageOrientation)
                completion(processdImage)
            }
        }
    }
```



<br>



viewController

```swift
    @IBAction func touchUpApplyFilterButton(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image
        else {
            print ("can't get source Image")
            return
        }
      
				// applyFilter -> filteredImage        
        FilterService().applyFilter(to: sourceImage) 
            .subscribe(onNext: { (filteredImage) in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)   
    }
```



<br>



# Project 2 - ToDo(프로젝트명 MockTrello)



두 번째 프로젝트인 MockTrello는 아래 사진과 같이 작업을 등록하고, 작업의 우선순위에 따라 필터링하여 화면에 나타내주는 프로젝트입니다.



<br>



![MockTrello](https://user-images.githubusercontent.com/41955126/119765081-771f5200-beed-11eb-9ee6-fa172a9888f9.gif)



<br>



## RxSwift, RxCocoa를 이용하여 필터링

MockTrello 프로젝트에서는 `Title, Priority` 라는 멤버를 가지는 구조체 Task를 사용자가 입력하고, 

입력한 정보를 우선 순위(Priority)에 따라 필터링하여 보여줍니다.

이 과정에서 발행한 Task를 subscribe과 dispose하는 부분은 RxSwift 를 이용했고, subscribe하여 들어오는 값에 대해 저장하는 부분은 RxCocoa의 BehaviorRelay를 이용하였습니다. 



<br>



자세한 코드는 [여기 Repository](https://github.com/ChoiKanghun/Udemy/tree/main/MockTrello/MockTrello)를 확인해주세요 !



<br>



# Project 3 - NewsAPI

newsAPI 는 `newsapi.org`에서 제공하는 API를 이용해 테이블뷰로 받아온 데이터를 나타내는 앱입니다.

데이터를 뿌리는 과정에서 RxSwift와 RxCocoa를 이용했습니다.



<br>



<img src="https://user-images.githubusercontent.com/41955126/120973778-54712100-c7aa-11eb-8248-3993621cbc16.gif">





<br>



## Rx를 쓰기 전의 사전 준비



먼저 newsapi를 요청하면 다음과 같은 데이터가 들어옵니다.

들어온 데이터 중에서 `articles` 배열의 `title, description` 만 가지고 테이블뷰에 나타냅니다.



<br>



```swift
{
"status": "ok",
"totalResults": 38,
"articles": [
		{
		"source": {
				"id": null,
				"name": "CNET"
		},
		"author": "Mark Serrels",
		"title": "Logan Paul vs. Floyd Mayweather Jr. results: An anticlimactic affair with no winners - CNET",
		"description": "The fight is over and it was... not good.",
		"url": "https://www.cnet.com/news/logan-paul-vs-floyd-mayweather-jr-results-an-anticlimactic-affair-with-no-winners/",
		"urlToImage": "https://www.cnet.com/a/img/KJYrS6sSWpki1VhBRiSIpDNDI7w=/1200x630/2021/06/04/aec14e3b-21b7-48b2-bd07-8d761cda0bbe/gettyimages-1232731155.jpg",
		"publishedAt": "2021-06-07T04:04:00Z",
		"content": "Well, that sucked.\r\nCliff Hawkins/Getty Images\r\nThe Floyd Mayweather vs. Logan Paul fight is over. Given it was an exhibition, no winner was declared, but Floyd mostly did what he wanted, with an inc… [+9261 chars]"
		},
		{
		"source": {
				"id": "reuters",
				"name": "Reuters"
		},
		"author": "Renju Jose",
		"title": "Australia's Victoria logs biggest rise in COVID-19 cases in a week - Reuters",
		"description": "Australia's Victoria state on Monday reported its biggest rise in new locally acquired COVID-19 cases in nearly a week as authorities scramble to track the source of the highly infectious Delta variant found among infections.",
		"url": "https://www.reuters.com/world/asia-pacific/australias-victoria-reports-biggest-rise-covid-19-cases-week-2021-06-06/",
		"urlToImage": "https://www.reuters.com/resizer/7_54IbgIWtEy2-pWN3VgtXf8SY4=/1200x628/smart/filters:quality(80)/cloudfront-us-east-2.images.arcpublishing.com/reuters/WT5NSAFU7ZN7DNDBVAXIN2A4AY.jpg",
		"publishedAt": "2021-06-07T03:25:00Z",
		"content": "An empty Queen Victoria Market is seen on the first day of a seven-day lockdown as the state of Victoria looks to curb the spread of a coronavirus disease (COVID-19) outbreak in Melbourne, Australia,… [+2367 chars]"
		},
		{
		  ...
```



<br>



이러한 상황에서 model은 다음과 같이 설계했습니다.

하나의 Article은 title과 description을 가지고,

ArticleList는 article 여러 개를 가지는 배열입니다.

그리고 articlesList는 Decodable한 모든 자료형을 받을 수 있는 Resource 타입의 all을 가집니다.

이 all은 url을 가지고 있습니다. url은 newsapi를 GET할 메서드입니다.



<br>



```swift
import Foundation
/* 참고
struct Resource<T: Decodable> {
    let url: URL
}
*/
struct ArticlesList: Decodable {
    let articles: [Article]?
    
}

extension ArticlesList {
    static var all: Resource<ArticlesList> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e9b514c39c5f456db8ed4ecb693b0040")!
        return Resource(url: url)
    }()
}

struct Article: Decodable {
    let title: String?
    let description: String?
}
```



<br>



## RxSwift, RxCocoa를 적용한 부분.



### flatMap, map, Observable, rxControl

먼저 URLRequest를 약간 수정해서 사용했습니다.

URLRequest 시 load를 호출하면 

어떤 url을 갖고 있는 resuorce에 대해 

URLRequest를 요청하고, 

`URLSession.shared.rx.data`로 데이터를 받아오면

.map을 통해 data를 decode하여 반환하고,

그 반환값을 다시 Observable하게 리턴합니다.

```swift
extension URLRequest {
    
    static func load<T>(resource: Resource<T>) -> Observable<T?> {
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T? in
                return try? JSONDecoder().decode(T.self, from: data)
            }.asObservable()
    }
    
}
```



<br>



그리고 위 URLResquest의 load를 가지고

테이블뷰 데이터를 뿌려주는 곳에서는 load의 결과를 subscribe하고

result에 담긴 articles 정보를 가져와서 테이블뷰에 나타냅니다.



<br>



### dispose

```swift
 URLRequest.load(resource: ArticlesList.all)
            .subscribe(onNext:  { [weak self] result in
                if let result = result,
                   let articles = result.articles {
                    self?.articles = articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
        
```



<br>



# WeatherApp

어떤 도시의 이름을 입력 받아 해당 도시의 기온 및 습도를 가져오는 앱입니다.



<br>



<img src="https://user-images.githubusercontent.com/41955126/121124684-48479b00-c860-11eb-8b54-60754c930996.gif">



<br>



## 전제 조건

먼저 `api.openweathermap.org` 에 가입하셔서 apikey를 가져오셔야 합니다.

다음 url을 통해 받아올 수 있으며,

```
http://api.openweathermap.org/data/2.5/weather?q=seoul&appid={YourAPIKey}&units=metric
```

아래와 같은 결과를 가져옵니다.



<br>



```json
{
  ...
	main: {
		temp: 12.42,
		pressure: 1123,
		humidity: 100,
		temp_min: 12.00,
		temp_max: 23.23
	},
  ...
}
```



<br>



이에 맞게 다음과 같이 Model을 작성했습니다:

```swift
struct WeatherResult: Codable {
    let main: Weather
}

struct Weather: Codable {
    let temp: Double
    let humidity: Double
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
```



<br>



## RxSwift 및 RxCocoa를 사용한 부분





먼저 API 데이터를 가져오기 위해 URLSession을 사용할 때 Rx의 개념을 사용했습니다.

flatMap을 이용해 URLSession이 받아오는 data를 Observable하게 받아오고,

해당 data를 다시 map으로 decode하여 원하는 값을 T에 넣어 observable로 반환하도록 하였습니다.



### flatmap, map, asObservable, rxControl



```swift
struct Resource<T> {
    let url: URL
}

extension URLRequest {
    
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }.asObservable()
    }
    
}
```



<br>



### driver(bind), observeOn



위의 load는 아래처럼 resource에 url을 넣어 사용했으며,

load의 결과는 `Driver`를 사용할 수 있게끔 `asDriver`를 사용하여 search에 넣어주었습니다.



```swift
        let resource = Resource<WeatherResult>(url: url)
        
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: WeatherResult.empty)
        
```





<br>



그리고 아래처럼 `drive`를 사용해 search에 담긴 main 정보를 알맞은 label에 담아주었습니다.



```swift
// drive
        search.map { "\($0.main.temp) ℃" }
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity) 💦"}
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
```



<br>



### rxControlEvent

그리고 cityNameTextField의 text의 편집이 끝났을 때 특정 메서드가 동작하도록 하기 위해 `rx.controlEvent`를 사용하였습니다.

```swift
self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
```



