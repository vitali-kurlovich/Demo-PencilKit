//
//  Created by Kurlovich Vitali on 8/3/26.
//

import struct Foundation.CharacterSet
import Playgrounds
import RegexBuilder

struct PathTag: SVGMutableElement {
    static var name: String {
        "path"
    }

    var attributes: [String: String] = [:]
    var childs: [any SVGElement] = []

    init(attributes: [String: String] = [:], childs: [any SVGElement] = []) {
        self.attributes = attributes
        self.childs = childs
    }
}

extension PathTag {
    var d: String {
        attributes["d"] ?? ""
    }
}

extension PathTag {
    // var commands
}

// shape

// "d"

#Playground {
    // CharacterSet.decimalDigits.contains(" ")

    // CharacterSet.decimalDigits.contains(".")

    let path = "M515.407,664.054C515.407,664.054 540.165,703.406 545.357,736.59C545.81,739.483 549.257,741.587 551.64,743.298C668.35,827.097 607.643,909.142 549.619,921.383C548.362,921.649 551.275,924.105 551.5,924.748C570.028,977.699 565.945,1022.39 510.753,1092.296C509.794,1093.51 518.365,1093.39 522.186,1093.296C598.364,1091.417 634.342,1148.179 621.49,1160.583C583.398,1197.346 421.637,1172.122 395.917,1171.444C391.27,1171.321 382.09,1184.56 382.09,1184.56C293.53,1210.98 180.247,1197.978 132.466,1164.17C88.97,1133.395 88.935,987.098 91.115,987.91C94.54,885.042 172.81,752.09 243.59,662.09C253.511,649.475 265.42,634.727 274.22,619.96C274.35,619.74 274.276,619.953 274.276,619.953C274.276,619.953 306.823,507.07 413.933,518.906C531.192,531.863 515.407,664.054 515.407,664.054Z"

    var iterator = PathCommandIterator(path)

    var command = iterator.next()

    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
    command = iterator.next()
}
