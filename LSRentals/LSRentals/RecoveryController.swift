//
//  RecoveryController.swift
//  LSRentals
//

import Foundation
import UIKit

class RecoveryController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    var pwd:String = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "ERROR", message:
            "Invalid email!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertPwd(msg:String) {
        
        let alertController = UIAlertController(title: "New Password", message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        let loginAction = UIAlertAction(title: "Login with this password", style: UIAlertActionStyle.default) { UIAlertAction in
            self.performSegue(withIdentifier: "loginRecoverySegue", sender: self)
        }
        alertController.addAction(loginAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginRecoverySegue" {
            let controller = segue.destination as! LoginController
            controller.pwd = pwd;
        }
    }
    
    func isEmailValid(str:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.evaluate(with: str)
    }
    
    func recoverPass(json: Any) -> Void{
        let succeed = (json as! Dictionary<String, AnyObject>)["succeed"] as! Bool;
        if (!succeed){
            OperationQueue.main.addOperation {
                self.showAlert();
            }
            return;
        }
        let pass = (json as! Dictionary<String, AnyObject>)["password"] as! String;
        pwd = pass;
        showAlertPwd(msg: pass)
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
        if(!isEmailValid(str: email.text!)){
            showAlert()
            email.text = ""
        }else{
            view.endEditing(true)
            
            //web service & analize!
            let ws = WebServices();
            let username = email.text!;
            ws.post(peticion: WebServices.recover_url, callback: recoverPass, params: ["username" : (username)]);
            email.text = ""
        }
    
    }
}
