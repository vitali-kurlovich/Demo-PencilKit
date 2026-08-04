//
//  Created by Kurlovich Vitali on 8/3/26.
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGRect

extension SvgTag {
    var viewBox: CGRect {
        guard let viewBox = attributes["viewBox"] else {
            return CGRect(x: 0, y: 0, width: 1, height: 1)
        }
        return parseViewBox(from: viewBox)
    }
}

private extension SvgTag {
    func parseViewBox(from string: some StringProtocol) -> CGRect {
        var iterator = SplitIterator(string: string, separator: " ")

        let x = Double(iterator.next() ?? "0") ?? 0
        let y = Double(iterator.next() ?? "0") ?? 0
        let width = Double(iterator.next() ?? "0") ?? 0
        let height = Double(iterator.next() ?? "0") ?? 0

        return CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
    }
}
