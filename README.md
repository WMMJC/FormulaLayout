[🇨🇳 中文](README.zh-CN.md) | [🇺🇸 English](README.md)


### ***FormulaLayout*** Provides mathematical-style expressions to intuitively describe page layouts, based on operator-based rewriting

In short, use the following DSL:
````swift
myView.makeFormulas {
    [.leading => .trailing] == targetView * 1.0 + 12
}
````
Replace it with:
````swift
 NSLayoutConstraint(
     item: myView, attribute: .leading, relatedBy: .equal,
     toItem: targetView, attribute: .trailing,
     multiplier: 1.0, constant: 12
 )
````

# Formula relationship diagram

````swift
myView.makeFormulas {
    [Attribute] == view * multiplier + constant
}

Attribute: 
    1. Attribute
    2. Attribute => Attribute
    3. Attribute(<#LayoutPriority#>) // Attribute.priority(<#LayoutPriority#>)
    4. Attribute(<#CGFloat#>) // Attribute.constant(<#CGFloat#>)
    5. Attribute(<#String#>) // Attribute.identifier(<#String#>)
    6. Attribute(p:<#LayoutPriority#>,c:<#CGFloat#>,i:<#String?#>) // Attribute.pci(p:<#LayoutPriority#>,c:<#CGFloat#>,i:<#String?#>)
    
Operator: 
    =>, == ,>=, <=, * , + , -
    
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
    [.edge(20)] == anotherView
	//[.leading(20), .trailing(-20), .bottom(-20), .top(20)] == anotherView
    
}
// width = high = 100
myView.makeFormulas {
    [.height, .width] == 100
}
// Aspect ratio: the height is twice the width
myView.makeFormulas {
    [.height => .width] == myView * 2
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
    [.bottom => .top,.left => .right] == anotherView
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
- Swift 5.0+


# Installation

### Swift Package Manager:
````
package(url: "https://github.com/WMMJC/FormulaLayout.git", .from("1.0.0"))
````


# License
**FormulaLayout** is available under the MIT license. See the LICENSE file for more info.
