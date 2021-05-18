import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

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

// 변수의 값은 accept로 변경한다.
relay.accept("Hello World")

/* 출력
 next(This is Initial Value)
 next(Hello World)

 */


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
