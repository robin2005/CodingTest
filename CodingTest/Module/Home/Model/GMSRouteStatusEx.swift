//
//  GMSRouteStatusEx.swift
//  CodingTest
//
//  Created by jdm on 11/2/24.
//

import GoogleNavigation

extension GMSRouteStatus {
    func message() -> String {
        switch self {
        case .internalError:
            return "internal error"
        case .OK:
            return "ok"
        case .noRouteFound:
            return "the destination could not be calculated"
        case .networkError:
            return "network error"
        case .quotaExceeded:
            return "insufficient quota"
        case .apiKeyNotAuthorized:
            return "the provided key does not have permission"
        case .canceled:
            return "canceled"
        case .duplicateWaypointsError:
            return "no waypoints were provided"
        case .noWaypointsError:
            return "ok"
        case .locationUnavailable:
            return "the user hasn't granted location permissions"
        case .waypointError:
            return "invalid point"
        case .travelModeUnsupported:
            return "unsupported"
        @unknown default:
            return "unknown"
        }
    }
}
