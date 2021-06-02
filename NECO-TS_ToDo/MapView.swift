import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @Binding var location: CLLocationCoordinate2D
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.addGestureRecognizer(context.coordinator.myLongPress)
        return map
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // SFC Delta coordinate 35.388465, 139.425502
        let coordinate = CLLocationCoordinate2D(latitude: 35.388465, longitude: 139.425502)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
            
        uiView.mapType = .satellite
        uiView.addAnnotation(annotation)
        uiView.setRegion(region, animated: true)

    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            
            self.myLongPress.addTarget(self, action: #selector(recognizeLongPress))
        }
        
        @objc func recognizeLongPress(sender: UILongPressGestureRecognizer) {
            if sender.state == .ended {
                if let mapView = sender.view as? MKMapView {
                    let point = sender.location(in: mapView)
                    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    mapView.addAnnotation(annotation)

                    let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    let newRegion = MKCoordinateRegion(center: coordinate, span: span)
                    
                    mapView.setRegion(newRegion, animated: true)
                }
            }
        }
    }
}
