//
//  Created by Kurlovich Vitali on 8/3/26.
//

struct GTag: SVGMutableElement {
    static var name: String {
        "g"
    }

    var attributes: [String: String] = [:]
    var childs: [any SVGElement] = []

    init(attributes: [String: String] = [:], childs: [any SVGElement] = []) {
        self.attributes = attributes
        self.childs = childs
    }
}
