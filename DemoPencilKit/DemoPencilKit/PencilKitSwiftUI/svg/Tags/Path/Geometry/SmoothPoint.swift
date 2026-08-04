//
//  Created by Kurlovich Vitali on 8/4/26.
//

struct SmoothPoint: Sendable, Hashable {
    var p2: Point
    var p: Point
}

struct SmoothVector: Sendable, Hashable {
    var v2: Vector
    var v: Vector
}

extension SmoothPoint {
    static func + (lhs: SmoothPoint, rhs: SmoothVector) -> SmoothPoint {
        SmoothPoint(p2: lhs.p2 + rhs.v2, p: lhs.p + rhs.v)
    }

    static func - (lhs: SmoothPoint, rhs: SmoothVector) -> SmoothPoint {
        SmoothPoint(p2: lhs.p2 - rhs.v2, p: lhs.p - rhs.v)
    }
}
