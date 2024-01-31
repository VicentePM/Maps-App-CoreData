//
//  MapController.swift
//  tarea-mapa-01
//
//  Created by dam2 on 25/1/24.
//

import UIKit
import MapKit
import CoreData

class MapController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    /* Initial location */
    let initialLocation = CLLocation(latitude: 38.092711, longitude: -3.634971)
    
    /* Main region radius */
    let initialLocationDistance: CLLocationDistance = 35000
    
    /* Location Manager */
    var locationManager: CLLocationManager?
    
    /* Core data Annotations */
    var locationsInCoreData = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeInitialConfig()
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            centerMapOnLocation(location: initialLocation, locationDistance: 3000)
            showOnlyLinares()
        } else {
            centerMapOnLocation(location: initialLocation, locationDistance: initialLocationDistance)
            reloadAnnotations()
        }
    }
    
    @IBAction func createCustomAnnotation(_ sender: Any) {
        createAlertForCustomAnnotation()
    }
    
    /* Initial configuration */
    func makeInitialConfig() {
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        centerMapOnLocation(location: initialLocation, locationDistance: initialLocationDistance)
        getCoreDataLocations()
        if(locationsInCoreData.isEmpty) {
            initialSave()
        }
        reloadAnnotations()
    }
    
    /* Center Map on Location */
    func centerMapOnLocation(location: CLLocation, locationDistance: CLLocationDistance) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: locationDistance, longitudinalMeters: locationDistance)
        mapView.setRegion(region, animated: true)
    }
    
    /* Remove annotations outside Linares */
    func showOnlyLinares() {
        mapView.removeAnnotations(mapView.annotations)
        
        for location in locationsInCoreData {
            let annotation = ArtWork(title: location.value(forKeyPath: "title") as! String, discipline: location.value(forKeyPath: "discipline") as! String, coordinate: CLLocationCoordinate2D(latitude: location.value(forKeyPath: "latitude") as! CLLocationDegrees, longitude: location.value(forKeyPath: "longitude") as! CLLocationDegrees), isInLinares: location.value(forKeyPath: "isInLinares") as! Bool)
            if annotation.isInLinares {
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    /* Add custom annotation */
    func createAlertForCustomAnnotation() {
        let alertController = UIAlertController(title: "Añadir", message: "Añadir anotacion", preferredStyle: .alert)
        
        let aceptarInLinaresAction: UIAlertAction = UIAlertAction(title: "Crear en linares", style: .default, handler: { [self] (action) -> Void in
            
            guard let textFields = alertController.textFields else { return }
            
            if let nombre = textFields[0].text, let latitud = CLLocationDegrees(textFields[1].text ?? ""), let longitud = CLLocationDegrees(textFields[2].text ?? "") {
                let location = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                save(locationToSave: ArtWork(title: nombre, discipline: "", coordinate: location, isInLinares: true))
                reloadAnnotations()
            }
            
        })
        
        let aceptarOutLinares: UIAlertAction = UIAlertAction(title: "Crear fuera de linares", style: .default, handler: { [self] (action) -> Void in
            
            guard let textFields = alertController.textFields else { return }
            
            if let nombre = textFields[0].text, let latitud = CLLocationDegrees(textFields[1].text ?? ""), let longitud = CLLocationDegrees(textFields[2].text ?? "") {
                let location = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                save(locationToSave: ArtWork(title: nombre, discipline: "", coordinate: location, isInLinares: false))
                reloadAnnotations()
            }
            
        })
        
        let cancelarAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alertController.addAction(aceptarInLinaresAction)
        alertController.addAction(aceptarOutLinares)
        alertController.addAction(cancelarAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Nombre"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Latitud"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Longitud"
        }
        
        self.present(alertController, animated: true)
    }
    
    /* Create Annotation with Mobile Location */
    @IBAction func createMobileLocationAnnotation(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Añadir", message: "Añadir anotacion", preferredStyle: .alert)
        
        let aceptarAction: UIAlertAction = UIAlertAction(title: "Crear anotacion con tu ubicacion", style: .default, handler: { [self] (action) -> Void in
            
            guard let textFields = alertController.textFields else { return }
            
            if let nombre = textFields[0].text {
                
                let location: CLLocationCoordinate2D = (locationManager?.location!.coordinate)!
                save(locationToSave: ArtWork(title: nombre, discipline: "", coordinate: location, isInLinares: true))
                reloadAnnotations()
            }
            
        })
        
        
        let cancelarAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alertController.addAction(aceptarAction)
        alertController.addAction(cancelarAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Nombre"
        }
        
        self.present(alertController, animated: true)
        
    }
    
}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? ArtWork else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            
            dequeuedView.annotation = annotation
            view = dequeuedView
            view.displayPriority = .required
         
            if !annotation.isInLinares { view.markerTintColor = .yellow }
            
        } else {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.displayPriority = .required
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if !annotation.isInLinares { view.markerTintColor = .yellow }
            
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation as! ArtWork
        let lOptWalk = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let lOptDrive = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        if location.title == "Escuela Estech" {
            if let url = URL(string: "https://www.escuelaestech.es") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
        
        if location.isInLinares {
            location.mapItem().openInMaps(launchOptions: lOptDrive)
        } else {
            location.mapItem().openInMaps(launchOptions: lOptWalk)
        }
    }
    
}

extension MapController: CLLocationManagerDelegate {
    
    /* Request Locations Functions */
    func requestLocation() {
        locationManager?.requestLocation()
    }
    
    func requestLocationUpdate() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        locationManager?.stopUpdatingLocation()
    }
    
    /* Permission of location */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("El usuario aun no se ha decidido")
            locationManager?.requestAlwaysAuthorization()
        case .restricted:
            print("Restringido por control parental")
        case .denied:
            print("El usuario ha rechazado el permiso")
            locationManager?.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            print("EL usuario ha permitido usar la ubicacion mientras se usa la app")
            self.requestLocationUpdate()
        case .authorizedAlways:
            print("El usuario ha permitido usar la ubicacion siempre")
            self.requestLocationUpdate()
        default:
            print("El usuario ha restringido la ubicacion")
        }
    }
    
    /* Get location Accurazy */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locations = locations.last else { return }
        
        if(locations.horizontalAccuracy < 10) {
            self.stopLocationUpdate()
        }
    }
    
    /* Error getting location */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Se ha producido un error: \(error.localizedDescription)")
    }
    
}

/* Core data functions */

extension MapController {
    
    /* Get data from Core Data */
    
    func getCoreDataLocations() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        do {
            locationsInCoreData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No se ha podido ejecutar fetch \(error) \(error.userInfo)")
        }
    }
    
    /* Save Data in Core Data */
    
    func save(locationToSave: ArtWork) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
        let location = NSManagedObject(entity: entity, insertInto: managedContext)
        location.setValue(locationToSave.title, forKeyPath: "title")
        location.setValue(locationToSave.subtitle, forKeyPath: "subtitle")
        location.setValue(locationToSave.discipline, forKeyPath: "discipline")
        location.setValue(locationToSave.coordinate.latitude, forKeyPath: "latitude")
        location.setValue(locationToSave.coordinate.longitude, forKeyPath: "longitude")
        location.setValue(locationToSave.isInLinares, forKeyPath: "isInLinares")
        
        do {
            try managedContext.save()
            locationsInCoreData.append(location)
        } catch let error as NSError {
            print("No se ha podido guardar: \(error), \(error.userInfo)")
        }
    }
    
    /* Save al initial annotations */
    
    func initialSave() {
        save(locationToSave: ArtWork(title: "El posito", discipline: "Centro de información turística", coordinate: CLLocationCoordinate2D(latitude: 38.092711, longitude: -3.634971), isInLinares: true))
        save(locationToSave: ArtWork(title: "Escuela Estech", discipline: "Centro de estudios", coordinate: CLLocationCoordinate2D(latitude: 38.0941944, longitude: -3.6338287), isInLinares: true))
        save(locationToSave: ArtWork(title: "Catedral de baeza", discipline: "Catedral", coordinate: CLLocationCoordinate2D(latitude: 37.9900947, longitude: -3.4713304), isInLinares: false))
    }
    
    /* Reload annotations in the map */
    
    func reloadAnnotations() {
        getCoreDataLocations()
        mapView.removeAnnotations(mapView.annotations)
        for location in locationsInCoreData {
            let annotation = ArtWork(title: location.value(forKeyPath: "title") as! String, discipline: location.value(forKeyPath: "discipline") as! String, coordinate: CLLocationCoordinate2D(latitude: location.value(forKeyPath: "latitude") as! CLLocationDegrees, longitude: location.value(forKeyPath: "longitude") as! CLLocationDegrees), isInLinares: location.value(forKeyPath: "isInLinares") as! Bool)
            mapView.addAnnotation(annotation)
        }
    }
    
}
