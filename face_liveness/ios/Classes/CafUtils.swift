import FaceLiveness

extension FaceLivenessPlugin {
    
    struct Constants {
        static let start = "start"
        static let methodChannelName = "face_liveness"
        static let eventChannelName = "face_liveness_listener"
        static let viewControllerErrorMessage = "Error getting curren key window view controller"
        static let argumentsErrorMessage = "Critical error: unable to get argument mapping"
        static let mobileTokenErrorMessage = "Critical error: unable to get mobileToken"
        static let personIdErrorMessage = "Critical error: unable to get personID"
        static let eventCanceled = "canceled"
        static let eventConnected = "connected"
        static let eventConnecting = "connecting"
        static let eventError = "failure"
        static let eventSuccess = "success"
        static let eventValidated = "validated"
        static let eventValidating = "validating"
        static let unknownState = "unknown state error"
    }
    
    func getCafStage(stage: String) -> CAFStage {
        switch stage {
        case "PROD":
            return CAFStage.prod
        case "BETA":
            return CAFStage.beta
        default:
            return CAFStage.prod
        }
    }
    
    func getExpirationTime(time: String) -> Time {
        switch time {
        case "THIRTY_DAYS":
            return Time.thirtyDays
        case "THREE_HOURS":
            return Time.threeHours
        default:
            return Time.thirtyMin
        }
    }
    
    func getFilter(filter: String) -> Filter {
        if (filter == "NATURAL") {
            return Filter.natural
        } else {
            return Filter.lineDrawing
        }
    }
}
