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
        print("Request BodyParam : \(String(describing: bodyParam))")
        print("Request Header : \(String(describing: reqHeader))")
        print("Request URL : \(String(describing: url))")
        
        if let request = sessionManager?.request(url, method: .post, parameters: bodyParam, encoding:JSONEncoding.default, headers: reqHeader) {
            request.responseData {
                response in
                let responseString = String(data: response.data!, encoding: String.Encoding.utf8)
                print("Response Received for service - \(requestId.name) : \n \(String(describing: responseString))")
                let httpResponseData : HTTPAPIResponse = self.getHTTPAPIResponseObject(response:response)
                completion(httpResponseData)
            }
        }
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

