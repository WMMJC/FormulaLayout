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
    let attribute: LayoutAttribute
    // [.top(.defaultHigh)]
    var priority: LayoutPriority = .required
    // [.top(10)]
    var constant: CGFloat = 0.0
    // [.top("identifier")]
    var identifier: String = ""
    
    // 更新约束的标记
    var ismultiplier = false
    var isconstant = false
}
extension Attr{
    // [.bottom(p:.defaultHigh,c:0, i:"id")]
    public func callAsFunction(p: LayoutPriority, c: CGFloat,i: String) -> Attr {
        var copy = self
        copy.identifier = i
        copy.constant = c
        copy.priority = p
        return copy
    }
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

//extension Attr{
//    Margin会有默认的8间距
//    public static let leftMargin = Attr(attribute: .leftMargin)
//    public static let rightMargin = Attr(attribute: .rightMargin)
//    public static let topMargin = Attr(attribute: .topMargin)
//    public static let bottomMargin = Attr(attribute: .bottomMargin)
//    public static let leadingMargin = Attr(attribute: .leadingMargin)
//    public static let trailingMargin = Attr(attribute: .trailingMargin)
//    public static let centerXWithinMargins = Attr(attribute: .centerXWithinMargins)
//    public static let centerYWithinMargins = Attr(attribute: .centerYWithinMargins)
//}

// view2 * 0.5 + 4
public struct ViewExpr {
    let item: ConstraintTarget
    var multiplier: CGFloat = 1.0
    var constant: CGFloat = 0.0
}

// .top == .bottom
public struct AttrMapping {
    let source: Attr
    let target: LayoutAttribute
}

// 约束规则
public struct ConstraintRule {
    var sourceAttrs: [Attr]
    var relation: LayoutRelation = .equal
    var targetItem: ConstraintTarget? = nil
    /*
     默认：
     场景：[.top, .leading] == view2
     逻辑：所有的属性都去对齐 view2 的同名属性
     
     映射：
     场景：[.top == .bottom, .leading == .trailing] == view2
     逻辑：我的 .top 要对齐 view2 的 .bottom，而我的 .leading 要对齐 view2 的 .trailing
     */
    var targetAttrMap: [LayoutAttribute: LayoutAttribute] = [:]
    
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
            // 优先级：映射 > 默认同名属性
            // [.top == .bottom] ?? [.top, .bottom]
            let tAttr = targetAttrMap[attr.attribute] ?? attr.attribute
            // [.top(10)](20) == view + 30 间距为10+20+30=60
            let cConstant = attr.constant + constant
            let c = NSLayoutConstraint(
                item: sourceView, attribute: attr.attribute, relatedBy: relation,
                toItem: targetItem, attribute: tAttr,
                multiplier: multiplier, constant: cConstant
            )
            if !attr.identifier.isEmpty{
                c.identifier = attr.identifier
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
