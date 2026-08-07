//
//  Created by Kurlovich Vitali on 8/7/26.
//

import struct CoreFoundation.CGFloat

extension [CGFloat] {
    func mix(with other: Self, by fraction: Double) -> Self {
        assert(count == other.count)

        var result: [CGFloat] = []
        result.reserveCapacity(count)

        for index in startIndex ..< endIndex {
            result.append(self[index].mix(with: other[index], by: fraction))
        }

        return result
    }
}
