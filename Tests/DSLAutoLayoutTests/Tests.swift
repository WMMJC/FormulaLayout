import XCTest
@testable import FormulaLayout

#if canImport(UIKit)
import UIKit
typealias View = UIView
#else
import AppKit
typealias View = NSView
#endif

class FormulaLayoutTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testSetupLayout() {
        let c = ConstraintView()
        let a = ConstraintView()
        let d = ConstraintView()
        d.addSubview(c)
        d.addSubview(a)
        testSetupLayout(view1: a, view2: c, isExpanded: true)
    }
    func testSetupLayout(view1: ConstraintView, view2: ConstraintView, isExpanded: Bool) {
        let safeArea = view1.safeAreaLayoutGuide
        //⚠️⚠️⚠️⚠️⚠️⚠️下面的是介绍用法，运行时会崩溃，同一个Attribute只能添加一个约束
        view1.makeLayouts {
            // top, bottom, left 都等于 view2
            [.top, .bottom, .left] == view2
            
            // height 和 width 都等于 100
            [.height, .width] == 100
            
            // .top 等于 view2 的 top，偏移 8
            [.top] == view2 + 8

            [.leading(10), .top(10), .bottom(-10), .trailing(-10)] == view2
            //[.edge(10)] == view2

            // .left 大于等于 view2 的 left，偏移 12
            [.left] >= view2 + 12
            
            // 优先级修饰：width 等于 120，优先级为 .defaultHigh
            [.width(.defaultHigh)] == 120
            [.leading, .trailing] == safeArea
            
            // height 小于等于 view2 * 0.5 + 4
            [.height] <= view2 * 0.5 + 4
            
            //view1 的 top 等于 view2 的 bottom，偏移 20
            [.top => .bottom,.left => .right] == view2 + 10
           
            if isExpanded {
                [.height] == 300
            } else {
                [.height] == 100
            }
            
            // 属性标记
            [.top("topMargin") => .bottom] == view1.safeAreaLayoutGuide
        }
        view1.updateLayout("topMargin") {
            [.constant] == 1.5
        }
    }
    func testUpdateLayout(view: ConstraintView,boxView: ConstraintView, isExpanded: Bool) {
        //    ConstraintView.animate(withDuration: 0.3) {
        // 修改宽度
        boxView.updateLayout("boxWidth") {
            [.constant] == 100
        }
        // 修改高度
        boxView.updateLayout("boxHeight") { [.constant] == 100 }
        // 触发布局更新
        //        view.layoutIfNeeded()
        //    }
    }
    
}
