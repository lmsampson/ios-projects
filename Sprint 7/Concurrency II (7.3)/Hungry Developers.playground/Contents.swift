//: Playground - noun: a place where people can play

import Foundation

class Spoon {
    
    init(index: Int) {
        self.index = index
    }
    
    func pickUp() {
        lock.lock()
    }
    
    func putDown() {
        lock.unlock()
    }
    
    private let lock = NSLock()
    let index: Int
}

class Developer {
    
    init(leftSpoon: Spoon, rightSpoon: Spoon, developer: String) {
        self.leftSpoon = leftSpoon
        self.rightSpoon = rightSpoon
        self.developer = developer
    }
    
    func think() {
        print("\(developer) is thinking.")
        
        if leftSpoon.index < rightSpoon.index {
            
            print("\(developer) is trying to pick up left spoon.")
            leftSpoon.pickUp()
            print("\(developer) picked up left spoon.")

            print("\(developer) is trying to pick up right spoon.")
            rightSpoon.pickUp()
            print("\(developer) picked up right spoon.")
        } else {
            
            print("\(developer) is trying to pick up right spoon.")
            rightSpoon.pickUp()
            print("\(developer) picked up right spoon.")

            print("\(developer) is trying to pick up left spoon.")
            leftSpoon.pickUp()
            print("\(developer) picked up left spoon.")
        }
        
//        let spoons = [(leftSpoon, "left"), (rightSpoon, "right")].sorted(by: { $0.0.index < $1.0.index })
//        spoons.forEach { $0.0.pickUp(); print("\(developer) picked up \($0.1) spoon.") }
    }
    
    func eat() {
        print("\(developer) is eating.")
        usleep(arc4random_uniform(10) * 10000)
        
        print("\(developer) is trying to put down left spoon.")
        leftSpoon.putDown()
        print("\(developer) put down left spoon.")
        
        print("\(developer) is trying to put down right spoon.")
        rightSpoon.putDown()
        print("\(developer) put down right spoon.")
    }
    
    func run() {
        while true {
            think()
            eat()
        }
    }
    
    var leftSpoon: Spoon
    var rightSpoon: Spoon
    let developer: String
}

// MARK: - Testing

var spoon1 = Spoon(index: 1)
var spoon2 = Spoon(index: 2)
var spoon3 = Spoon(index: 3)
var spoon4 = Spoon(index: 4)
var spoon5 = Spoon(index: 5)

var developer1 = Developer(leftSpoon: spoon1, rightSpoon: spoon2, developer: "Grant")
var developer2 = Developer(leftSpoon: spoon2, rightSpoon: spoon3, developer: "Lisa")
var developer3 = Developer(leftSpoon: spoon3, rightSpoon: spoon4, developer: "Krislyn")
var developer4 = Developer(leftSpoon: spoon4, rightSpoon: spoon5, developer: "Tel")
var developer5 = Developer(leftSpoon: spoon5, rightSpoon: spoon1, developer: "Mitch")

let developers = [developer1, developer2, developer3, developer4, developer5]

DispatchQueue.concurrentPerform(iterations: 5) {
    developers[$0].run()
}

