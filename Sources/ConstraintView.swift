//
//  ConstraintView.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

#if canImport(UIKit)
import UIKit.UIView
public typealias ConstraintView = UIView
public typealias LayoutPriority = UILayoutPriority
public typealias LayoutGuide = UILayoutGuide
public typealias LayoutAxis = NSLayoutConstraint.Axis
#else
import AppKit.NSView
public typealias ConstraintView = NSView
public typealias LayoutPriority = NSLayoutConstraint.Priority
public typealias LayoutGuide = NSLayoutGuide
public typealias LayoutAxis = NSLayoutConstraint.Orientation
#endif

// MARK: - 统一 ConstraintView 和 UILayoutGuide 都能作为约束的目标
public protocol ConstraintTarget {}
extension ConstraintView: ConstraintTarget {}
extension LayoutGuide: ConstraintTarget {}

@resultBuilder
public enum ConstraintsBuilder {
    public static func buildExpression(_ expression: ConstraintRule) -> [ConstraintRule] { [expression] }
    public static func buildBlock(_ components: [ConstraintRule]...) -> [ConstraintRule] { components.flatMap { $0 } }
    
    // 支持 if/else
    public static func buildOptional(_ component: [ConstraintRule]?) -> [ConstraintRule] { component ?? [] }
    public static func buildEither(first component: [ConstraintRule]) -> [ConstraintRule] { component }
    public static func buildEither(second component: [ConstraintRule]) -> [ConstraintRule] { component }
}

extension ConstraintView {
    public func makeFormulas(@ConstraintsBuilder builder: () -> [ConstraintRule]) {
        translatesAutoresizingMaskIntoConstraints = false
        let rules = builder()
        let constraints = rules.flatMap { $0.generate(for: self) }
        NSLayoutConstraint.activate(constraints)
    }
    
    // 更新 constant / multiplier 的约束
    public func updateFormula(identifier: String,@ConstraintsBuilder builder: () -> [ConstraintRule]) {
        let rules = builder()
        if let c = self.findConstraint(identifier: identifier){
            _ = rules.flatMap { $0.update(for: c) }
        }
    }
    /*
     CH (Content Hugging) ：防止视图被拉大
     CR (Content Compression Resistance) ：防止视图被压缩

     属性                             含义              默认优先级
     Content Hugging                最大尺寸            250 (低)
     Content Compression Resistance 最小尺寸            750 (高)
     原理：CH 越高 → 越不愿被拉伸；CR 越高 → 越不愿被压缩。
     */
    public func ch(priority:LayoutPriority, axis: LayoutAxis) {
        self.setContentHuggingPriority(priority, for: axis)
    }
    public func cr(priority:LayoutPriority, axis: LayoutAxis) {
        self.setContentCompressionResistancePriority(priority, for: axis)
    }
}
