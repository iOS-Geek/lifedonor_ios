//
//  RequestManager.swift
//  LifeDonor
//
//  Created by iOS Developer on 05/08/16.
//  Copyright © 2016 Prabh Kiran Kaur. All rights reserved.
//

import UIKit
let BaseUrl = "http://lifedonor.in/api/"


class RequestManager: NSObject {
    typealias RequestManagerHandler = (responseDict:NSDictionary) ->Void
    class func getFromServer(api: String, parameters: [NSObject : AnyObject], completionHandler:RequestManagerHandler) {
        let defaultConfigObject = NSURLSessionConfiguration.defaultSessionConfiguration()
        let defaultSession = NSURLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let url = NSURL(string: "\(BaseUrl)\(api)")!

        var paramterString: String = ""
        
        for object in parameters.keys {
            paramterString = paramterString.stringByAppendingString(object as! String).stringByAppendingString("=").stringByAppendingString((parameters[object] as! String)).stringByAppendingString("&")
        }
      paramterString = (paramterString as NSString).substringToIndex(paramterString.characters.count - 1)
      let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "POST"
        urlRequest.HTTPBody = paramterString.dataUsingEncoding(NSUTF8StringEncoding)
        let dataTask = defaultSession.dataTaskWithRequest(urlRequest, completionHandler: {(data, response, error) in
            
            if error == nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
                    
                    do {
                        let responseDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                        dispatch_async(dispatch_get_main_queue(), {() -> Void in
                            
                            completionHandler(responseDict: responseDict)
                            
                        })
                        
                    } catch {
                        print("json error: \(error)")
                    }
                    
                    })
            }
            else {
                
                print("Connection Error : \(error?.description)")
                let dict = ["error" : "1"]
                completionHandler(responseDict: dict)
            }
            
        })
        
        // do whatever you need with the task e.g. run
        dataTask.resume()
        
    }
}

//typealias CompletionHandler = (success:Bool) -> Void
//
//func downloadFileFromURL(url: NSURL,completionHandler: CompletionHandler) {
//    
//    // download code.
//    
//    let flag = true // true if download succeed,false otherwise
//    
//    completionHandler(success: flag)
//}

// How to use it.
//
//downloadFileFromURL(NSURL(string: "url_str")!, { (success) -> Void in
//    
//    // When download completes,control flow goes here.
//    if success {
//        // download success
//    } else {
//        // download fail
//    }
//})

//They are called type properties and type methods and you use the class or static keywords.
//class Foo {
//    var name: String?           // instance property
//    static var all = [Foo]()    // static type property
//    class var comp: Int {       // computed type property
//        return 42
//    }
//    
//    class func alert() {        // type method
//        print("There are \(all.count) foos")
//    }
//}
//
//Foo.alert()       // There are 0 foos
//let f = Foo()
//Foo.all.append(f)
//Foo.alert()       // There are 1 foos