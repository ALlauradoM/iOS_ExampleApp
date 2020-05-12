//
//  ViewController.swift
//  LSRentals
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var usrField: UITextField!
    var pwd:String = ""
    @IBOutlet weak var pwdField: UITextField!
    
    var access:Bool = false
    
    var username:String = ""
    var pass:String = ""
    
    override func viewDidLoad() {
        //clearFile()
        super.viewDidLoad()
        let savedData = readFile()
        //print(savedData)
        if savedData != nil && savedData != "" && savedData != "\n" {
            access = true
            var lines: [String] = []
            savedData?.enumerateLines { line, _ in
                lines.append(line)
            }
            let ws = WebServices()
            username = lines[0]
            pass = lines[1]
            //print("LOGIN -> u: \(username), p: \(pass)")
            saveInFile()
            
            ws.post(peticion: WebServices.login_url, callback: login, params: ["username" : (username), "password" : (pass)]);
        } else {
            access = false
        }
        pwdField.text = pwd;
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "ERROR", message:
            "Invalid email or password!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func clearFile() {
        
        let file = "login.txt" //this is the file. we will write to and read from it
        let text = "" //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                print("ERROR Writing in file!")
            }
        }
    }
    
    func fillList(json: Any) -> Void {
        let data = json  as! Dictionary<String, AnyObject>
        let aparts = data["apartments"] as! NSArray
        UserDefaults.standard.set(aparts, forKey: "apartments")
        //print("*** Login! -> Fill List: ", aparts.count)
        OperationQueue.main.addOperation {
            if self.access {
                self.performSegue(withIdentifier: "segueAccess", sender: self)
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
        
    }
    
    func readFile() -> String? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let file = "login.txt" //this is the file. we will write to and read from it
            let fileURL = dir.appendingPathComponent(file)
            //reading
            do {
                let text = try String(contentsOf: fileURL, encoding: .utf8)
                return text
            }
            catch {
                print("ERROR Reading file!")
            }
        }
        return nil
    }
    
    func saveInFile() {
        
        let file = "login.txt" //this is the file. we will write to and read from it
        let text = "\(username)\n\(pass)\n" //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                print("ERROR Writing in file!")
            }
        }
    }
    
    func login(json: Any) -> Void{
        let succeed = (json as! Dictionary<String, AnyObject>)["succeed"] as! Bool;
        if (!succeed){
            //let err = (json as! Dictionary<String, AnyObject>)["error"] as! String;
            //print("error: ", err)
            OperationQueue.main.addOperation {
                self.showAlert();
            }
        } else {
            var t = (json as! Dictionary<String, AnyObject>)["token"] as! String;
            //print("token: \(t)")
            
            saveInFile()
            
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(pass, forKey: "password")
            UserDefaults.standard.set(t, forKey: "token")
            let ws = WebServices();
            OperationQueue.main.addOperation {
                ws.get(peticion: WebServices.list_aparts, callback: self.fillList, token: t);
            }
            /*OperationQueue.main.addOperation {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }*/
        }
        //let pass = (json as! Dictionary<String, AnyObject>)["password"] as! String;
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        let ws = WebServices();
        username = usrField.text!;
        pass = pwdField.text!
        
        ws.post(peticion: WebServices.login_url, callback: login, params: ["username" : (username), "password" : (pass)]);
    }
    
    
}

