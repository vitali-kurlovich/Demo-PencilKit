//
//  Created by Kurlovich Vitali on 8/4/26.
//

struct MoveCommand: Sendable, Hashable {
    let points: [Point]
}

struct MoveRelativeCommand: Sendable, Hashable {
    let offsets: [Vector]
}

struct LineCommand: Sendable, Hashable {
    let points: [Point]
}

struct LineRelativeCommand: Sendable, Hashable {
    let offsets: [Vector]
}

struct HorizontalLineCommand: Sendable, Hashable {
    let points: [HorizontalPoint]
}

struct HorizontalRelativeLineCommand: Sendable, Hashable {
    let offset: [HorizontalVector]
}

struct VerticalLineCommand: Sendable, Hashable {
    let points: [VerticalPoint]
}

struct VerticalRelativeLineCommand: Sendable, Hashable {
    let offset: [VerticalVector]
}

struct CubicCommand: Sendable, Hashable {
    let points: [CubicPoint]
}

struct CubicRelativeCommand: Sendable, Hashable {
    let offsets: [CubicVector]
}

struct SmoothCommand: Sendable, Hashable {
    let points: [SmoothPoint]
}

struct SmoothRelativeCommand: Sendable, Hashable {
    let offsets: [SmoothVector]
}

struct QuadraticCommand: Sendable, Hashable {
    let points: [QuadraticPoint]
}

struct QuadraticRelativeCommand: Sendable, Hashable {
    let offsets: [QuadraticVector]
}

struct SmoothQuadraticCommand: Sendable, Hashable {
    let points: [Point]
}

struct SmoothQuadraticRelativeCommand: Sendable, Hashable {
    let offsets: [Vector]
}

enum PathCommand {
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
