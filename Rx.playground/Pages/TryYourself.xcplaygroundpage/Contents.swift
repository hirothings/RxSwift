/*:
 > # IMPORTANT: To use **Rx.playground**:
 1. Open **Rx.xcworkspace**.
 1. Build the **RxExample-macOS** scheme (**Product** → **Build**).
 1. Open **Rx** playground in the **Project navigator** (under RxExample project).
 1. Show the Debug Area (**View** → **Debug Area** → **Show Debug Area**).
 */
import RxSwift
/*:
 # Try Yourself
 
 It's time to play with Rx 🎉
 */
playgroundShouldContinueIndefinitely()

let observable1 = Observable.of("🐶", "🐱", "🐭", "🐹")
let observable2 = Observable.of(1, 2, 3, 4, 5)

example("zipとcombineLatestの違い") {
    Observable.zip(
        observable1,
        observable2
    )
    .debug("zip")
    .subscribe()

    Observable.combineLatest(
        observable1,
        observable2
    )
    .debug("combineLatest")
    .subscribe()
}

example("任意のdispose") {
    let subject = PublishSubject<String>()
    let subscription = subject
        .subscribe(onNext: {
            print("onNext: ", $0)
        }, onCompleted: {
            print("􏲄􏲅")
        }, onDisposed: {
            print("􏷑􏷒破棄")
        })
    
    subject.onNext("1")
    subject.onNext("2")
    subscription.dispose()
    subject.onNext("3")
    subject.onNext("4")
    subject.onCompleted()
}

example("[Observable`<Void>`]をObservable<[Void]>に変換する") {
    let arr: [Observable<Int>] = [
        Observable.just(1),
        Observable.just(2),
        Observable.just(3)
    ]
    let observables: Observable<[Int]> = Observable.zip(arr)
    observables
        .debug("observables")
        .subscribe()
}
