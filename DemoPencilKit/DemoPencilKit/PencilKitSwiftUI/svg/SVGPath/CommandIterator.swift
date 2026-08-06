//
//  Created by Kurlovich Vitali on 8/6/26.
//

import struct Foundation.CharacterSet

struct CommandIterator<S: StringProtocol>: IteratorProtocol {
    var scanner: StringScanner<S>

    init(_ string: S) {
        scanner = StringScanner(string)
    }

    mutating func next() -> PathElement? {
        _ = scanner.skip(in: .whitespacesNewlinesAndCommma)

        guard let char = scanner.nextChar() else {
            return nil
        }

        guard let command = Command(rawValue: char) else {
            return nil
        }

        return PathElement(
            command: command,
            arguments: argsuments(for: command),
        )
    }

    mutating func argsuments(for command: Command) -> [Double] {
        if command == .z || command == .Z {
            return []
        }

        var argsuments: [Double] = []

        let count = command.argsCount

        while true {
            argsuments.reserveCapacity(count)

            _ = scanner.skip(in: .whitespacesNewlinesAndCommma)

            let string = scanner.skip(in: .decimalDigitsAndFractionSeparator)

            if string.isEmpty {
                break
            }

            argsuments.append(Double(string)!)
        }

        return argsuments
    }
}

extension CommandIterator {
    struct PathElement: Equatable, Sendable {
        let command: Command
        let arguments: [Double]
    }

    enum Command: Character {
        case M = "M"
        case m = "m"

        case L = "L"
        case l = "l"

        case H = "H"
        case h = "h"

        case v = "v"
        case V = "V"

        case C = "C"
        case c = "c"

        case S = "S"
        case s = "s"

        case Q = "Q"
        case q = "q"

        case T = "T"
        case t = "t"

        case A = "A"
        case a = "a"

        case Z = "Z"
        case z = "z"

        var argsCount: Int {
            switch self {
            case .Z, .z:
                0
            case .H, .h, .V, .v:
                1
            case .M, .m, .L, .l, .T, .t:
                2
            case .S, .s, .Q, .q:
                4
            case .C, .c:
                6
            case .A, .a:
                7
            }
        }
    }
}

private extension CharacterSet {
    static let decimalDigitsAndFractionSeparator = CharacterSet.decimalDigits.union(
        CharacterSet(charactersIn: "-."),
    )

    static let whitespacesNewlinesAndCommma = CharacterSet.whitespacesAndNewlines.union(
        CharacterSet(charactersIn: ","),
    )

    static let svgCommands = CharacterSet(charactersIn: "MmLlHhVvCcSsQqTtAaZz")
}

// import SwiftUI
//
// #Preview {
//    Path(path: """
//
//    M 10,10 h 10
//           m  0,10 h 10
//           m  0,10 h 10
//           M 40,20 h 10
//           m  0,10 h 10
//           m  0,10 h 10
//           m  0,10 h 10
//           M 50,50 h 10
//           m-20,10 h 10
//           m-20,10 h 10
//           m-20,10 h 10 z
//    """)
//    .stroke(style: StrokeStyle(lineWidth: 1))
// }
