import UIKit
import Alamofire

protocol HTTPClientProtocol {
    func getRequest(url:String, params:Dictionary<String, Any>?, retryCount:Int, enableCaching:Bool, cachingTime:TimeInterval , requestId : HTTPRequestID, completion:@escaping (_ httpResponseData:HTTPAPIResponse)->Void)
    
    func postRequest(url:String, params:Dictionary<String, Any>?, retryCount:Int, requestId : HTTPRequestID , completion:@escaping (_ httpResponseData:HTTPAPIResponse)->Void)
    
    func getHTTPAPIResponseObject(response : DataResponse<Data>) -> HTTPAPIResponse
}

class HTTPClient: HTTPClientProtocol {
    static let shared:HTTPClient = HTTPClient()
    private var sessionManager : Alamofire.SessionManager?
    
    func getRequest(url:String, params:Dictionary<String, Any>?, retryCount:Int = 0, enableCaching:Bool = false, cachingTime:TimeInterval = 0, requestId : HTTPRequestID = .UnKnown, completion:@escaping (_ httpResponseData:HTTPAPIResponse)->Void) {
        
    }
    
    func postRequest(url:String, params:Dictionary<String, Any>?, retryCount:Int = 0, requestId : HTTPRequestID = .UnKnown, completion:@escaping (_ httpResponseData:HTTPAPIResponse)->Void) {
        
        let bodyParam = BaseUrl.getBodyParameter(params:params )
        let reqHeader = BaseUrl.getHeaders(requestId: requestId)
        print("Request Started : \(requestId.name)")
        print("Request Header : \(String(describing: reqHeader))")
        print("Request URL : \(String(describing: url))")
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: bodyParam as Any, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                print("Request JSON - ", jsonString as String)
            }
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        
        
        createSession(requestedCachePolicy:.reloadIgnoringCacheData)
        if let request = sessionManager?.request(url, method: .post, parameters: bodyParam, encoding:JSONEncoding.default, headers: reqHeader) {
            request.responseData {
                response in
                let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                print("Response Received for service - \(requestId.name) : \n \(String(describing: responseString))")
                print("API success")
                let httpResponseData : HTTPAPIResponse = self.getHTTPAPIResponseObject(response:response)
                completion(httpResponseData)
            }
        }
    }
    
    //MARK: Private Methods
    func  createSession(requestedCachePolicy:NSURLRequest.CachePolicy) {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = requestedCachePolicy
        configuration.timeoutIntervalForRequest = TimeInterval(KlerioConstant.DEFAULT_CONNECT_TIMEOUT_MS)
        configuration.timeoutIntervalForResource = TimeInterval(KlerioConstant.DEFAULT_READ_TIMEOUT_MS)
        sessionManager =  Alamofire.SessionManager(configuration: configuration)
    }
    
    
    func getHTTPAPIResponseObject(response : DataResponse<Data>) -> HTTPAPIResponse {
        var httpResponseData : HTTPAPIResponse
        if response.result.isSuccess{
            let httpStatus = HTTPAPIStatus(statusCode: (response.response?.statusCode)!, isSucess: response.result.isSuccess, description: response.result.error?.localizedDescription)
            httpResponseData = HTTPAPIResponse(responseData: response.data, status: httpStatus)
        }else{
            if let error = response.result.error {
                let httpStatus = HTTPAPIStatus(statusCode: error._code, isSucess: response.result.isSuccess, description: error.localizedDescription)
                httpResponseData = HTTPAPIResponse(responseData: response.data, status: httpStatus)
            }else {
                let httpStatus = HTTPAPIStatus(statusCode: 0, isSucess: false, description: "Unknown error")
                httpResponseData = HTTPAPIResponse(responseData: response.data, status: httpStatus)
            }
        }
        return httpResponseData
    }
}

