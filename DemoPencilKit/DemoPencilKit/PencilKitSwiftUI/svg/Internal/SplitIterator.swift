//
//  Created by Kurlovich Vitali on 8/3/26.
//

struct SplitIterator<S: StringProtocol>: IteratorProtocol {
    typealias Element = S.SubSequence

    let string: S

    let separator: Character
    var startIndex: S.Index

    init(
        string: S,
        separator: Character,
    ) {
        self.string = string
        self.separator = separator
        startIndex = string.startIndex
    }

    mutating func next() -> S.SubSequence? {
        guard startIndex != string.endIndex else {
            return nil
        }

        let endIndex = string[startIndex ..< string.endIndex].firstIndex(
            of: separator,
        )

        if let endIndex {
            defer {
                self.startIndex = self.string.index(after: endIndex)
            }

            return string[startIndex ..< endIndex]
        }

        defer {
            self.startIndex = self.string.endIndex
        }

        return string[startIndex ..< string.endIndex]
    }
}
