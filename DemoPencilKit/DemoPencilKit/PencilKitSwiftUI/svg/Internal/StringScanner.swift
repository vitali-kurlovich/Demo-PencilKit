//
//  Created by Kurlovich Vitali on 8/6/26.
//

import struct Foundation.CharacterSet

struct StringScanner<S: StringProtocol> {
    let string: S

    private(set) var startIndex: S.Index

    private(set) var isFinish: Bool

    @inlinable
    init(
        _ string: S,
    ) {
        self.string = string
        startIndex = string.startIndex
        isFinish = string.isEmpty
    }
}

extension StringScanner {
    @inlinable
    var isEnd: Bool {
        startIndex == endIndex
    }

    @inlinable
    var endIndex: S.Index {
        string.endIndex
    }

    private var currentChar: Character {
        string[startIndex]
    }
}

extension StringScanner {
    @inlinable
    mutating func skip(in set: CharacterSet) -> S.SubSequence {
        let begin = startIndex

        while true {
            if isFinish {
                break
            }

            let unicodeScalar = currentChar.unicodeScalars.first!

            if set.contains(unicodeScalar) {
                if isEnd == false {
                    startIndex = string.index(after: startIndex)
                }

                isFinish = isEnd

            } else {
                break
            }
        }

        return string[begin ..< startIndex]
    }

    @inlinable
    mutating func nextChar() -> Character? {
        if isFinish {
            return nil
        }

        defer {
            if isEnd == false {
                startIndex = string.index(after: startIndex)
            }

            isFinish = isEnd
        }

        return currentChar
    }
}
