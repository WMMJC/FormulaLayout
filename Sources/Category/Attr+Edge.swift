//
//  Attr+Edge.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

import Foundation

extension Attr{
    // [.top(10), .bottom(-20), .left(-10)]
#if swift(>=5.2)
    public func callAsFunction(_ c: CGFloat) -> Attr { constant(c) }
#else
    // [.top[10], .bottom[-20], .left[-10]]
    public subscript(_ c: CGFloat) -> Attr { constant(c) }
#endif
    public func constant(_ c: CGFloat) -> Attr { var copy = self;copy.constant = c;return copy; }
}
