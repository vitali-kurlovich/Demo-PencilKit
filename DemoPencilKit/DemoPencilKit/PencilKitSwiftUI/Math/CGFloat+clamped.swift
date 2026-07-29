//
//  CGFloat+clamped.swift
//  DemoPencilKit
//
//  Created by Kurlovich Vitali on 7/29/26.
//

import Foundation

/// CGFloat+clamped
extension CGFloat {
    mutating func clamp(to range: ClosedRange<CGFloat>) {
        self = Swift.min(range.upperBound, Swift.max(range.lowerBound, self))
    }

    func clamped(to range: ClosedRange<CGFloat>) -> Self {
        var value = self
        value.clamp(to: range)
        return value
    }
}
