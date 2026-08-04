//
//  Created by Kurlovich Vitali on 8/3/26.
//

struct SvgTag: SVGMutableElement {
    static var name: String {
        "svg"
    }

    var attributes: [String: String] = [:]
    var childs: [any SVGElement] = []

    init(attributes: [String: String] = [:], childs: [any SVGElement] = []) {
        self.attributes = attributes
        self.childs = childs
    }
}
