# Cheeta
Cheeta is very simple and lightweight networking library. 

## Installation

    dependencies: [
    .package(url: "https://github.com/mahabaleshwarhnr/Cheeta.git", .exact(from: "1.0.1"))
    ]

## Documentation

  1. Register your API base URL in `AppDelegate` . You can change base URL based on test or debug or production configuration.
       
         func application(_ application: UIApplication, didFinishLaunchingWithOptions 
                          launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {                      
            let baseURL = URL(string: "https://itunes.apple.com/")!
            APIConfig.config.register(baseURL: baseURL)
            return true
         }
     Note: Your base URL should always ends with path(/)

  2. Configure API Manager
     You can directly use APIManager static instance `APIManager.shared`. It uses default session configuration.
     
     You can also pass your own session to initialize the APIManager
     
         let apiManager  = APIManager(session: .init(configuration: .default, delegate: nil, delegateQueue: .main))`

  3. Create your request
     
         let query = ["term": searchTerm, "limit": "50"]
         let apiRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, payload: nil, queryParams: query)
       endPoint argumnent should conforms to APIEndPoint protocol. By default `String` is conformed to APIEndPoint Protocol.
         You can also create a request following way
         
          let apiRequest = APIRequest(endPoint: "search", method: .get, payload: nil, queryParams: query)
       
       You can also write your own APIRequest Implementation. 
     
   4. Execute Request
   
          apiManager.sendRequest(request: apiRequest, responseType: MusicSearchResultContainer.self) { (response) in
            switch response {
            case .success(let result):
                print(result)
            case .failure(let error as NSError):
                print("failed: \(error.userInfo)")
            }
          }
 ### API Mock
 If you are wrting test cases you may have to mock your API responses.
    
   1. Download [MockURLProcol.swift](https://gist.github.com/mahabaleshwarhnr/c427b9ab1fd38f8abe81f37397cf22e8) and it your test target.
   2. Create a URLSession object with MockURLProcol URLSessionConfiguration.
        
         Basic setup
         
          let mockConfig = URLSessionConfiguration.default
          mockConfig.protocolClasses = [URLProtocol.self]
          let mockSession = URLSession(configuration: mockConfig, delegate: nil, delegateQueue: .main)
          let apiManager = APIManager(session: mockSession)
        
         Test related data
        
          let apiRequest = APIRequest(endPoint: "search", method: .get, payload: nil, queryParams: nil)
          let responseData = Data([0, 1, 0, 1])
          let httpResponse = HTTPURLResponse(url: apiRequest.getURL(), statusCode: 200, httpVersion: "2.0", headerFields: nil)
          let jsonManager = JSONManager(data: responseData, response: httpResponse, error: nil)
          
         Pass your mock response completionhandler and assert your tests
         
           MockURLProtocol.mockResponseHandler = { request in
            let successResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (httpResponse, responseData)
           }
          
        
        
  
      
