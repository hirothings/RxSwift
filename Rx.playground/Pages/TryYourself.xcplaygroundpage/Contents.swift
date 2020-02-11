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
