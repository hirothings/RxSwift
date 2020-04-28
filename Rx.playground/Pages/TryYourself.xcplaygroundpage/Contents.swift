import Foundation
import RxSwift
/*:
 # Try Yourself
 
 It's time to play with Rx 🎉
 */
playgroundShouldContinueIndefinitely()

let disposeBag = DisposeBag()

example("zipとcombineLatestの違い") {
    let observable1 = Observable.of("🐶", "🐱", "🐭", "🐹")
    let observable2 = Observable.of(1, 2, 3, 4, 5)

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

example("Observable.empty()の挙動") {
    let empty = Observable<String>
        .empty()
        .debug("Observable.empty()の挙動")

    empty
        .ifEmpty(default: "Hiroshi天才")
        .subscribe(onNext: {
            print("onNext: ", $0)
        }, onCompleted: {
            print("onCompleted􏲄􏲅")
        }, onDisposed: {
            print("􏷑􏷒破棄")
        })
        .disposed(by: disposeBag)
}

example("Array + Observable.empty()の挙動") {
    let array: Array<String> = []
    let observableFromEmptyArray = Observable.zip(array.map { Observable.just($0) })

    observableFromEmptyArray
        .ifEmpty(default: ["Hiroshi最高"])
        .subscribe(onNext: {
            print("onNext: ", $0)
        }, onCompleted: {
            print("onCompleted􏲄􏲅")
        }, onDisposed: {
            print("􏷑􏷒破棄")
        })
        .disposed(by: disposeBag)
}

example("Completableの挙動1") {
    func cacheLocally() -> Completable {
        return Completable.create { completable in
           // Store some data locally

           completable(.completed)
           return Disposables.create {}
        }
    }

    cacheLocally()
        .subscribe { completable in
            switch completable {
                case .completed:
                    print("Completed with no error")
                case .error(let error):
                    print("Completed with an error: \(error.localizedDescription)")
            }
        }
        .disposed(by: disposeBag)
}

example("Completableの挙動2") {
    let task1 = Completable.create { subscribe -> Disposable in
        subscribe(.completed)
        return Disposables.create()
    }

    let task2 = Single<Int>.create { subscribe -> Disposable in
        subscribe(.success(1))
        return Disposables.create()
    }

    Observable.zip(task1.asObservable(), task2.asObservable())
        .subscribe(onNext: { _ in
            print("☀️ ここで何かしたい") // <- task1が.completedしか発火しないため、この処理は呼ばれない
        })
        .disposed(by: disposeBag)
}

let intervalObservable = Observable<Int>.create { observer in
    observer.onNext(1)
    observer.onNext(2)
    observer.onNext(3)

    sleep(2)

    observer.onNext(4)
    observer.onNext(5)
    observer.onNext(6)

    sleep(2)

    observer.onCompleted()
    return Disposables.create()
}

example("debounceとthrottle: debounce") {
    // 参考: https://qiita.com/dekatotoro/items/be22a241335382ecc16e

    let now = Date()
    print(now)

    let scheduler = MainScheduler.instance

    _ = intervalObservable
        .debounce(.seconds(1), scheduler: scheduler) // 6
        .subscribe(onNext: {
            print(now.distance(to: Date()))
            print("debounce: \($0)")
        })
}

example("debounceとthrottle: throttle true") {
    // 参考: https://qiita.com/dekatotoro/items/be22a241335382ecc16e

    let now = Date()
    print(now)

    let scheduler = MainScheduler.instance

    _ = intervalObservable
        .throttle(.seconds(1), latest: true, scheduler: scheduler) // 1, 4, 6
        .subscribe(onNext: {
            print(now.distance(to: Date()))
            print("throttle true: \($0)")
        })
}

example("debounceとthrottle: throttle false") {
    // 参考: https://qiita.com/dekatotoro/items/be22a241335382ecc16e

    let now = Date()
    print(now)

    let scheduler = MainScheduler.instance

    _ = intervalObservable
        .throttle(.seconds(1), latest: false, scheduler: scheduler) // 1, 4
        .subscribe(onNext: {
            print(now.distance(to: Date()))
            print("throttle false: \($0)")
        })
}
