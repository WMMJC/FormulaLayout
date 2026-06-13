//
//  Priority.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

import Foundation

extension Attr{
    // [.width(.defaultHigh)]
    public func callAsFunction(_ p: LayoutPriority) -> Attr {
        var copy = self
        copy.priority = p
        return copy
    }
}
