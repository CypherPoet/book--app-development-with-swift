import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let sample = "sample"
        
        if true {
            print("Will this line of code ever be reached?")
            someMethod(sample: sample)
        }
    }
    
    func someMethod(sample: String) {
        print("We have reached the method with \(sample)")
    }
}

