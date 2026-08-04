//
//  Created by Kurlovich Vitali on 8/4/26.
//

struct QuadraticPoint: Sendable, Hashable {
    var p1: Point
    var p: Point
}

struct QuadraticVector: Sendable, Hashable {
    var v1: Vector
    var v: Vector
}

extension QuadraticPoint {
    static func + (lhs: QuadraticPoint, rhs: QuadraticVector) -> QuadraticPoint {
        .init(p1: lhs.p1 + rhs.v1, p: lhs.p + rhs.v)
    }

    static func - (lhs: QuadraticPoint, rhs: QuadraticVector) -> QuadraticPoint {
        .init(p1: lhs.p1 - rhs.v1, p: lhs.p - rhs.v)
    }
}
