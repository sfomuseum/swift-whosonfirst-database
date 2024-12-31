enum PointInPolygonError: Error {
    case decodeError
    case prepareError
    case queryError
    case unknown
}

enum LoadFeatureError: Error {
    case decodeError
    case prepareError
    case queryError
    case notFound
    case unknown
}
