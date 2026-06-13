[🇨🇳 中文](README.zh-CN.md) | [🇺🇸 English](README.md) 


### ***FormulaLayout*** 提供了一种使用类似数学公式创建布局的简单且直观的方法，基于操作符的重写

# 公式关系图

````swift
myView.makeFormulas {
       属性     关系 目标     乘数     正负  偏移
    [Attribute] == view * multiplier + constant
}

属性:
    [Attribute,Attribute...]        
    [Attribute == Attribute,Attribute == Attribute...]        
    [Attribute(priority/constant/identifier),Attribute...]

[属性]:
    [Attribute,...](constant)
    
运算符: 
    == ,>=, <=, * , + , -
    
````
# 快速开始
下面是一些示例代码:

````swift
// myView的中心等于anotherView中心
myView.makeFormulas {
    [.centerX, .centerY] == anotherView
}

// 设置内边距
myView.makeFormulas {
    [.leading, .trailing, .bottom, .top](20) == anotherView
	//[.leading(20), .trailing(-20), .bottom(-20), .top(20)] == anotherView
    
}
// 宽高为100
myView.makeFormulas {
    [.height, .width] == 100
}
// 宽高比，height是width的2倍
myView.makeFormulas {
    [.height == .width] == myView * 2
    [.width] == 100
}

// 设置偏移为10，myView的左侧等于anotherView的左侧偏移+10
myView.makeFormulas {
    [.leading] == anotherView + 10 
    //[.leading(10)] == anotherView
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}

// 设置myView的leading，top为anotherView的leading，top且偏移-10
myView.makeFormulas {
    [.leading,.top] == anotherView - 10 
}

// 设置myView的高度小于等于anotherView的高度的1.5倍
myView.makeFormulas {
    [.height] <= anotherView * 1.5
}

// 设置优先级
myView.makeFormulas {
    [.bottom(.defaultHigh)] == view.keyboardLayoutGuide
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}

// 设置myView的bottom和left等于anotherView的top和right
myView.makeFormulas {
    [.bottom == .top,.left == .right] == anotherView
}

// 绑定identifier
myView.makeFormulas {
    [.bottom("identifier")] == anotherView
    //[.bottom(p:.defaultHigh,c:10, i:"identifier")] == view
}
myView.updateFormula(identifier:"identifier"){
    [.constant] == -5
    //[.multiplier] == 2.5
}

````

# 使用环境

- iOS 9.0+, macOS 10.11+
- Swift 5.2+

# 安装

### Swift Package Manager:
````
package(url: "https://github.com/WMMJC/FormulaLayout.git", .from("1.0.0"))
````


# 许可证
**FormulaLayout** 采用 MIT 许可，更多信息，请参阅 LICENSE 文件
