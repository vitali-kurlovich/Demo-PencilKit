//
//  Created by Kurlovich Vitali on 8/4/26.
//

public struct CubicPoint: Sendable, Hashable {
    public var p1: Point
    public var p2: Point
    public var p: Point

    @inlinable
    public init(p1: Point, p2: Point, p: Point) {
        self.p1 = p1
        self.p2 = p2
        self.p = p
    }
}

public struct CubicVector: Sendable, Hashable {
    public var v1: Vector
    public var v2: Vector
    public var v: Vector

    @inlinable
    public init(v1: Vector, v2: Vector, v: Vector) {
        self.v1 = v1
        self.v2 = v2
        self.v = v
    }
}

public extension CubicPoint {
    @inlinable
    static func + (lhs: CubicPoint, rhs: CubicVector) -> CubicPoint {
        .init(p1: lhs.p1 + rhs.v1, p2: lhs.p2 + rhs.v2, p: lhs.p + rhs.v)
    }

    @inlinable
    static func - (lhs: CubicPoint, rhs: CubicVector) -> CubicPoint {
        .init(p1: lhs.p1 - rhs.v1, p2: lhs.p2 - rhs.v2, p: lhs.p - rhs.v)
    }

    @inlinable
    static func += (left: inout CubicPoint, right: CubicVector) {
        left.p1 += right.v1
        left.p2 += right.v2
        left.p += right.v
    }

    @inlinable
    static func -= (left: inout CubicPoint, right: CubicVector) {
        left.p1 -= right.v1
        left.p2 -= right.v2
        left.p -= right.v
    }
}
