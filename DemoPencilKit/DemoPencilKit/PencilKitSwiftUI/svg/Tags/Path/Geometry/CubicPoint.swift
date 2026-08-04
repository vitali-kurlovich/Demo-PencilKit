//
//  Created by Kurlovich Vitali on 8/4/26.
//

struct CubicPoint: Sendable, Hashable {
    var p1: Point
    var p2: Point
    var p: Point
}

struct CubicVector: Sendable, Hashable {
    var v1: Vector
    var v2: Vector
    var v: Vector
}

extension CubicPoint {
    static func + (lhs: CubicPoint, rhs: CubicVector) -> CubicPoint {
        .init(p1: lhs.p1 + rhs.v1, p2: lhs.p2 + rhs.v2, p: lhs.p + rhs.v)
    }

    static func - (lhs: CubicPoint, rhs: CubicVector) -> CubicPoint {
        .init(p1: lhs.p1 - rhs.v1, p2: lhs.p2 - rhs.v2, p: lhs.p - rhs.v)
    }
}
