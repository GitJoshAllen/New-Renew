//
//  MapViewController.swift
//  RenewBiomass
//
//  Created by Jason Carothers on 2/11/15.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView:MKMapView!
    
    var farmer:String?
    var entity:String?
    var location:String?
    var acres:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if error != nil {
                println(error)
                return
            }
            
            if placemarks != nil && placemarks.count > 0 {
                let placemark = placemarks[0] as! CLPlacemark
                
                // Add Annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.farmer
                annotation.subtitle = self.entity
                annotation.coordinate = placemark.location.coordinate
                
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
                
            }
            
        })
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        
//        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
//        leftIconView.image = UIImage(data: restaurant.image)
//        annotationView.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
