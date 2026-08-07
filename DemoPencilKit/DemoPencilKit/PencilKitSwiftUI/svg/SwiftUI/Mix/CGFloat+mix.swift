//
//  CGFloat+mix.swift
//  DemoPencilKit
//
//  Created by Kurlovich Vitali on 8/7/26.
//

import struct CoreFoundation.CGFloat

extension CGFloat {
    func mix(with other: Self, by fraction: Double) -> Self {
        self + fraction * (other - self)
    }
}
