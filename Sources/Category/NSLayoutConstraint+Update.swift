//
//  NSLayoutConstraint+Update.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

#if canImport(UIKit)
import UIKit.NSLayoutConstraint
#else
import AppKit.NSLayoutConstraint
#endif

extension NSLayoutConstraint {
    @discardableResult
    public func update(multiplier:CGFloat) -> NSLayoutConstraint{
        return update(multiplier:multiplier,constant:self.constant)
    }
    
    @discardableResult
    public func update(multiplier:CGFloat,constant:CGFloat) -> NSLayoutConstraint{
        self.isActive = false
        // NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint.init(item:self.firstItem!, attribute:self.firstAttribute, relatedBy:self.relation, toItem:self.secondItem, attribute:self.secondAttribute, multiplier:multiplier, constant:constant)
        newConstraint.priority = self.priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.isActive = true
        // NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
    
    public convenience init(
        item view1: Any,
        attribute attr1: NSLayoutConstraint.Attribute,
        relatedBy relation: NSLayoutConstraint.Relation,
        toItem view2: Any?,
        attribute attr2: NSLayoutConstraint.Attribute,
        multiplier: CGFloat = 1.0,
        constant: CGFloat = 0.0,
        priority: LayoutPriority = .required,
        identifier: String? = nil
    ) {
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: constant)
        self.priority = priority
        if let identifier,!identifier.isEmpty{
            self.identifier = identifier
        }
    }
}
