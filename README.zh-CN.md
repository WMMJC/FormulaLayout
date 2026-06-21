[🇨🇳 中文](README.zh-CN.md) | [🇺🇸 English](README.md) 


### ***FormulaLayout*** 提供了数学风格的表达式，以便直观的描述页面布局，基于操作符的重写

简而言之，使用如下DSL:
````swift
myView.makeLayouts {
    [.leading => .trailing] == targetView * 1.0 + 12
}
````
替换它：
````swift
 NSLayoutConstraint(
     item: myView, attribute: .leading, relatedBy: .equal,
     toItem: targetView, attribute: .trailing,
     multiplier: 1.0, constant: 12
 )
````

# 公式关系图

````swift
myView.makeLayouts {
    [Attribute] == view * multiplier + constant
}

Attribute: 
    1. Attribute
    2. Attribute => Attribute // Attribute(<#Attr#>)
    3. Attribute(<#LayoutPriority#>) // Attribute.priority(<#LayoutPriority#>)
    4. Attribute(<#CGFloat#>) // Attribute.constant(<#CGFloat#>)
    5. Attribute(<#String#>) // Attribute.identifier(<#String#>)
    6. Attribute(m:<#Attr#>, p:<#LayoutPriority#>,c:<#CGFloat#>,i:<#String?#>) // Attribute.mpci(m:<#Attr#>,p:<#LayoutPriority#>,c:<#CGFloat#>,i:<#String?#>)
    
运算符: 
    =>, == ,>=, <=, * , + , -
    
````
# 快速开始
下面是一些示例代码:

````swift
// myView的中心等于anotherView中心
myView.makeLayouts {
    [.centerX, .centerY] == anotherView
}

// 设置内边距
myView.makeLayouts {
    [.edge(20)] == anotherView
	//[.leading(20), .trailing(-20), .bottom(-20), .top(20)] == anotherView
    
}
// 宽高为100
myView.makeLayouts {
    [.height, .width] == 100
}
// 宽高比，height是width的2倍
myView.makeLayouts {
    [.height => .width] == myView * 2
    [.width] == 100
}

// 设置偏移为10，myView的左侧等于anotherView的左侧偏移+10
myView.makeLayouts {
    [.leading] == anotherView + 10 
    //[.leading(10)] == anotherView
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}

// 设置myView的leading，top为anotherView的leading，top且偏移-10
myView.makeLayouts {
    [.leading,.top] == anotherView - 10 
}

// 设置myView的高度小于等于anotherView的高度的1.5倍
myView.makeLayouts {
    [.height] <= anotherView * 1.5
}

// 设置优先级
myView.makeLayouts {
    [.bottom(.defaultHigh)] == view.keyboardLayoutGuide
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}

// 设置myView的bottom和left等于anotherView的top和right
myView.makeLayouts {
    [.bottom => .top,.left => .right] == anotherView
}

// 绑定identifier
myView.makeLayouts {
    [.bottom("identifier")] == anotherView
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}
myView.updateLayout("identifier"){
    [.constant] == -5
    //[.multiplier] == 2.5
}

````

# 使用环境

- iOS 9.0+, macOS 10.11+
- Swift 5.0+

# 安装

### Swift Package Manager:
````
package(url: "https://github.com/WMMJC/FormulaLayout.git", .from("1.0.0"))
````


# 许可证
**FormulaLayout** 采用 MIT 许可，更多信息，请参阅 LICENSE 文件
