//
//  Created by Kurlovich Vitali on 8/5/26.
//

import struct Foundation.Data

extension Data {
    func formatted() -> String {
        "[\(map { String($0, radix: 16) }.joined(separator: ","))]"
    }
}
