# Udemy - RxSwift

해당 Repository는 `RxSwift`를 배우고 관련된 프로젝트를 남긴 공간입니다.

작업환경은 xcode 12.5, swift5 를 사용했습니다.





<br>







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

