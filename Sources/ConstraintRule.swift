//
//  ConstraintRule.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

#if canImport(UIKit)
import UIKit.NSLayoutConstraint
#else
import AppKit.NSLayoutConstraint
#endif

public typealias LayoutAttribute = NSLayoutConstraint.Attribute
public typealias LayoutRelation = NSLayoutConstraint.Relation

// 属性包装器
public struct Attr {
    // 默认：[.top]
    let attribute: LayoutAttribute

    // 映射：[.top == .bottom]
    var targetAttribute: LayoutAttribute? = nil
    
    // [.top(.defaultHigh)]
    var priority: LayoutPriority = .required
    
    // [.top(10)]
    var constant: CGFloat = 0.0
    
    // [.top("identifier")]
    var identifier: String? = nil
    
    // 更新约束的标记
    var ismultiplier = false
    var isconstant = false
}
extension Attr{
    // [.bottom(p:.defaultHigh,c:0, i:"id")]
#if swift(>=5.2)
    public func callAsFunction(p: LayoutPriority, c: CGFloat,i: String? = nil) -> Attr { pci(p:p,c:c,i:i)}
#else
    // [.bottom[p:.defaultHigh,c:0, i:"id"]]
    public subscript(p: LayoutPriority, c: CGFloat,i: String? = nil) -> Attr { pci(p:p,c:c,i:i)}
#endif
    
    /// 配置 优先级 / 间距 / 标识符
    /// - Parameters:
    ///   - p: 优先级
    ///   - c: 间距
    ///   - i: 标识符
    /// - Returns: self
    public func pci(p: LayoutPriority, c: CGFloat,i: String? = nil) -> Attr { var copy = self;copy.identifier = i;copy.constant = c;copy.priority = p;return copy;}
}

extension Attr{
    // 用于创建约束
    public static let top = Attr(attribute: .top)
    public static let bottom = Attr(attribute: .bottom)
    public static let left = Attr(attribute: .left)
    public static let right = Attr(attribute: .right)
    public static let leading = Attr(attribute: .leading)
    public static let trailing = Attr(attribute: .trailing)
    
    public static let width = Attr(attribute: .width)
    public static let height = Attr(attribute: .height)
   
    public static let centerX = Attr(attribute: .centerX)
    public static let centerY = Attr(attribute: .centerY)
    
    public static let lastBaseline = Attr(attribute: .lastBaseline)
    public static let firstBaseline = Attr(attribute: .firstBaseline)
}

extension Attr{
    // 仅用于更新约束
    public static let constant = Attr(attribute: .notAnAttribute,isconstant: true)
    public static let multiplier = Attr(attribute: .notAnAttribute,ismultiplier: true)
}

//#if canImport(UIKit)
//extension Attr{
//    //Margin会有默认的8间距，页边距由其layoutMargins属性定义
//    public static let leftMargin = Attr(attribute: .leftMargin)
//    public static let rightMargin = Attr(attribute: .rightMargin)
//    public static let topMargin = Attr(attribute: .topMargin)
//    public static let bottomMargin = Attr(attribute: .bottomMargin)
//    public static let leadingMargin = Attr(attribute: .leadingMargin)
//    public static let trailingMargin = Attr(attribute: .trailingMargin)
//    public static let centerXWithinMargins = Attr(attribute: .centerXWithinMargins)
//    public static let centerYWithinMargins = Attr(attribute: .centerYWithinMargins)
//}
//#endif

// view2 * 0.5 + 4
public struct ViewExpr {
    let item: ConstraintTarget
    var multiplier: CGFloat = 1.0
    var constant: CGFloat = 0.0
}

// 约束规则
public struct ConstraintRule {
    var sourceAttrs: [Attr]
    var relation: LayoutRelation = .equal
    var targetItem: ConstraintTarget? = nil
    
    // 乘数[.height] == view * 1.5
    var multiplier: CGFloat = 1.0
    
    // 间距 [.top] == view + 10
    var constant: CGFloat = 0.0
    
    func generate(for sourceView: ConstraintView) -> [NSLayoutConstraint] {
        return sourceAttrs.compactMap { attr in
            if attr.ismultiplier || attr.isconstant{
                assertionFailure("❌❌❌ create layout not support [.constant] or [.multiplier]")
                return nil
            }
            let tAttr = attr.targetAttribute ?? attr.attribute
            // [.top(10)](20) == view + 30 间距为10+20+30=60
            let cConstant = attr.constant + constant
            let c = NSLayoutConstraint(
                item: sourceView, attribute: attr.attribute, relatedBy: relation,
                toItem: targetItem, attribute: tAttr,
                multiplier: multiplier, constant: cConstant
            )
            if let identifier = attr.identifier,!identifier.isEmpty{
                c.identifier = identifier
            }
            c.priority = attr.priority
            return c
        }
    }
    
    func update(for targetLayout: NSLayoutConstraint) -> [NSLayoutConstraint] {
        return sourceAttrs.compactMap { attr in
            if attr.ismultiplier{
                /*
                 NSLayoutConstraint 的 multiplier 不能直接修改；要更改比例需移除旧约束并创建新约束：
                 [.multiplier] = 1.5，这个1.5是放在constant中的
                 */
                return targetLayout.update(multiplier: self.constant)
            }
            if attr.isconstant{
                // NSLayoutConstraint 的 constant 直接修改
                targetLayout.constant = self.constant
                return targetLayout
            }
            assertionFailure("❌❌❌ update: only support [.constant] or [.multiplier]")
            return nil
        }
    }
}
