public enum PointInPolygonError: Error {
    case decodeError
    case prepareError
    case queryError
    case unknown
}

public enum LoadFeatureError: Error {
    case decodeError
    case prepareError
    case queryError
    case notFound
    case unknown
}
