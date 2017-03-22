

import Foundation


struct ConstantUrl {
    
    struct FootballURL {
        static let competitionsUrl = "http://api.football-data.org/v1/competitions/?season="
    }
    
    struct FootballResponseKey {
        static let Status = "stat"
        static let Caption = "caption"
    }
    
    struct FootballResponseValue {
        static let okStatus = "ok"
    }
}
