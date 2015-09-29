//: ## Comments and Documentation
//: (aka boring bits today that may become more important tomorrow)
//:
//: See also Erica Sadun's [Swift header documentation in Xcode 7](http://ericasadun.com/2015/06/14/swift-header-documentation-in-xcode-7/)

/*:
### Method Documentation

* Begin the line with &#47;&#47;&#47; for single-line comment
* Enclose with &#47;&#42;&#42; and &#42;&#47; for block-style
* For block-style, keep the opening &#47;&#42;&#42; on its own line
* Describe method param "p" with
    * ```Parameter p: desc```
* Describe return signature with
    * ```Returns: desc```
*/

class Foo {
    
    /**
      Method to return a subset of a ```String``` array
     
        - Parameter inputArray: The array with which this method will start
        - Parameter startIndex: The start of the range
        - Parameter endIndex:   The end of the range (inclusive)
     
        - Returns: a new array equal to size ```(endIndex - startIndex)```
    */
    func aMethod(inputArray: [String], startIndex: Int, endIndex: Int) -> [String] {
        let subset = inputArray[startIndex...endIndex]
        return Array(subset)
    }

/*:
Here's what the method doc above looks like (option-click the method, or open up the QuickHelp Inspector)
![Method Documentation](method_doc_example.png)
*/

    
    /// This just demonstrates line comments (not as clean but same effect)
    ///
    ///  - SeeAlso: ```aMethod() -> [String]``` which probably does what you want
    ///
    ///  - Parameter foo: a foo object
    ///  - Parameter bar: a bar object
    ///
    ///  - Returns: nothing
    ///  - Throws: FailedError when something fails
    func nothing(foo: AnyObject, bar: AnyObject) -> Void { }
}


Foo().aMethod(["a", "b", "c", "d", "e"], startIndex: 1, endIndex: 3)

