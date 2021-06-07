import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport

//operator transforming - flatMapLatest
let disposeBag = DisposeBag()

struct Student {
    var score: BehaviorRelay<Int>
}

let son = Student(score: BehaviorRelay(value: 75))
let park = Student(score: BehaviorRelay(value: 90))

let student = PublishSubject<Student>()

student.asObservable()
    .flatMapLatest { $0.score.asObservable() }
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


////operator transforming - flatMap
//let disposeBag = DisposeBag()
//
//struct Student {
//    var score: BehaviorRelay<Int>
//}
//
//let son = Student(score: BehaviorRelay(value: 75))
//let park = Student(score: BehaviorRelay(value: 90))
//
//let student = PublishSubject<Student>()
//
//student.asObservable()
//    .flatMap { $0.score.asObservable() }
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//

//print("----son----")
//student.onNext(son)
//son.score.accept(100)
//
//
//print("----park----")
//student.onNext(park)
//park.score.accept(70)
//
//
//print("----son again----")
//son.score.accept(42)
//// operator transforming - map
//let disposeBag = DisposeBag()
//
//Observable.of(1,2,3,4,5)
//    .map {
//        return $0 * 2
//    }.subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)

//// operator Transforming - toArray
//let disposeBag = DisposeBag()
//
//Observable.of(1,2,3,4,5)
//    .toArray()
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//

//// filtering operators - takeWhile
//
//let disposeBag = DisposeBag()
//
//let subject = PublishSubject<String>()
//let trigger = PublishSubject<String>()
//
//subject.takeUntil(trigger)
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//
//subject.onNext("A")
//subject.onNext("B")
//subject.onNext("C")
//
//trigger.onNext("X")
//
//subject.onNext("D")
//subject.onNext("E")
//subject.onNext("F")

//// filtering operators - takeWhile
//let disposeBag = DisposeBag()
//
//Observable.of(2,4,6, 7, 8,10)
//    .takeWhile {
//        return $0 % 2 == 0
//    }.subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)

//
//// filtering operators - take
//let disposeBag = DisposeBag()
//
//Observable.of(1,2,3,4,5,6)
//    .take(3)
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)


//// filtering operators - skipWhile

//let disposeBag = DisposeBag()
//
//let subject = PublishSubject<String>()
//let trigger = PublishSubject<String>()
//
//subject.skipUntil(trigger)
//    .subscribe(onNext: {
//        print ($0)
//    }).disposed(by: disposeBag)
//
//subject.onNext("A")
//subject.onNext("B")
//subject.onNext("C")
//
//trigger.onNext("Something")
//
//subject.onNext("D")
//subject.onNext("E")
//subject.onNext("F")

//// filtering operators - skipWhile
//
//let disposeBag = DisposeBag()
//
//Observable.of(1, 1, 2, 2, 3, 3, 4, 4, 5, 5)
//    .skipWhile { $0 % 2 == 1 }
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)

//// filtering operators - skip
//
//let disposeBag = DisposeBag()
//
//Observable.of("A", "B", "C", "D", "E", "F")
//    .skip(3)
//    .subscribe(onNext: {
//      print($0)
//    }).disposed(by: disposeBag)
//

//
//// filtering operators - elementAt
//let disposeBag = DisposeBag()
//
//Observable.of(1, 2, 3, 4, 5, 6, 7)
//    .filter { $0 % 2 == 0 }
//    .subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//
//
//
////// filtering operators - elementAt
//let strikes = PublishSubject<String>()
//
//let disposeBag = DisposeBag()
//
//
//strikes.elementAt(2)
//    .subscribe(onNext: { _ in
//        print("Index Reached")
//    }).disposed(by: disposeBag)
//
//strikes.onNext("X")
//strikes.onNext("Y")
////여기서 실행했을 때에는 아무것도 안 뜸.
//
//strikes.onNext("Z")
//
//









//
//
//
//// filtering operators - ignore
//let strikes = PublishSubject<String>()
//
//let disposeBag = DisposeBag()
//
//
//
//strikes
//    .ignoreElements()
//    .subscribe { _ in
//        print("[Subscription is called]")
//    }.disposed(by: disposeBag)
//
//strikes.onNext("A")
//strikes.onNext("B")
//strikes.onNext("C")
//
//


//
//// subjects
//
///*
// PublishSubject는 subscribe할 수 있고,
// event를 전달해주는 대표적인 subject이다.
//
// */
//let subject = PublishSubject<String>()
//
//subject.onNext("Issue #1") // 첫 번째 이슈가 발행됐다고 가정.
//subject.subscribe { (event) in
//    print(event)
//}
//// 아무것도 출력되지 않음.
//subject.onNext("Issue #2") // 두 번째 이슈가 발행됐다고 가정.
//// next(Issue #2)가 출력됨.
//subject.onNext("Issue #3")
//// next(Issue #3) dispose()
//
//subject.dispose()
//subject.onCompleted()
////아무것도 출력되지 않음.
//
//// initialValue를 요구.
//let behaviorSubject = BehaviorSubject(value: "Issue #1")
//behaviorSubject.subscribe { event in
//    print(event)
//}
//behaviorSubject.onNext("Issue #2")
//// 1, 2가 모두 출력됨.
//// next(Issue #1)
//// next(Issue #2)
//
//// 버퍼 사이즈를 지정해줘야 하는 subject.
//// `subscribe 시점에` 버퍼 사이즈 만큼 최신에 발행된 onNext event를 가져옴.
//let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
//replaySubject.onNext("Issue #1")
//replaySubject.onNext("Issue #2")
//replaySubject.onNext("Issue #3")
//
//replaySubject.subscribe { event in
//    print(event)
//}
//// 출력:
//// next(Issue #2)
//// next(Issue #3)
//
//replaySubject.onNext("Issue #4")
//replaySubject.onNext("Issue #5")
//replaySubject.onNext("Issue #6")
//
//print("[ReplaySubscription 2]")
//replaySubject.subscribe { event in
//    print(event)
//}
//// 출력:
//// next(Issue #5)
//// next(Issue #6)
//
//
//
//// relay는 어떤 변수를 생성하고 그것을 Observable하게 만들 때 쓰인다.
//// 초기값을 지정해주어야 한다.
//// BehaviorRelay는 RxCocoa가 pod install 되어 있어야 한다.
//let relay = BehaviorRelay(value: "This is Initial Value")
//
//// 생성한 변수`.asObservable()` 을 이용해 observable로 만들 수 있다.
//// 만듦과 동시에 .subscribe로 구독할 수 있다.
//relay.asObservable()
//    .subscribe {
//        print ($0)
//    }
//
//// 변수의 값은 accept로 변경한다.
//relay.accept("Hello World")
//
///* 출력
// next(This is Initial Value)
// next(Hello World)
//
// */
//
//
//// array자료형을 추가할 수도 있다.
//// 아래는 emptyArray를 추가하는 예제.
////let relayArray = BehaviorRelay(value: [String]())
//
//// 초기화하면서 변수를 생성.
//let relayArray = BehaviorRelay(value: ["Item 0"])
//
//
//relayArray.asObservable()
//    .subscribe {
//        print ($0)
//    }
//
//
///*출력
// next(["Item0"])
// */
//
//
//// Array의 값을 '대치'하는 것은 다음과 같이 가능하다.
//relayArray.accept(["Item 1"])
//
///*출력
// next(["Item1"])
// */
//
//// 값을 이어 붙이고 싶을 때:
//
//var value = relayArray.value
//value.append("item 2")
//value.append("item 3")
//
//relayArray.accept(value)
//
//
///*출력
// next(["Item1", "item2", "item3"])
// */
