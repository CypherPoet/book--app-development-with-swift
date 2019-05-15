//: [Previous](@previous)

import UIKit
import PlaygroundSupport

let liveViewFrame = CGRect(x: 0, y: 0, width: 500, height: 500)
let liveView = UIView(frame: liveViewFrame)

liveView.backgroundColor = .white
PlaygroundPage.current.liveView = liveView

let square = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
square.backgroundColor = #colorLiteral(red: 0.4665188789, green: 0.4245759249, blue: 0.8790055513, alpha: 1)

liveView.addSubview(square)


func makeTransformToCenter() -> CGAffineTransform {
    let scale = CGAffineTransform(scaleX: 2.0, y: 2.0)
    let rotation = CGAffineTransform(rotationAngle: .pi)
    let translation = CGAffineTransform(translationX: 200, y: 200)
    
    // 🔑 TRaSh in reverse
    let combo = scale.concatenating(rotation.concatenating(translation))
    
    return combo
}



UIView.animate(
    withDuration: 1.3,
    animations: {
        square.backgroundColor = .orange
        square.transform = makeTransformToCenter()
    },
    completion: { _ in
        UIView.animate(
            withDuration: 1.3,
            animations: {
                square.transform = .identity
            }
        )
    }
)


/**
 📝 Using the `CGAffineTransform.identity` transform above, our square will
 still be orange, since .identify only operate on translation, rotation, and scale properties.
 
 For a full reversal, we can also use the `.autoreverse` option. (Comment out the above
 animation and uncomment the animation below)
 */


//UIView.animate(
//    withDuration: 1.3,
//    delay: 0,
//    options: [.autoreverse],
//    animations: {
//        square.backgroundColor = .orange
//        square.transform = makeTransformToCenter()
//    }
//)




//: [Next](@next)
