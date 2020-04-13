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
 
  
      
