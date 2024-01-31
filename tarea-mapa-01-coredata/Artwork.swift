//
//  ArtWork.swift
//  tarea-mapa-01
//
//  Created by dam2 on 25/1/24.
//

import MapKit
import Contacts

class ArtWork: NSObject, MKAnnotation {
    
    var latitud: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitud, longitude: longitude)
        }
        set {
            latitud = newValue.latitude
            longitude = newValue.longitude
        }
    }
    let title: String?
    let discipline: String
    let isInLinares: Bool
    
    var subtitle: String? {
        return discipline
    }
    
    init(title: String, discipline: String, coordinate: CLLocationCoordinate2D, isInLinares: Bool) {
//        self.coordinate = coordinate
        self.latitud = coordinate.latitude
        self.longitude = coordinate.longitude
        self.title = title
        self.discipline = discipline
        self.isInLinares = isInLinares
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = title
        
        return mapItem
    }
    
}
