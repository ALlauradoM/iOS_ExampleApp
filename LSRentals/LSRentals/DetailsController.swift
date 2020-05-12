//
//  DetailsController.swift
//  LSRentals
//
import UIKit
import MapKit

class DetailsController: UIViewController {

    var apartment:Dictionary<String, Any>? = nil
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var infoText: UITextView!
    

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var map: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.isNavigationBarHidden = false
        nameLabel.text = apartment?["name"] as? String
        let l = apartment?["location"] as? Dictionary<String, Any>
        addressLabel.text = l?["address"] as? String
        let c = apartment?["maximum_capacity"] as! Int
        capacityLabel.text = "\(c)"
        infoText.text = apartment?["information"] as? String
        
        let images = apartment?["images"] as! Dictionary<String, Any>
        //print("\n---------------------\n", images["main"])
        let imageUrlString = images["main"]  as! String
        let imageUrl:URL = URL(string: imageUrlString)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        img.image = UIImage(data: imageData as Data)
        
        
        let loc = CLLocation(latitude: l!["latitud"] as! CLLocationDegrees, longitude: l!["longitud"] as! CLLocationDegrees)
        centerMapOnLocation(location: loc)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: l!["latitud"] as! CLLocationDegrees, longitude: l!["longitud"] as! CLLocationDegrees)
        map.addAnnotation(annotation)
        self.map.isZoomEnabled = false;
        self.map.isScrollEnabled = false;
        self.map.isUserInteractionEnabled = false;
    }
    
    @IBAction func bookBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segueBook", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBook" {
            let controller = segue.destination as! BookController
            controller.apartment = apartment
        }
    }
    
}
