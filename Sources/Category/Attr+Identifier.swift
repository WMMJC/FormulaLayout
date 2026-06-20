//
//  Attr+Identifier.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

#if canImport(UIKit)
import UIKit.NSLayoutConstraint
#else
import AppKit.NSLayoutConstraint
#endif

extension Attr{
    // [.width("identifier")]
#if swift(>=5.2)
    public func callAsFunction(_ i: String) -> Attr { identifier(i) }
#else
    // [.width["identifier"]]
    public subscript(_ i: String) -> Attr { identifier(i)}
#endif
    public func identifier(_ i: String) -> Attr { var copy = self;copy.identifier = i;return copy; }
}

enum IdentifierNumber{
    case one // 一般情况下只有一个立即返回
    case more
}

extension ConstraintView {
   
    // 找指定 identifier 的约束
    public func findConstraint(identifier: String) -> NSLayoutConstraint? {
        let v = findConstraints(identifier: identifier,type:.one)
        return v.isEmpty ? nil : v.first!
    }
    func findConstraints(identifier: String,type:IdentifierNumber) ->[NSLayoutConstraint] {
        let constraint = allRelatedConstraints(withIdentifier: identifier,type:type)
        guard !constraint.isEmpty else {
            assertionFailure("Constraint with identifier '\(identifier)' not found.")
            return []
        }
        // 如果修改的是 constant，且约束处于激活状态，建议先 deactivate 再修改，或者直接修改后调用 layoutIfNeeded
        return constraint
    }
}

extension ConstraintView {
    
    // 从当前 view 向上遍历 superview 链并收集所有与 self 有关且 identifier 匹配的 constraints
    private func constraintsInAncestorChain(withIdentifier id: String) -> [NSLayoutConstraint] {
        var matches: [NSLayoutConstraint] = []
        var v: ConstraintView? = self.superview
        while let sv = v {
            for c in sv.constraints {
                if c.identifier == id {
                    if let first = c.firstItem as? ConstraintView, first == self { matches.append(c); continue }
                    if let second = c.secondItem as? ConstraintView, second == self { matches.append(c); continue }
                }
            }
            v = sv.superview
        }
        return matches
    }

    // 返回当前 view、自身持有的、其祖先链中引用它的，以及子树中所有匹配 identifier 的 constraints
    // 智能查找约束：先在当前 view 找，找不到则去 superview 找
    // 因为相对约束如 top/leading 实际上存储在 superview 的 constraints 数组中
    func allRelatedConstraints(withIdentifier id: String,type:IdentifierNumber) -> [NSLayoutConstraint] {
        var results: [NSLayoutConstraint] = []

        // 1. 查找自身约束 (如 width, height) 自身持有的 constraints
        for c in self.constraints where c.identifier == id {
            results.append(c)
            if type == .one ,!results.isEmpty{
                return results
            }
        }
        
        // 2. 查找父视图约束 (如 top, leading 等跨视图约束)
        // 祖先链（向上）中引用该 view 的 constraints
        results.append(contentsOf: constraintsInAncestorChain(withIdentifier: id))
        if type == .one ,!results.isEmpty{
            return results
        }
        // 子视图树（向下）递归
        for sub in subviews {
            results.append(contentsOf: sub.allRelatedConstraints(withIdentifier: id,type:type))
            if type == .one ,!results.isEmpty{
                return results
            }
        }

        return results
    }

    // 移除所有匹配 identifier 的约束（会从约束所在的视图上移除）
    @discardableResult
    func removeAllRelatedConstraints(withIdentifier id: String) -> [NSLayoutConstraint] {
        var removed: [NSLayoutConstraint] = []

        // 自身持有的
        for c in constraints.filter({ $0.identifier == id }) {
            removeConstraint(c)
            removed.append(c)
        }

        // 祖先链
        var v: ConstraintView? = self.superview
        while let sv = v {
            for c in sv.constraints.filter({ $0.identifier == id }) {
                // 确认关联到 self 或其子视图（因为祖先约束可能关联到其它子视图）
                let firstIsRelated = (c.firstItem as? ConstraintView)?.isDescendant(of: self) ?? false
                let secondIsRelated = (c.secondItem as? ConstraintView)?.isDescendant(of: self) ?? false
                if firstIsRelated || secondIsRelated {
                    sv.removeConstraint(c)
                    removed.append(c)
                }
            }
            v = sv.superview
        }

        // 子视图树
        for sub in subviews {
            removed.append(contentsOf: sub.removeAllRelatedConstraints(withIdentifier: id))
        }

        return removed
    }
}
