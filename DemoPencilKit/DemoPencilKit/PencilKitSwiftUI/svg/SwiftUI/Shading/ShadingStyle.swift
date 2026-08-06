//
//  Created by Kurlovich Vitali on 8/6/26.
//

public struct ShadingStyle: Sendable {
    public var fill: FillShading?
    public var stroke: StrokeShading?

    public init(fill: FillShading? = nil, stroke: StrokeShading? = nil) {
        self.fill = fill
        self.stroke = stroke
    }
}
