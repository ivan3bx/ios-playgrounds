/*: 
## Protocol Extensions Playground

This playground shows a few examples of protocol extensions at work
*/

import CoreGraphics

/*:

### Protocols & Properties

Protocols can declare properties; extensions can provide default
implementations of those properties

*/
protocol SimpleProtocol {
    var isActive: Bool { get }
}

extension SimpleProtocol {
    var isActive: Bool { return false }
}

class A : SimpleProtocol {
    var isActive = true // will override the extension's implementation
}

class B : SimpleProtocol {
    // will inherit the extension's implementation
}

A().isActive == true
B().isActive == false


/*:

### Defining constraints

We can define type constraints on a protocol extension, which

*/
extension CollectionType where Generator.Element: StringLiteralConvertible {

    func oddStrings() -> [Generator.Element] {
        var result : [Generator.Element] = []
        
        var index = self.startIndex
        var i = 0
        repeat {
            let aStringValue = self[index]
            if i % 2 == 0 { result.append(aStringValue) }
            index = index.successor()
            i++
        } while (index != self.endIndex)

        return result
    }
}

let arrayOfStrings = ["a", "b", "c", "d", "e", "f", "g"]
let arrayOfNumbers = [1, 2, 3, 4, 5]
arrayOfStrings.oddStrings()

// The following method is not defined for collections with this constraint:
// arrayOfNumbers.oddStrings()

/*:

Another trivial example below.  The constraint clause expects a protocol type
(not class/struct).

Trying to have it conform to something like 'Int' produces
the following error: *"Playground execution failed: type 'Generator.Element' constrained to non-protocol type 'Int'"*

*/

extension CollectionType where Generator.Element: IntegerLiteralConvertible {
    func asCGFloats() -> [CGFloat] {
        return self.map { CGFloat($0 as! Int) }
    }
}

let intArray : [Int]     = [1, 2, 3]
let cgFloats : [CGFloat] = intArray.asCGFloats()


