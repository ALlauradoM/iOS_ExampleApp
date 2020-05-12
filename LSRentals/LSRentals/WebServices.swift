//
//  WebServices.swift
//  LSRentals
//

import Foundation

//https://grokswift.com/simple-rest-with-swift/

struct WebServices {
    public static let login_url = "https://www.v2msoft.com/clientes/lasalle/ios-17-18/login.php"
    public static let recover_url = "https://www.v2msoft.com/clientes/lasalle/ios-17-18/remember_password.php"
    public static let list_aparts = "https://www.v2msoft.com/clientes/lasalle/ios-17-18/apartments.php"
    public static let book_apart = "https://www.v2msoft.com/clientes/lasalle/ios-17-18/book.php"
    
    func get (peticion: String, callback: @escaping (Any)->Void, token:String)/* ->  Any*/{
        //var urlRequest = URLRequest(url: URL(string: peticion)!);
        
        /*
        let token = singleton.token;
        */
        
        let urlString: String = "\(peticion)"
        
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        
        
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("*** Error calling GET on /todos/1")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("*** Error: did not receive data")
                return
            }
            
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("*** Error trying to convert data to JSON")
                        return
                }
                
                callback(todo);
                //return todo
            } catch  {
                print("*** Error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func post (peticion: String, callback: @escaping (Any)->Void, params: [String: Any]) {
        
        print(params)
        
        guard let todosURL = URL(string: peticion) else {
            print("*** Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: params, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("*** Error: cannot create JSON from todo")
            return
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("*** Error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("*** Error: did not receive data")
                return
            }
            
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
            
                callback(receivedTodo)
            } catch  {
                print("*** Error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }
    
    func postAuth (peticion: String, callback: @escaping (Any)->Void, params: [String: Any], token:String) {
        
        //print(params)

        guard let todosURL = URL(string: peticion) else {
            print("*** Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: params, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("*** Error: cannot create JSON from todo")
            return
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("*** Error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("*** Error: did not receive data")
                return
            }
            
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                
                callback(receivedTodo)
            } catch  {
                print("*** Error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }
}






