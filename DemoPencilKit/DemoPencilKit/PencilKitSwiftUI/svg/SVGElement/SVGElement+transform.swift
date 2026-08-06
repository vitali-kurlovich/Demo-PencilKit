//
//  Created by Kurlovich Vitali on 8/3/26.
//

import struct CoreGraphics.CGAffineTransform
import struct Foundation.CGFloat

extension SVGElement {
    var transform: CGAffineTransform? {
        guard let transform = attributes["transform"] else {
            return nil
        }

        if transform.hasPrefix("matrix(") {
            let mt = transform.dropFirst("matrix(".count).dropLast()
            return parseMatrix(from: mt)
        }

        return nil
    }
}

private extension SVGElement {
    func parseMatrix(from string: some StringProtocol) -> CGAffineTransform {
        var iterator = SplitIterator(string: string, separator: ",")

        let a = Double(iterator.next() ?? "1") ?? 1
        let b = Double(iterator.next() ?? "0") ?? 0
        let c = Double(iterator.next() ?? "0") ?? 0
        let d = Double(iterator.next() ?? "1") ?? 1

        let tx = Double(iterator.next() ?? "0") ?? 0
        let ty = Double(iterator.next() ?? "0") ?? 0

        return CGAffineTransform(CGFloat(a), CGFloat(b), CGFloat(c), CGFloat(d), CGFloat(tx), CGFloat(ty))
    }
}
