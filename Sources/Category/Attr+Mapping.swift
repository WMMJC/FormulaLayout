//
//  Attr+Mapping.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

import Foundation

infix operator => : MultiplicationPrecedence
// [.top => .bottom]
public func => (lhs: Attr, rhs: Attr) -> Attr { var copy = lhs;copy.targetAttribute = rhs.attribute;return copy; }

extension Attr{
#if swift(>=5.2)
    // [.top(.bottom)]
    public func callAsFunction(_ m:Attr) -> Attr { var copy = self;copy.targetAttribute = m.attribute;return copy; }
#else
    // [.top[.bottom]]
    public subscript(_ m:Attr) -> Attr { var copy = self;copy.targetAttribute = m.attribute;return copy; }
#endif
}
