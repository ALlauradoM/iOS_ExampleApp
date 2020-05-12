//
//  File.swift
//  LSRentals
//
import UIKit

class AccessController: UIViewController {
    
    var token:String = ""
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        //let str = readFile()
        //print(str)
        
        let u = UserDefaults.standard.value(forKey: "username")
        let p = UserDefaults.standard.value(forKey: "password")
        //print("ACCESS -> u: \(u), p: \(p)")
        token = UserDefaults.standard.value(forKey: "token") as! String
        //print(token)
        //print("***********")
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
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        clearFile()
        self.navigationController?.popViewController(animated: true)
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
    
}
