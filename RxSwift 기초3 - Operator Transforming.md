

# Operator Transforming



## ToArray

2, 4, 3 이라는 엘리먼트를 가진 녀석들이 다음과 같은 시퀀스를 가진다고 할 때,

![스크린샷 2021-06-07 오전 10.47.05](/Users/choeganghun/Desktop/스크린샷 2021-06-07 오전 10.47.05.png)



<br>



toArray를 사용하면 다음 그림과 같이 세 가지 엘리먼트를 하나의 배열로 묶어버린다.

그리고 이 배열은 swift의 일반적인 배열처럼 사용할 수 있다.



<br>



![스크린샷 2021-06-07 오전 10.48.39](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-06-07 오전 10.48.39.png)



<br>



### 예제

예제를 통해 살펴보자.

```swift
let disposeBag = DisposeBag()

Observable.of(1,2,3,4,5)
    .toArray()
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
```



<br>



예를 들어 위와 같은 코드가 있다고 할 때, `1,2,3,4,5` 라는 요소를 가진 것을 Array로 바꾸고, 해당 작업이 완료되면

print하는 것이다.

결과는 예상하겠지만 다음과 같다:



<br>



```swift
[1, 2, 3, 4, 5]
```



<br>



## map

map은 어떤 시퀀스가 있다고 할 때 각각의 요소에 어떤 연산을 하고, 해당 연산의 결과를 리턴해주는 메서드이다.

예를 들어 다음과 같은 시퀀스에 대해, `map {$0 * 2}` 를 넣으면



<br>



![스크린샷 2021-06-07 오전 11.11.42](/Users/choeganghun/Library/Application Support/typora-user-images/스크린샷 2021-06-07 오전 11.11.42.png)



<br>



그 결과는 `4, 8, 6`이 나오게 된다.



<br>



### 예제

구체적으로 예를 들어 설명하면 다음과 같다.

아래와 같은 코드가 있다고 할 때, `map` 은 각 요소를 *2 한 상태로 리턴하도록 하고 있다.

그 결과는 어떻게 될까?



<br>



```swift
let disposeBag = DisposeBag()

Observable.of(1,2,3,4,5)
    .map {
        return $0 * 2
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

```



<br>



위 코드를 돌려본 결과 아래와 같은 결과가 나왔다:



```swift
2
4
6
8
10
```



<br>





# flatMap

flatMap은 어떤 struct 처럼 멤버를 갖는 자료형에 대해 해당 자료형 자체를 subscribe하고 싶은 게 아니라 해당 자료형의 특정 멤버를 subscribe하고 싶을 때 사용한다. 작동 자체는 map과 비슷하게 한다.

무슨 말인지 아직 감이 안 올테니 예제를 통해 살펴보자.



<br>



### 예제

예를 들어 다음과 같은 코드가 있다고 하자.

Student라는 구조체가 있고, 해당 구조체는 score라는 멤버를 갖는다.

해당 멤버는 BehaviorRelay로서 subscribe할 수 있는 자료형이다.



<br>



```swift
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

struct Student {
    var score: BehaviorRelay<Int>
}

let son = Student(score: BehaviorRelay(value: 75))
let park = Student(score: BehaviorRelay(value: 90))

let student = PublishSubject<Student>()

```



<br>



이제 위와 같은 예제로부터 son과 park이라는 `Student` 형 구조체를 subscribe해보자.

이 때, 우리는 `flatMap`을 이용해 Student 자체가 아닌 Student.score 를 subscribe할 것이다.

코드를 통해 살펴보자.



<br>



```swift
student.asObservable()
    .flatMap { $0.score.asObservable() }
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


print("----son----")
student.onNext(son)
son.score.accept(100)


print("----park----")
student.onNext(park)
park.score.accept(70)


print("----son again----")
son.score.accept(42)
```



<br>



여기까지 하면 출력은 어떻게 될까?

한번 상상해보고 아래 출력문으로 답을 확인해보자.



<br>



```swift
----son----
75
100
----park----
90
70
----son again----
42
```



<br>



여기서 주목할 점은 `student.onNext(park)` 을 호출한 이후에도 여전히 son의 값이 바뀌면 출력이 진행된다는 것이다.



<br>



## flatMapLatest

위 예제에서는 student.onNext(park) 을 호출한 이후에도 son의 값이 바뀌면 onNext가 호출되었다. 

이것을 방지하기 위해서 쓸 수 있는 것이 바로 `flatMapLatest` 이다. 

단순히 위 코드에서 `flatMap`을 `flatMapLatest` 로만 바꾸면 끝.

```swift
let disposeBag = DisposeBag()

struct Student {
    var score: BehaviorRelay<Int>
}

let son = Student(score: BehaviorRelay(value: 75))
let park = Student(score: BehaviorRelay(value: 90))

let student = PublishSubject<Student>()

student.asObservable()
    .flatMapLatest { 
      $0.score.asObservable() } // 바뀐건 여기 하나.
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
 
print("----son----")
student.onNext(son)
son.score.accept(100)


print("----park----")
student.onNext(park)
park.score.accept(70)


print("----son again----")
son.score.accept(42)
```



<br>



flatMapLatest를 이용한 결과 flatMap 예제와는 달리 son again 이하가 출력되지 않고 있다 :

```swift
----son----
75
100
----park----
90
70
----son again----
```



<br>

