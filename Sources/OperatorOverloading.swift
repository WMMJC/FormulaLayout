//
//  OperatorOverloading.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

#if canImport(UIKit)
import UIKit.UIView
#else
import AppKit.NSView
#endif

// MARK: - 会自动推断 Int/Double 字面量
// view2 + 10
public func + (lhs: ConstraintTarget, rhs: CGFloat) -> ViewExpr { ViewExpr(item: lhs, constant: rhs) }

// view2 - 10
public func - (lhs: ConstraintTarget, rhs: CGFloat) -> ViewExpr { ViewExpr(item: lhs, constant: -rhs) }
// view2  * 0.5
public func * (lhs: ConstraintTarget, rhs: CGFloat) -> ViewExpr { ViewExpr(item: lhs, multiplier: rhs) }

/*
 view2 * 0.5  +  4
 view2 * 0.5 等于ViewExpr（上面 * 的结果）
 ViewExpr + 4
 */
public func + (lhs: ViewExpr, rhs: CGFloat) -> ViewExpr { var e = lhs; e.constant += rhs; return e }
public func - (lhs: ViewExpr, rhs: CGFloat) -> ViewExpr { var e = lhs; e.constant -= rhs; return e }


// MARK: - [Attr] 操作符重载
// [.top , .bottom] == view
public func == (lhs: [Attr], rhs: ConstraintTarget) -> ConstraintRule { ConstraintRule(sourceAttrs: lhs, targetItem: rhs) }

// [.top , .bottom] == view + 10
public func == (lhs: [Attr], rhs: ViewExpr) -> ConstraintRule {
    ConstraintRule(sourceAttrs: lhs, targetItem: rhs.item,
                   multiplier: rhs.multiplier, constant: rhs.constant)
}
// [.width, .height] == 10
public func == (lhs: [Attr], rhs: CGFloat) -> ConstraintRule { ConstraintRule(sourceAttrs: lhs, constant: rhs) }

// >= 和 <= 运算
public func >= (lhs: [Attr], rhs: ViewExpr) -> ConstraintRule { var r = lhs == rhs; r.relation = .greaterThanOrEqual; return r }
public func <= (lhs: [Attr], rhs: ViewExpr) -> ConstraintRule { var r = lhs == rhs; r.relation = .lessThanOrEqual; return r }
public func >= (lhs: [Attr], rhs: CGFloat) -> ConstraintRule { var r = lhs == rhs; r.relation = .greaterThanOrEqual; return r }
public func <= (lhs: [Attr], rhs: CGFloat) -> ConstraintRule { var r = lhs == rhs; r.relation = .lessThanOrEqual; return r }

// MARK: - [AttrMapping] 操作符重载
// [.top == .bottom]
public func == (lhs: Attr, rhs: Attr) -> AttrMapping { AttrMapping(source: lhs, target: rhs.attribute) }

// [.top == .bottom] == view
public func == (lhs: [AttrMapping], rhs: ConstraintTarget) -> ConstraintRule {
    var map: [LayoutAttribute: LayoutAttribute] = [:]
    for m in lhs { map[m.source.attribute] = m.target }
    return ConstraintRule(sourceAttrs: lhs.map { $0.source }, targetItem: rhs, targetAttrMap: map)
}
// [.top == .bottom] == view + 10
public func == (lhs: [AttrMapping], rhs: ViewExpr) -> ConstraintRule {
    var map: [LayoutAttribute: LayoutAttribute] = [:]
    for m in lhs { map[m.source.attribute] = m.target }
    return ConstraintRule(
        sourceAttrs: lhs.map { $0.source },
        targetItem: rhs.item,
        targetAttrMap: map,
        multiplier: rhs.multiplier,
        constant: rhs.constant
    )
}
