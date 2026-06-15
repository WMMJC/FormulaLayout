//
//  Edge.swift
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

extension [Attr]{
    /*
     视图距离某个试图四周的间距，也就是内边距
     [.leading, .trailing, .bottom, .top](20)
        等同于 [.leading(20), .trailing(-20), .bottom(-20), .top(20)]
     */
#if swift(>=5.2)
    public func callAsFunction(_ c: CGFloat) -> [Attr] { edges(c) }
#else
    // [.leading, .trailing, .bottom, .top][20]
    public subscript(_ c: CGFloat) -> [Attr] { edges(c) }
#endif
    
    public func edges(_ c: CGFloat) -> [Attr] {
        self.map{
            var a = $0
            if a.attribute == .left ||  a.attribute == .top || a.attribute == .leading{
                a.constant += (c)
            }
            if a.attribute == .bottom ||  a.attribute == .trailing || a.attribute == .right{
                a.constant += (-c)
            }
            return a
        }
    }
}
