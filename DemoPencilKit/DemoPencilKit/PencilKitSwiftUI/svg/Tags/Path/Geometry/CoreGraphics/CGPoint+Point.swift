//
//  Created by Kurlovich Vitali on 8/5/26.
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint

public extension CGPoint {
    @inlinable
    init(_ p: Point) {
        self.init(x: CGFloat(p.x), y: CGFloat(p.y))
    }
}
