//
//  TabController.swift
//  LSRentals
//

import UIKit

class ListController: UITableViewController, UISearchResultsUpdating {
    
    var aparts:NSArray = []
    var f_aparts:NSArray = []
    let searchController = UISearchController(searchResultsController: nil)
    var swOn = false
    var selected:Dictionary<String, Any>? = nil
    var mc = 0
    
    override func viewDidLoad() {
        
        aparts = UserDefaults.standard.value(forKey: "apartments") as! NSArray
        f_aparts = aparts
        
        //let a = aparts[0] as! Dictionary<String, Any>
        //print(a)
        //print("\n-----\n", a["maximum_capacity"] as! Int, \n-----\n")
        
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "How many people?"
        tableView.tableHeaderView = searchController.searchBar
        tableView.sectionHeaderHeight = 40
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
    
    func btnLogout(sender: UIBarButtonItem) {
        clearFile()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        //self.navigationController?.isNavigationBarHidden = true
        let logoutBtn = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(btnLogout(sender:))
        )
        self.tabBarController?.navigationItem.rightBarButtonItem = logoutBtn
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        let numsRegex = "[0-9]+"
        let numsPredicate = NSPredicate(format:"SELF MATCHES %@", numsRegex)
        let numsOk = numsPredicate.evaluate(with: searchText) as! Bool
        
        if !searchText.isEmpty && numsOk {
            mc = Int(searchText)!
            //let resultPredicate = NSPredicate(format: "maximum_capacity > %@", 10)
            let predString = "maximum_capacity >= \(mc)"
            let resultPredicate = NSPredicate(format: predString)
            f_aparts = f_aparts.filtered(using: resultPredicate) as NSArray
        } else {
            mc = 0
            f_aparts = aparts
            if swOn {
                let predString = "available == 1"
                let resultPredicate = NSPredicate(format: predString)
                f_aparts = f_aparts.filtered(using: resultPredicate) as NSArray
            }
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return f_aparts.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "               Available"
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.sizeToFit()
        view.addSubview(label)
        
        let switchControl=UISwitch()
        if swOn {
            switchControl.isOn = true
        }
        switchControl.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        view.addSubview(switchControl)
        
        return view
    }
    
    func switchChanged(sender:UISwitch!){
        if sender.isOn {
            swOn = true
            let predString = "available == 1"
            let resultPredicate = NSPredicate(format: predString)
            f_aparts = f_aparts.filtered(using: resultPredicate) as NSArray
        } else{
            swOn = false
            f_aparts = aparts
        }
        let predString = "maximum_capacity >= \(mc)"
        let resultPredicate = NSPredicate(format: predString)
        f_aparts = f_aparts.filtered(using: resultPredicate) as NSArray
        tableView.reloadData()
    }
    
    //*** Pintem la cell: ***
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        
        let a = f_aparts[indexPath.row] as! Dictionary<String, Any>
        cell.textLabel!.text = a["name"] as? String
        //print("Index: ", indexPath.row, "\n------------\n", a["name"] ?? "ERROR")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = f_aparts[indexPath.row] as! Dictionary<String, Any>
        self.performSegue(withIdentifier: "segueDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetails" {
            let controller = segue.destination as! DetailsController
            controller.apartment = selected
        }
    }
}
