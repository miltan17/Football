
import Foundation

typealias serviceArrayResponse = (NSArray , NSError?) -> Void
typealias serviceDictionaryResponse = ([String: AnyObject] , NSError?) -> Void


class RestAPIManager: NSObject {
    static let sharedInstance = RestAPIManager()
    
    let leagueURL = "http://api.football-data.org/v1/competitions/?season=2016"
    let fixtureURL = "http://api.football-data.org/v1/fixtures/"
    var leagueTableAddress: String = ""
    
    func setLeagueTableAddress(address: String){
        leagueTableAddress = address
    }
    
    
    func getLeaguesInfo(onCompletion: @escaping (NSArray) -> Void){
        makeHTTPGetRequestForArray(path: leagueURL, onCompletion: { json , error -> Void in
            onCompletion(json)
        })
    }
    
    func getLeaguesPointTableInfo(onCompletion: @escaping ([String: AnyObject]) -> Void){
        makeHTTPGetRequestForDictionary(path: leagueTableAddress, onCompletion: { json , error -> Void in
            onCompletion(json)
        })
    }
    
    func getFixtureInfo(onCompletion: @escaping ([String: AnyObject]) -> Void){
        makeHTTPGetRequestForDictionary(path: fixtureURL, onCompletion: { json , error -> Void in
            onCompletion(json)
        })
    }
    
    func makeHTTPGetRequestForArray(path: String, onCompletion: @escaping serviceArrayResponse){
        var request = URLRequest(url: NSURL(string: path) as! URL)
        request.addValue("cfb4022f9677439db603161f03e9bb0e", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            //let json: JSONSerialization = JSONSerialization() //JSONSerialization(data : dataa)
            onCompletion(json as! NSArray ,error as NSError?)
        })
        task.resume()
    }
    
    func makeHTTPGetRequestForDictionary(path: String, onCompletion: @escaping serviceDictionaryResponse){
        var request = URLRequest(url: NSURL(string: path) as! URL)
        request.addValue("cfb4022f9677439db603161f03e9bb0e", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            //let json: JSONSerialization = JSONSerialization() //JSONSerialization(data : dataa)
            onCompletion(json as! [String: AnyObject] ,error as NSError?)
        })
        task.resume()
    }
}
