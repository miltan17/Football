
import Foundation

typealias serviceArrayResponse = (NSArray , NSError?) -> Void
typealias serviceDictionaryResponse = (NSDictionary , NSError?) -> Void


class RestAPIManager: NSObject {
    static let sharedInstance = RestAPIManager()
    
    let leagueURL = "http://api.football-data.org/v1/competitions/?season=2016"
    var leagueTableAddress: String = ""
    
    func setLeagueTableAddress(address: String){
        leagueTableAddress = address
    }
    
    
    func getLeaguesInfo(onCompletion: @escaping (NSArray) -> Void){
        makeHTTPGetRequestForArray(path: leagueURL, onCompletion: { json , error -> Void in
            onCompletion(json)
        })
    }
    
    func getLeaguesTableInfo(onCompletion: @escaping (NSDictionary) -> Void){
        makeHTTPGetRequestForDictionary(path: leagueTableAddress, onCompletion: { json , error -> Void in
            onCompletion(json)
        })
    }
    
    
    func makeHTTPGetRequestForArray(path: String, onCompletion: @escaping serviceArrayResponse){
        let request = URLRequest(url: NSURL(string: path) as! URL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            //let json: JSONSerialization = JSONSerialization() //JSONSerialization(data : dataa)
            onCompletion(json as! NSArray ,error as NSError?)
        })
        task.resume()
    }
    
    func makeHTTPGetRequestForDictionary(path: String, onCompletion: @escaping serviceDictionaryResponse){
        let request = URLRequest(url: NSURL(string: path) as! URL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            //let json: JSONSerialization = JSONSerialization() //JSONSerialization(data : dataa)
            onCompletion(json as! NSDictionary ,error as NSError?)
        })
        task.resume()
    }
}
