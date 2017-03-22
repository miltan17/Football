
import Foundation

typealias serviceResponse = (NSArray , NSError?) -> Void

class RestAPIManager: NSObject {
    static let sharedInstance = RestAPIManager()
    
    let leagueURL = "http://api.football-data.org/v1/competitions/?season=2016"
    
    func getLeagues(onCompletion: @escaping (NSArray) -> Void){
        makeHTTPGetRequest(path: leagueURL, onCompletion: { json , error -> Void in
            onCompletion(json)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping serviceResponse){
        let request = URLRequest(url: NSURL(string: path) as! URL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            //let json: JSONSerialization = JSONSerialization() //JSONSerialization(data : dataa)
            onCompletion(json as! NSArray ,error as NSError?)
        })
        task.resume()
    }
}
