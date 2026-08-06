//
//  Created by Kurlovich Vitali on 8/4/26.
//

public struct SmoothPoint: Sendable, Hashable {
    public var p2: Point
    public var p: Point

    @inlinable
    public init(p2: Point, p: Point) {
        self.p2 = p2
        self.p = p
    }
}

public struct SmoothVector: Sendable, Hashable {
    public var v2: Vector
    public var v: Vector

    @inlinable
    public init(v2: Vector, v: Vector) {
        self.v2 = v2
        self.v = v
    }
}

public extension SmoothPoint {
    @inlinable
    static func + (lhs: SmoothPoint, rhs: SmoothVector) -> SmoothPoint {
        SmoothPoint(p2: lhs.p2 + rhs.v2, p: lhs.p + rhs.v)
    }

    @inlinable
    static func - (lhs: SmoothPoint, rhs: SmoothVector) -> SmoothPoint {
        SmoothPoint(p2: lhs.p2 - rhs.v2, p: lhs.p - rhs.v)
    }
}
