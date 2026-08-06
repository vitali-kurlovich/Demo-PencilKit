//
//  Created by Kurlovich Vitali on 8/6/26.
//

import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect

extension CGAffineTransform {
    static func fit(from src: CGRect, to dst: CGRect) -> CGAffineTransform {
        assert(src.width != 0)
        assert(src.height != 0)

        if dst == src {
            return .identity
        }

        let scale: CGFloat
        let tx: CGFloat
        let ty: CGFloat

        if src.height * dst.width <= dst.height * src.width {
            scale = dst.width / src.width
            tx = 0
            ty = (dst.height - src.height * scale) / 2
        } else {
            scale = dst.height / src.height
            tx = (dst.width - src.width * scale) / 2
            ty = 0
        }

        return CGAffineTransform(translationX: tx, y: ty)
            .scaledBy(x: scale, y: scale)
    }
}
