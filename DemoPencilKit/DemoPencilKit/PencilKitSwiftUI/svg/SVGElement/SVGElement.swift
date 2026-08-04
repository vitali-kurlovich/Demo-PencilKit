//
//  Created by Kurlovich Vitali on 8/3/26.
//

protocol SVGElement {
    static var name: String { get }

    var attributes: [String: String] { get }
    var childs: [any SVGElement] { get }
}

extension SVGElement {
    var name: String {
        Self.name
    }
}

protocol SVGMutableElement: SVGElement {
    var attributes: [String: String] { get set }
    var childs: [any SVGElement] { get set }
}

// SVGElement+
