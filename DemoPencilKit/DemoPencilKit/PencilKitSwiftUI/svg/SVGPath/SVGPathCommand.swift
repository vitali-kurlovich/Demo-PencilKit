//
//  Created by Kurlovich Vitali on 8/4/26.
//

public struct MoveCommand: Sendable, Hashable {
    public let points: [Point]
}

public struct MoveRelativeCommand: Sendable, Hashable {
    public let offsets: [Vector]
}

public struct LineCommand: Sendable, Hashable {
    public let points: [Point]
}

public struct LineRelativeCommand: Sendable, Hashable {
    public let offsets: [Vector]
}

public struct HorizontalLineCommand: Sendable, Hashable {
    public let points: [HorizontalPoint]
}

public struct HorizontalRelativeLineCommand: Sendable, Hashable {
    public let offsets: [HorizontalVector]
}

public struct VerticalLineCommand: Sendable, Hashable {
    public let points: [VerticalPoint]
}

public struct VerticalRelativeLineCommand: Sendable, Hashable {
    public let offsets: [VerticalVector]
}

public struct CubicCommand: Sendable, Hashable {
    public let points: [CubicPoint]
}

public struct CubicRelativeCommand: Sendable, Hashable {
    public let offsets: [CubicVector]
}

public struct SmoothCommand: Sendable, Hashable {
    public let points: [SmoothPoint]
}

public struct SmoothRelativeCommand: Sendable, Hashable {
    public let offsets: [SmoothVector]
}

public struct QuadraticCommand: Sendable, Hashable {
    public let points: [QuadraticPoint]
}

public struct QuadraticRelativeCommand: Sendable, Hashable {
    public let offsets: [QuadraticVector]
}

public struct SmoothQuadraticCommand: Sendable, Hashable {
    public let points: [Point]
}

public struct SmoothQuadraticRelativeCommand: Sendable, Hashable {
    public let offsets: [Vector]
}

public struct ClosePathCommand: Sendable, Hashable {}

public enum SVGPathCommand {
    case move(MoveCommand)
    case moveRelative(MoveRelativeCommand)

    case line(LineCommand)
    case lineRelative(LineRelativeCommand)

    case horizontal(HorizontalLineCommand)
    case horizontalRelative(HorizontalRelativeLineCommand)

    case vertical(VerticalLineCommand)
    case verticalRelative(VerticalRelativeLineCommand)

    case cubic(CubicCommand)
    case cubicRelative(CubicRelativeCommand)

    case smooth(SmoothCommand)
    case smoothRelative(SmoothRelativeCommand)

    case quadratic(QuadraticCommand)
    case quadraticRelative(QuadraticRelativeCommand)

    case smoothQuadratic(SmoothQuadraticCommand)
    case smoothQuadraticRelative(SmoothQuadraticRelativeCommand)

    // case arc()

    case closePath
}

public struct SVGPathCommands: Sequence {
    public typealias Element = SVGPathCommand
    public typealias Iterator = SVGPathCommandIterator<String>

    public let d: String

    public init(_ string: String) {
        d = string
    }

    public func makeIterator() -> Iterator {
        Iterator(d)
    }
}
