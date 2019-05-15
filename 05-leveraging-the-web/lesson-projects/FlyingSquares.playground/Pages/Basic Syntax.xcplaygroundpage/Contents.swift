import UIKit
import PlaygroundSupport

let liveViewFrame = CGRect(x: 0, y: 0, width: 300, height: 300)
let liveView = UIView(frame: liveViewFrame)

liveView.backgroundColor = .white

PlaygroundPage.current.liveView = liveView


let smallFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
let square = UIView(frame: smallFrame)
square.backgroundColor = #colorLiteral(red: 0.4665188789, green: 0.4245759249, blue: 0.8790055513, alpha: 1)


liveView.addSubview(square)


UIView.animate(
    withDuration: 2.0,
    delay: 0,
    options: [.repeat],
    animations: {
        square.backgroundColor = .orange
        square.frame = CGRect(x: liveView.center.x, y: liveView.center.y, width: 20, height: 20)
    },
    completion: { (_) in
        UIView.animate(
            withDuration: 2.0,
            animations: {
                square.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            }
        )
    }
)


