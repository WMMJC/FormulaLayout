[🇨🇳 中文](README.zh-CN.md) | [🇺🇸 English](README.md)


### ***FormulaLayout*** This provides a simple and intuitive method for creating layouts using mathematical-style expressions, based on operator overloading.

# Formula relationship diagram

````swift
myView.makeFormulas {
    [Attribute] == view * multiplier + constant
}

Attribute:
    [Attribute,Attribute...]
    [Attribute == Attribute,Attribute == Attribute...]
    [Attribute(priority/constant/identifier),Attribute...]

[Attribute]:
    [Attribute,...](constant)
    
Operator: 
    == ,>=, <=, * , + , -
    
````

# Quick Start
Here's some example code:

````swift
// The centre of myView is the same as the centre of anotherView
myView.makeFormulas {
    [.centerX, .centerY] == anotherView
}

// Padding
myView.makeFormulas {
    [.leading, .trailing, .bottom, .top](20) == anotherView
	//[.leading(20), .trailing(-20), .bottom(-20), .top(20)] == anotherView
    
}
// width = high = 100
myView.makeFormulas {
    [.height, .width] == 100
}
// Aspect ratio: the height is twice the width
myView.makeFormulas {
    [.height == .width] == myView * 2
    [.width] == 100
}

// Set the offset to 10; the left edge of myView will be equal to the left offset of anotherView plus 10
myView.makeFormulas {
    [.leading] == anotherView + 10 
    //[.leading(10)] == anotherView
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}

// Set the leading and top of myView to the leading and top of anotherView, with an offset of -10
myView.makeFormulas {
    [.leading,.top] == anotherView - 10 
}

// Set the height of myView to be less than or equal to 1.5 times the height of anotherView
myView.makeFormulas {
    [.height] <= anotherView * 1.5
}

// Set priorities
myView.makeFormulas {
    [.bottom(.defaultHigh)] == view.keyboardLayoutGuide
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}

// Set the bottom and left properties of myView to the top and right properties of anotherView
myView.makeFormulas {
    [.bottom == .top,.left == .right] == anotherView
}

// Bind identifier
myView.makeFormulas {
    [.bottom("identifier")] == anotherView
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}
myView.updateFormula(identifier:"identifier"){
    [.constant] == -5
    //[.multiplier] == 2.5
}

````

# Requirements

- iOS 9.0+, macOS 10.11+
- Swift 5.2+


# Installation

### Swift Package Manager:
````
package(url: "https://github.com/WMMJC/FormulaLayout.git", .from("1.0.0"))
````


# License
**FormulaLayout** is available under the MIT license. See the LICENSE file for more info.
