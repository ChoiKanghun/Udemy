>  # Filtering Operators



# 1.Ignore

![스크린샷 2021-05-21 오후 7.38.16](/Users/choeganghun/Desktop/스크린샷 2021-05-21 오후 7.38.16.png)

위와 같은 시퀀스가 하나 있다고 하자. 해당 시퀀스가 세 가지 값을 가지고 있다고 할 때, `ignoreElements()`를 호출하면 



<br>



아래와 같은 사진처럼 모든 element가 무시된다. 그러고 나서는 onCompleted() 메서드가 호출된다.

#### ![image-20210521193944487](/Users/choeganghun/Library/Application Support/typora-user-images/image-20210521193944487.png)





<br>



여기까지만 봐서는 무슨 말인지 이해가 잘 가지 않을 것이다. 예제를 통해 한번 살펴보자.



<br>



## 예제

예를 들어 다음과 같은 코드가 있다고 할 때, strikes는 subscribe하기 이전에 ignoreElements() 를 호출했기 때문에 strikes가 아무리 onNext()를 호출해도 클로저 내부의 함수가 실행되지 않는다.

```swift
// filtering operators
let strikes = PublishSubject<String>()

let disposeBag = DisposeBag()

strikes
    .ignoreElements()
    .subscribe { _ in
        print("[Subscription is called]")
    }.disposed(by: disposeBag)

strikes.onNext("A")
strikes.onNext("B")
strikes.onNext("C")

// 아무것도 출력되지 않음.

```



<br>



다만 onCompleted() 까지 Ignore하는 것은 아니라서,

onCompleted 시점에서는 함수가 호출된다.

그래서 위 예시 코드에서 `strikes.onCompleted()` 한 줄만 추가하면 `[Subscription is called]` 이 출력된다.

```swift
// filtering operators
let strikes = PublishSubject<String>()

let disposeBag = DisposeBag()

strikes
    .ignoreElements()
    .subscribe { _ in
        print("[Subscription is called]")
    }.disposed(by: disposeBag)

strikes.onNext("A")
strikes.onNext("B")
strikes.onNext("C")

// 다음의 한 줄을 추가.
strikes.onCompleted()
// [Subscription is called] 출력.
```



<br>



# elementAt

![스크린샷 2021-05-21 오후 7.38.16](/Users/choeganghun/Desktop/스크린샷 2021-05-21 오후 7.38.16.png)



만약 위와 같은 시퀀스가 있고,

여기서 elementAt(1)을 호출한다면,





<br>



이것은 다음과 같이 [1] 번째 인덱스에 있는 '2'를 반환한다.  (인덱스는 0부터 시작.)

![스크린샷 2021-05-25 오후 2.35.38](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 2.35.38.png)



<br>



코드로 설명하자면

예를 들어 다음과 같은 코드가 있다고 하자.

```swift
// filtering operators - elementAt
let strikes = PublishSubject<String>()

let disposeBag = DisposeBag()


strikes.elementAt(2)
    .subscribe(onNext: { _ in
        print("Index Reached")
    }).disposed(by: disposeBag)

```

여기서 우리는 subscribe를 했으므로, onNext시에 우리가 의도한 `index reached`라는 문구가 떠야 한다.





<br>



그러나 위의 예제에 아래 코드를 추가해보면, elementAt의 인자로 들어온 2, 그러니까 세 번째 인자가 들어오기 전까지는 아무것도 출력되지 않는 것을 알 수 있다.

```swift
strikes.onNext("X")
strikes.onNext("Y")
//여기서 실행했을 때에는 아무것도 안 뜸.

strikes.onNext("Z")
// print됨: Index Reached
```





<br>



# Filter

![스크린샷 2021-05-25 오후 2.47.31](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 2.47.31.png)

`Filter`는 예를 들어 위와 같은 시퀀스가 있고, `$0 < 3` 이라는 filter 옵션을 주면 특정 개수만큼(위에서는 2개) 시퀀스를 필터링하여 전달해주는 역할을 한다. 구체적으로 무슨 말인지 아래에서 더 살펴보자.



<br>



Observable.of(1, 2, 3, 4, 5, 6, 7) 을 subscribe하면 1부터 7까지 onNext 이벤트가 발생하게 된다.

그러면 여기에 `{ $0 % 2 == 0 }` 이라는 옵션을 주고 subscribe를 한다면 어떤 일이 발생할까?

코드로 살펴보자.



<br>



```swift
// filtering operators - elementAt
let disposeBag = DisposeBag()

Observable.of(1, 2, 3, 4, 5, 6, 7)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
```



예를 들어 위와 같은 코드가 있다고 할 때, 1부터 7까지의 요소를 담은 Observable을 `$0 % 2 == 0`으로 필터링하고,

onNext를 subscribe한 결과는 무엇일까?

답은 다음과 같다. 쉽게 예상할 수 있었을 것이다.



<br>



```
2
4
6
```



<br>



# Skip



![스크린샷 2021-05-25 오후 3.05.03](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 3.05.03.png)



위와 같이 세 개의 시퀀스가 있다고 할 때, 앞의 두 개 시퀀스를 뛰어넘고 싶다고 하면 `skip(2)`를 호출하면 된다.

그렇게 하면 3이라는 시퀀스만 가져올 수 있다. 



<br>



코드로 살펴보자.

```swift
let disposeBag = DisposeBag()

Observable.of("A", "B", "C", "D", "E", "F")
    .skip(3)
    .subscribe(onNext: {
      print($0)
    }).disposed(by: disposeBag)
```



위와 같이 A~F 의 요소를 갖는 Observable을 subscribe하는데, `skip(3)` 이라는 옵션을 붙여줬다.

결과가 어떨 것 같은가?

결과는 A, B, C를 제외하고 네 번째 요소인 D부터 차례로 onNext event를 호출한다.

출력값은 다음과 같다.



<br>



```swift
D
E
F
```



<br>



# skipWhile

![스크린샷 2021-05-25 오후 3.10.37](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 3.10.37.png)

이번에도 위와 같은 세 개의 시퀀스가 있다고 해보자.

만약 해당 시퀀스에서 `skipWhile { $0 % 2 == 1 }`, 그러니까 `홀수를 스킵한다` 정도로 해석할 수 있는 조건을 준다면,

다음과 같이 2, 3을 반환한다.

![스크린샷 2021-05-25 오후 3.12.06](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 3.12.06.png)



<br>



이러한 결과가 나오는 것은 skipWhile이 이름 그대로 `조건을 만족하는 동안 skip` 하기 때문이다.



<br>



이해를 돕기 위해 코드로 살펴보자.



```swift
let disposeBag = DisposeBag()

Observable.of(1, 1, 2, 2, 3, 3, 4, 4, 5, 5)
    .skipWhile { $0 % 2 == 1 }
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

```



<br>



예를 들어 위와 같은 경우  어디까지 스킵할 것 같은가?

1, 3, 5가 필터링 될까? 아니면 제일 앞의 두 개의 요소 1, 1만 필터링될까?

정답은 다음 코드를 확인하시길..



<br>



```swift
2
2
3
3
4
4
5
5
```



<br>



# skipUntil

skipUntil에 대해 알아보자.

skipUntil이란, 어떤 특정 trigger를 세워놓고 해당 trigger에서 이벤트가 일어나기 전까지 모두 skip해버리는 것을 의미한다.

아래 사진을 한번 보자.



<br>



![스크린샷 2021-05-25 오후 3.20.54](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 3.20.54.png)



![스크린샷 2021-05-25 오후 3.27.05](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 3.27.05.png)



<br>



위 사진에서 1과 2 사이에 trigger가 당겨졌다면, 1은 스킵되고 2와 3이라는 시퀀스만 실행된다.

무슨 말을 하고 싶은 건지 감을 잡았겠지만 정확히 어떤 상황인지 이해가 가지 않을 것이다. 

코드로도 한번 살펴보자.





<br>



```swift
let disposeBag = DisposeBag()

let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject.skipUntil(trigger)
    .subscribe(onNext: {
        print ($0)
    }).disposed(by: disposeBag)

subject.onNext("A")
subject.onNext("B")
subject.onNext("C")
```



<br>



예를 들어 위와 같이 `trigger` 에서는 이벤트가 일어나지 않고 subject에서만 이벤트가 일어나는 상황에서,

subject에 `skipUntil(trigger)`라는 조건을 주게 된다면 위 상황에서는 아무것도 출력되지 않는다.

왜냐하면 우리가 준 조건은 trigger에 이벤트가 일어나기 전까지는 모두 skip하라는 조건이기 때문이다.



<br>



그래서 위 코드를 아래와 같이 바꿔보면 무언가 출력이 될 것이다.

무엇이 출력될지 예상하면서 코드를 읽어보자.

```swift
let disposeBag = DisposeBag()

let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject.skipUntil(trigger)
    .subscribe(onNext: {
        print ($0)
    }).disposed(by: disposeBag)

subject.onNext("A")
subject.onNext("B")
subject.onNext("C")

trigger.onNext("Something")

subject.onNext("D")
subject.onNext("E")
subject.onNext("F")

```



<br>



결과는 다음과 같이 출력됐다:

```swift
D
E
F
```



<br>



# take



![스크린샷 2021-05-25 오후 3.52.03](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 3.52.03.png)

위와 같은 시퀀스에 대해 take(2)를 호출하면, (첫) 두 개의 시퀀스를 가져오겠다는 것을 의미한다.

즉, (1, 2) 를 가져오겠다는 것인데, 이에 대해 코드로 살펴보자.



<br>



```swift
let disposeBag = DisposeBag()

Observable.of(1,2,3,4,5,6)
    .take(3)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
```



<br>



위와 같은 경우 1~6까지의 번호(시퀀스)에 대해 `take(3)`를 호출하고 있다.

이에 대한 결과는 다들 예상하겠지만 다음과 같다.

```
1
2
3

```



<br>



# takeWhile

![스크린샷 2021-05-25 오후 4.08.54](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-05-25 오후 4.08.54.png)



예를 들어 위와 같은 시퀀스가 있다고 할 때, 

`takeWhile{ $0 % 2 == 0 }` 이라는 조건은 시퀀스가 짝수인 동안만 동작한다.

위의 사진에서는 2와 4라는 시퀀스만 전달된다는 의미이다.



<br>



이것 또한 코드로 한번 살펴보자. 

```swift
let disposeBag = DisposeBag()

Observable.of(2,4,6, 7, 8,10)
    .takeWhile {
        return $0 % 2 == 0
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
```



<br>



위 예제코드의 결과는 2, 4, 6으로, 7을 만나기 전까지만 출력된다.

그 이유는 조건이 짝수인 동안만 이벤트를 받는 것이기 때문이다.

(참고로 코드에 쓰인 return문은 쓰나 안 쓰나 결과는 같다.)



<br>



# takeUntil

`takeUntil`은 skipUntil과 마찬가지로 어떤 trigger를 요구한다.

예를 들어 아래 이미지에서 2와 3 사이에 어떤 trigger가 당겨졌다면,

1과 2만 전달되는 것이 takeUntil이다.

![스크린샷 2021-05-25 오후 4.14.34](/Users/choeganghun/Desktop/스크린샷 2021-05-25 오후 4.14.34.png)





<br>



코드로 설명하자면 아래 예시에서 trigger되는 부분을 잘 살펴보자.

```swift

let disposeBag = DisposeBag()

let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject.takeUntil(trigger)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

subject.onNext("A")
subject.onNext("B")
subject.onNext("C")

trigger.onNext("X")

subject.onNext("D")
subject.onNext("E")
subject.onNext("F")

```

위와 같이 trigger "X"를 호출하는 시점이 **ABC "X" DEF**인 경우 출력은 당연히 X 이전의 요소들, 즉

```swift
A

B

C
```

가 된다. 



<br>