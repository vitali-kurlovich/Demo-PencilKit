//
//  Created by Kurlovich Vitali on 7/28/26.
//

import struct Foundation.CGPoint

public struct PKDrawEvent: Sendable, Hashable {
    public enum Phase: Sendable, Hashable {
        case began
        case move
        case ended
    }

    let previousLocation: CGPoint
    let location: CGPoint
    let phase: Phase
}
