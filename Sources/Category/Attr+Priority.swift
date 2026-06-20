//
//  Attr+Priority.swift
//  FormulaLayout
//
//  Created by 第五东林 on 2026/06/06.
//

import Foundation

extension Attr{
    // [.width(.defaultHigh)]
#if swift(>=5.2)
    public func callAsFunction(_ p: LayoutPriority) -> Attr { priority(p);}
#else
    // [.width[.defaultHigh]]
    public subscript(_ p: LayoutPriority) -> Attr { priority(p);}
#endif
    
    public func priority(_ p: LayoutPriority) -> Attr { var copy = self;copy.priority = p;return copy; }
}
