# Cheeta
Cheeta is very simple and lightweight networking library. 

## How to use?
Download network folder and replace exisiting base URL your URL in `APIRequest` class

## Example
  1. Configure API Manager
     You can directly use APIManager static instance `APIManager.shared`. It uses default session configuration.
     
     You can also pass your own session to initialize the APIManager
     
         let apiManager  = APIManager(session: .init(configuration: .default, delegate: nil, delegateQueue: .main))`

  2. Create your request
     
         let query = ["term": searchTerm, "limit": "50"]
         let apiRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, payload: nil, queryParams: query)
       endPoint argumnent should conforms to APIEndPoint protocol. By default `String` is conformed to APIEndPoint Protocol.
         You can also create a request following way
         
          let apiRequest = APIRequest(endPoint: "search", method: .get, payload: nil, queryParams: query)
         
     
   3. Execute Request
   
          apiManager.sendRequest(request: apiRequest, responseType: MusicSearchResultContainer.self) { (response) in
            switch response {
            case .success(let result):
                print(result)
            case .failure(let error as NSError):
                print("failed: \(error.userInfo)")
            }
          }
