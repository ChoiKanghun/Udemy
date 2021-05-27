# Udemy RxSwift

## 전제조건 <i>Prerequisite </i>

난이도는 중간~고급 수준이기 때문에 초급 단계는 마쳐야 한다.

이 강의는 RxSwift를 위주로 전개된다.



<br>



# functional programming 이란

예를 들어 

```swift
var age = 30
age = 45
```

라는 코드가 있다고 하자. 



이것은 명령형 프로그래밍에서는 '알맞은' 예시가 될 것이다.



<br>



반면에 다음과 같은 코드가 있다고 하자.

```swift
// age의 값이 someFunction 이후로 바뀔까?
var age = 30
age = 45

func someFunction() {
  print("Hellllo")
  age = 75
}

print(age)
someFunction()
print(age)
```

함수형 프로그래밍에서는 age의 값을 함수 내에서 바꿀 수 없다.

위 예제에서도 마지막 age는 값이 45로 그대로다.

이런 함수를 이용한 함수형 프로그래밍은 

concurrency를 보장하지 못하거나 deadlock 등 객체지향프로그래밍에서 나타날 수 있는

부작용을 최대한 없앨 수 있는 프로그래밍이다.

설명이 빈약하게 느껴질 것이다.

앞으로는 reactive functional programming이란 무엇인지 

iOS를 가지고 설명할테니 쭉 따라가보자.



<br>



# RxSwift

# 개념

RxSwift는 비동기적으로 프로그램을 돌아가게 만드는 것이다.

내 코드가 새로운 데이터에 반응하게 만들고, 시퀀스대로 진행시킬 수 있게 만드는 것이다.





<br>



예를 들어 한 테이블뷰가 올라간 뷰를 보고 있다고 가정하자.

테이블뷰에는 여러 가지 셀들이 올라가 있는 상태다.

각각의 셀들은 이미지와 텍스트를 가진다.

또한 화면에는 탭바가 올라가 있어서 탭바를 클릭시 또다른 화면으로 전환된다고 하자.



<br>



여기에서 각각의 기능들이 비동기적으로 움직이게 만들기 위해서는 

우리는 다음과 같은 것들을 사용해야 한다:

`NotificationCenter`, `Delegate Pattern`, `Grand Central Patch`, `Closures` 



<br>



RxSwift 는 이러한 비동기적 처리를 도와주는 것이다.

RxSwift 는 CocoaPods를 통해 install 한 뒤 사용가능하다.

podfile에는 다음을 추가하여 install할 수 있다.

`pod 'RxSwift', '~> 4.0'`

뒤에 있는 숫자는 버전이며, 버전 정보는 `https://cocoapods.org`에서

RxSwift를 검색하여 찾을 수 있다.

pod install에 성공했다면 .xcworkspace file을 시작하면 된다.

(프로젝트 명이 RxSwift이면 안 된다!)



<br>



## 잘 되는지 테스트하기

기본적으로 생성되는 ViewController.swift 파일 안에

`import RxSwift`를 해주고

viewDidLoad 내에 

`_ = Observable.from([1, 2, 3, 4, 5])`를 적어준 뒤 실행해보자.

오류 없이 실행된다면 잘 설치된 것이다.



<br>



## Playground 생성

playground를 하나 생성해주자. file->new에서 생성할 수 있다.

그리고 해당 플레이그라운드 프로젝트 폴더에 add해준다.

프로젝트에서 `폴더 우클릭-add Files to ...` 로 할 수 있다.

여기까지 했다면 방금 적어준 코드를 playground 파일에 넣고 실행해보자.

```swift
import RxSwift

_ = Observable.from([1, 2, 3, 4, 5])
```





<br>



# Observable

RxSwift의 핵심은 Observable이다.

Observable은 Sequence라고도 한다.

Observable은 string이든 int든 모든 타입을 리턴할 수 있다.



<br>



이제 observable을 설명하겠다.

예를 들어 가로축이 시간인 다음 그림에서

세 번의 tap이 일어났다고 하자. 

첫 번째는 slider Value의 값을 변경하는 tap이고

두, 세 번째는 button을 클릭하는 tap이라 하자.





![스크린샷 2021-05-17 오후 8.21.55](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-17 오후 8.21.55.png)





<br>



이 경우 Observable은 sliderValue를 구독(subscribe)함으로써

첫 번째 탭에서 slider value의 값이 바뀌는 것을 감지해 낼 수 있다.

iOS 프로그래밍에서 이러한 값들을 가져오기 위해 얼마나 많은 작업을 해야 했는지 떠올려본다면 굉장한 기능이라는 것을 눈치챘을 것이다. 

어떤 셀을 클릭하거나, 내가 선언한 변수 값이 변경되거나 하는 일이 모든 viewController에서 일어난다. amazing한 기능이라는 감이 벌써부터 온다.

그러면 이것을 구체적으로 어떻게 쓰는지 한번 파악해보자.



<br>



## observable test

이번 파트에서는  observable의 .just, .of, .from 그리고 subscribe에 대해 살펴볼 것이다.



<br>



먼저 아까 생성한 playground에 다음을 적어주자.



```swift
import UIKit
import RxSwift

// Observable은 많은 메서드를 가짐.
// .just는 단일 변수를 생성.
let observable1 = Observable.just(1)

// Observable.of는
// 배열이나 서로 다른 자로형 set를 만들 수 있음.
// observable2는 다음과 같은 형태: let observable2: Observable<Observable<Int>.E>
let observable2 = Observable.of(1, 3, 7)
```



먼저 observable1에서  observable.just는 단일 변수를 생성한다.

그리고 observable2에서의 .of는 배열이나 서로 다른 자료형 set을 만들어낸다.





<br>



```swift
//  observable3, 4는 다음과 같은 형태: Observable<Observable<[Int]>.E>
let observable3 = Observable.of([1, 3, 7])

let observable4 = Observable.from([1, 2, 3, 4, 5])
```



observable3는 .of를 썼지만 배열을 담았고,

observable4는 .from을 썼는데, 이 from은 .of처럼 배열을 담을 수 있다.

둘의 차이는 from이 요소 하나하나를 리턴하는 반면 of는 배열 전체를 리턴한다는 데에 있다.

이 차이를 이제 subscribe와 함께 살펴보자.



<br>



### observable.subscribe

observable을 subscribe해보자.

`observable.subscribe { (event) in }` 이 기본형태이며,

해당 event를 출력하는 예시는 다음과 같다.



<br>



observable3을 이용했으며, 그냥 event를 출력했을 때에는

next이벤트와 completed 이벤트 모두 출력되고 있다.

```swift

observable3.subscribe { (event) in
    print(event)
}
/*
 next([1, 3, 7])
 completed
 */
```



<br>



그렇다면 요소만 출력하려면 어떻게 해야 할까?

정답은 event속 element를 추출하여 print하는 것이다.

다음과 같이 말이다.

```swift

observable3.subscribe { (event) in
    if let element = event.element {
        print(element)
    }
}
/*
 [1, 3, 7]
 */
```



<br>



이제 subscribe를 간단하게 쓰는법과 element만 추출하는 법을 배웠다.

그러면 `.of`와 `.from`의 차이를 보여주는 예제도 살펴보자.



<br>



`.of`를 쓴 observable3는 배열 전체를 출력했다.

그러나 `.from`을 쓴 observable4는 배열 요소 하나하나를 출력할 것이다.

observable3를 위에서 출력해본 것처럼 observable4를 한번 출력해보면 다음과 같이 나온다.

```swift
observable4.subscribe { (event) in
    print (event)
}
/*
 next(1)
 next(2)
 next(3)
 next(4)
 next(5)
 completed
 */

observable4.subscribe { (event) in
    if let element = event.element {
        print(element)
    }
}
/*
 1
 2
 3
 4
 5
 */
```



<br>



차이를 조금 알겠는가?

그렇다면 이번에는 event속에 있는 element를 매번 까서 그 안에 있는 값을 꺼내오지 말고,

해당 값을 바로 받아와보자.

`observable.subscribe(onNext: )` 메서드가 그것을 가능하게 해준다.

예시를 살펴보자.



<br>



```swift
observable4.subscribe(onNext: { (event) in
    print(event)
})
/*
 1
 2
 3
 4
 5
 */
```



<br>



다음 편에 계속...







<br>



# Udemy RxSwift -2-

## 구독 취소 disposing

우리가 무언가를 subscribe하기 시작하면 해당 subscribe는 value의 변동을 '항상' listening 상태로 둔다.

그 수가 많아지면 아무래도 메모리 측면에서 비효율을 야기할 것이다.

그러니 구독을 취소하는 방법도 배워보자.



<br>



### 기본형



예를 들어 다음과 같은 subscription1이 있다고 할 때, subscriber를 dispose하는 방법은 단순히 `.dispose()`를 원하는 시점에 호출하는 것 뿐이다.

```swift

// subscription1을 Subscriber라고 한다.

let subscription1 = observable4.subscribe(onNext: { (event) in
    print(event)
})

// dispose를 통해 memory leak을 방지.
subscription1.dispose()

```

이렇게 함으로써 개발자는 메모리 관리를 의도한 대로 할 수 있다.



<br>



### disposeBag



그런데 일일이 subscriber들을 dispose하는 것은 개발자 입장에서 충분히 까먹고 지나칠 수 있는 일이다.

이 때 우리는 disposeBag이라는 것을 사용할 수 있는데,

 disposeBag은 그것을 위해 subscriber들의 Observing을 "적절한 때에" dispose하는 데에 쓰인다.



<br>



사용형식은 다음과 같다.

disposeBag을 생성하고, subscriber가 `disposed(By: disposeBag)` 을 호출하면 된다.

```swift
// bag 생성
let disposeBag = DisposeBag()

// 이 disposeBag은 .disposed(by: ) 메소드와 함께 쓸 수 있다.
// 아래는 subscribe하는 것과 동시에 disposeBag에 해당 subscription의 dispose를 넣는 예제이다.
Observable.of("A", "B", "C")
    .subscribe {
        print($0)
    }.disposed(by: disposeBag)
```





<br>



예제를 하나만 더 살펴보자.

Observable을 생성함과 동시에 subscribe도 하고,

observable, subscribe이 생성되는 시점에 실행될 함수도 넣으면서

dispose까지 한번에 해보자.

아래는 그 예시이다.



<br>



```swift

Observable<String>.create { (observer) in
    observer.onNext("A")
    observer.onCompleted()
    observer.onNext("?")
    // create 메소드는 아래처럼 disposable을 리턴해줘야 한다.
    return Disposables.create()
}.subscribe(onNext: {print ($0)},
            onError: {print($0)},
            onCompleted: {print("OnCompleted")},
            onDisposed: {print("disposed")})
.disposed(by: disposeBag)

/*
completed
A
OnCompleted
disposed
 // ?는 출력되지 않았다. onCompleted 이후 코드는 실행되지 않는다.
*/


```



<br>



# Subject

RxSwift에서 배워야 할 개념 중 하나로 Subject라는 것도 있다.

중요하고 흥미로운 개념이니 잘 이해하고 넘어가자.



<br>



## 특징

Subject는 Obeserver와 똑같이 `observable`하다는 특징을 갖는다.

Subject는 Event를 받아서 Subscriber에게 그것을 전달하는 역할을 한다.



<br>



## PublishSubject

 PublishSubject는 subscribe할 수 있고, event를 전달해주는 대표적인 subject이다.



<br>



### 사용 형식

```swift
let subject = PublishSubject<String>()

subject.onNext("Issue #1") // 첫 번째 이슈가 발행됐다고 가정.
subject.subscribe { (event) in
    print(event)
}
// 이 시점엔 아무것도 출력되지 않음.
subject.onNext("Issue #2") // 두 번째 이슈가 발행됐다고 가정.
// next(Issue #2)가 출력됨.
subject.onNext("Issue #3")
// next(Issue #3) dispose()

subject.dispose()
subject.onCompleted()
//아무것도 출력되지 않음.

```



<br>



publishSubject는 가장 기본적인 형태의 subject이다. 

다른 목적에 맞게 subject는 몇 가지 유형이 더 있는데, 한번 살펴보자.



<br>



## BehaviorSubject

BehaviorSubject는 초기값을 지정할 수 있다.

예를 들어 아래처럼 "Issue #1" 같은 초기값을 지정할 수 있다는 소리다.

초기값은 subscribe시 읽을 수 있다. 



<br>



### 예제

```swift

// initialValue를 요구.
let behaviorSubject = BehaviorSubject(value: "Issue #1")
behaviorSubject.subscribe { event in
    print(event)
}
behaviorSubject.onNext("Issue #2")
// 1, 2가 모두 출력됨.
// next(Issue #1)
// next(Issue #2)
```



<br>



## RelaySubject

RelaySubject는 따로 버퍼 사이즈를 지정해줘야 한다.

이 버퍼사이즈는 `subscribe 하는 시점에` 사용되는데, 

해당 시점에 버퍼 사이즈 만큼 `최신에` 발행된 event를 가져온다.

stack과 같이 LIFO이다.



<br>



```swift
// 버퍼 사이즈를 지정해줘야 하는 subject.
// `subscribe 시점에` 버퍼 사이즈 만큼 최신에 발행된 onNext event를 가져옴.
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
replaySubject.onNext("Issue #1")
replaySubject.onNext("Issue #2")
replaySubject.onNext("Issue #3")

replaySubject.subscribe { event in
    print(event)
}
// 출력:
// next(Issue #2)
// next(Issue #3)

replaySubject.onNext("Issue #4")
replaySubject.onNext("Issue #5")
replaySubject.onNext("Issue #6")

print("[ReplaySubscription 2]")
replaySubject.subscribe { event in
    print(event)
}
// 출력:
// [ReplaySubscription 2]
// next(Issue #5)
// next(Issue #6)
```







<br>



## BehaviorRelay

BehaviorRelay는 어떤 변수를 생성하고, 그것을 Observable하게 만들 때 쓰인다.

원래는 Variable이라는 자료형을 제공했으나, Variable은 곧 deprecate될 예정이다.

초기값을 지정해야 하고, `RxCocoa`를 요구한다.

따라서 podfile에 `pod 'RxSwift', '~> 4.0'`을 적어주고 pod install로 설치한 후 import까지 해준다.



<br>



### 예제

BehaviorRelay는 만듦과 동시에 subscribe할 수 있으며, .accept로 값을 `대치`할 수 있다.

```swift
import RxSwift
import RxCocoa

// relay는 어떤 변수를 생성하고 그것을 Observable하게 만들 때 쓰인다.
// 초기값을 지정해주어야 한다.
// BehaviorRelay는 RxCocoa가 pod install 되어 있어야 한다.
let relay = BehaviorRelay(value: "This is Initial Value")

// 생성한 변수`.asObservable()` 을 이용해 observable로 만들 수 있다.
// 만듦과 동시에 .subscribe로 구독할 수 있다.
relay.asObservable()
    .subscribe {
        print ($0)
    }

// 변수의 값을 accept로 변경하는 법:
relay.accept("Hello World")

/* 여기까지 실행 시 출력문:
 next(This is Initial Value)
 next(Hello World)
 */

```



<br>



### 예제2 - value 추가하기.

.accept는 값을 `대치` 하지만 값의 `추가`가 필요할 때도 있을 것이다.

그것은 value를 받아오고 value에 값을 추가한 뒤 .accept(value) 함으로써 가능하다.

코드로 살펴보자.



<br>



```swift
// array자료형을 추가할 수도 있다.
// 아래는 emptyArray를 추가하는 예제.
//let relayArray = BehaviorRelay(value: [String]())

// 초기화하면서 변수를 생성.
let relayArray = BehaviorRelay(value: ["Item 0"])


relayArray.asObservable()
    .subscribe {
        print ($0)
    }


/*출력
 next(["Item0"])
 */


// Array의 값을 '대치'하는 것은 다음과 같이 가능하다.
relayArray.accept(["Item 1"])

/*출력
 next(["Item1"])
 */

// 값을 이어 붙이고 싶을 때:

var value = relayArray.value
value.append("item 2")
value.append("item 3")

relayArray.accept(value)


/*출력
 next(["Item1", "item2", "item3"])
 */
```

