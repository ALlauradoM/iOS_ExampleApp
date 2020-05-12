//
//  BookController.swift
//  LSRentals
//

import UIKit

class BookController: UIViewController {

    var apartment:Dictionary<String, Any>? = nil
    var customer:Dictionary<String, Any>? = Dictionary()
    
    @IBOutlet weak var apartName: UILabel!
    @IBOutlet weak var apartAddress: UILabel!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var startDateText: UITextField!
    @IBOutlet weak var endDateText: UITextField!
    @IBOutlet weak var numPeopleText: UITextField!
    
    override func viewDidLoad() {
        apartName.text = apartment?["name"] as? String
        let l = apartment?["location"] as? Dictionary<String, Any>
        apartAddress.text = l?["address"] as? String
        
        //print(apartment)
    }
    
    func book(json: Any) -> Void{
        let succeed = (json as! Dictionary<String, AnyObject>)["succeed"] as! Bool;
        if succeed {
            OperationQueue.main.addOperation {
                self.showAlertOK()
            }
        } else {
            OperationQueue.main.addOperation {
                self.showAlertKO()
            }
        }
    }
    
    func showAlertKO() {
        let alertController = UIAlertController(title: "ERROR", message:
            "Invalid fields!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertOK() {
        let alertController = UIAlertController(title: "Appartment Booked", message:
            "Thank you!", preferredStyle: UIAlertControllerStyle.alert)
        let loginAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { UIAlertAction in
            OperationQueue.main.addOperation {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(loginAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bookBtnAction(_ sender: Any) {
        
        customer?["name"] = nameText.text
        //print("v: \(customer?["start_date"]), t:\(nameText.text)")
        customer?["start_date"] = startDateText.text
        customer?["end_date"] = endDateText.text
        var np:Int
        if numPeopleText.text == "" {
            np = 0
        } else {
            np = (Int(numPeopleText.text!)!)
        }
        customer?["number_of_people"] = np
        
        let str = customer?["name"] as! String
        let nameOk = (str != "")
        
        let dateRegex = "[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])"
        let datePredicate = NSPredicate(format:"SELF MATCHES %@", dateRegex)
        
        let startDateOk = datePredicate.evaluate(with: customer?["start_date"])
        //print("StartDateOk: \(startDateOk)")
        let endDateOk = datePredicate.evaluate(with: customer?["end_date"])
        //print("EndDateOk: \(endDateOk)")
        
        let mc = apartment?["maximum_capacity"] as! Int
        
        let capacityOk:Bool = ((np <= mc) && np > 0)
        //print(capacityOk)
        
        var cDateOk:Bool = false
        if (startDateOk && endDateOk) {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            let sD = dateformatter.date(from: customer?["start_date"] as! String)!
            let eD = dateformatter.date(from: customer?["end_date"] as! String)!
            cDateOk = (eD > sD)
        }
        
        if (nameOk && cDateOk && capacityOk) {
            let apart_id = self.apartment?["identifier"] as? Int
            let ws = WebServices();
            let token = UserDefaults.standard.value(forKey: "token") as! String
            //print("token: \(token)")
            OperationQueue.main.addOperation {
                ws.postAuth(peticion: WebServices.book_apart, callback: self.book(json:), params: ["apartment" : (apart_id), "customer" : (self.customer)], token: token)
            }
        } else {
            OperationQueue.main.addOperation {
                self.showAlertKO()
            }
        }
    }
}
