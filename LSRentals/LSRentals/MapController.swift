//
//  MapController.swift
//  LSRentals
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var name_a:String = ""
    
    override func viewDidLoad() {
        let l = CLLocation(latitude: 41.390205, longitude: 2.154007)
        centerMapOnLocation(location: l)
        
        let aparts = UserDefaults.standard.value(forKey: "apartments") as! NSArray
        var ans = [MKAnnotation]()
        for apart in aparts {
            let a = apart as! Dictionary<String, Any>
            let l = a["location"] as? Dictionary<String, Any>
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: l!["latitud"] as! CLLocationDegrees, longitude: l!["longitud"] as! CLLocationDegrees)
            annotation.title = a["name"] as? String
            ans.append(annotation)
        }
        mapView.delegate = self
        mapView.addAnnotations(ans)
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
    
    func showAlert(location_name:String) {
        
        let alertController = UIAlertController(title: location_name, message:
            "See more details?", preferredStyle: UIAlertControllerStyle.alert)
        let loginAction = UIAlertAction(title: "Details", style: UIAlertActionStyle.default) { UIAlertAction in
            self.performSegue(withIdentifier: "segueDetails", sender: self)
        }
        alertController.addAction(loginAction)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        name_a = ((view.annotation?.title)!)!
        showAlert(location_name: name_a)
    }
    
    func searchApart(name: String) -> Dictionary<String, Any>? {
        var aparts = UserDefaults.standard.value(forKey: "apartments") as! NSArray
        for apart in aparts {
            let a = apart as! Dictionary<String, Any>
            let na = a["name"] as! String
            if name == na {
                return a
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetails" {
            let a = searchApart(name: name_a)
            print(name_a, "\n---------------\n", a)
            let controller = segue.destination as! DetailsController
            controller.apartment = a
        }
    }
    
    let regionRadius: CLLocationDistance = 10000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
