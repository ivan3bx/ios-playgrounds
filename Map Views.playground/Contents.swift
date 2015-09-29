//: ## Map View playground
//: This document renders a few different locations at both a city level and local level
import UIKit
import MapKit
import XCPlayground

let chicago   = CLLocationCoordinate2D(latitude: 41.9249207, longitude: -87.6932398)
let boston    = CLLocationCoordinate2D(latitude: 42.3133735, longitude: -71.0571571)
let seattle   = CLLocationCoordinate2D(latitude: 47.5990121, longitude: -122.331938)
let champaign = CLLocationCoordinate2D(latitude: 40.1135327, longitude: -88.2252114)

/*:
Zoom levels
- Wraps the lat/long for distance represented in the map views
- Since we're showing square maps, values here are identical
*/
struct ZoomLevel {
    var latDistance: CLLocationDistance
    var lngDistance: CLLocationDistance
}

let cityZoom   = ZoomLevel(latDistance: 130000, lngDistance: 130000)
let streetZoom = ZoomLevel(latDistance: 1700, lngDistance: 1700)

/*:
This method creates a MKMapView instance with a fixed height/width
- Adds a simple annotation to pin the center of the map
- Creates a fairly heavyweight MKMapView (see snapshot version for differences)
*/
func mapFor(center: CLLocationCoordinate2D, zoom: ZoomLevel, label: String) -> MKMapView {
    let mapView = MKMapView(frame: CGRect(x: 1, y: 1, width: 150, height: 150))
    
    mapView.showsPointsOfInterest = false
    mapView.showsBuildings = false
    mapView.showsTraffic = false
    mapView.showsUserLocation = false
    mapView.showsScale = false
    mapView.showsCompass = false
    
    let viewRegion = MKCoordinateRegionMakeWithDistance(center, zoom.latDistance, zoom.lngDistance)
    let adjustedRegion = mapView.regionThatFits(viewRegion)
    
    // Hides the 'legal' attribution. hmm..
    mapView.region = adjustedRegion
    mapView.subviews[1].hidden = true
    
    // Adds a title to the top of the rendered view
    addTitle(label, toView: mapView)
    
    mapView.addAnnotation(CenterAnnotation(center: center))

    return mapView
}

/*:
This method creates an MKMapSnapshot (static image for better performance)
- The UIImageView returned will be filled in asynchronously
- Snapshot views do not contain annotations; would need to be drawn programmatically
*/
func snapshotFor(center: CLLocationCoordinate2D, zoom: ZoomLevel, label: String) -> UIImageView {
    let region  = MKCoordinateRegionMakeWithDistance(center, zoom.latDistance, zoom.lngDistance)
    let options = MKMapSnapshotOptions()
    options.region = region
    options.scale = UIScreen.mainScreen().scale
    options.size  = CGSize(width: 150, height: 150)
    
    let snapshotter = MKMapSnapshotter(options: options)
    let imageView: UIImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 1, y: 1), size: options.size))
    
    addTitle(label, toView: imageView)
    
    snapshotter.startWithCompletionHandler { (snapshot:MKMapSnapshot?, error:NSError?) -> Void in
        let image = snapshot!.image
        
        // Annotate the center
        let pin = MKPinAnnotationView(annotation: CenterAnnotation(center: center), reuseIdentifier: "")

        UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
        image.drawAtPoint(CGPoint(x: 0, y: 0))
        
        var point = snapshot!.pointForCoordinate(center)

        if CGRectContainsPoint(imageView.bounds, point) {
            let pinCenterOffset = pin.centerOffset
            point.x -= pin.bounds.size.width / 2.0
            point.y -= pin.bounds.size.height / 2.0
            point.x += pinCenterOffset.x
            point.y += pinCenterOffset.y
        
            pin.image!.drawAtPoint(point)
        }
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Set the final rendered image inside the imageView container
        imageView.image = finalImage
    }
    
    return imageView
}

//: Annotation

class CenterAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(center:CLLocationCoordinate2D) {
        coordinate = center
    }
}

func addTitle(label:String, toView view:UIView) {
    let cityDescription = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 14))
    cityDescription.font = UIFont.systemFontOfSize(10)
    cityDescription.text = label
    cityDescription.textColor = UIColor.blueColor()
    cityDescription.backgroundColor = UIColor.whiteColor()
    
    view.addSubview(cityDescription)
}

//: We lay out a few different map views here & send the results to the timeline

var mapViews = [
    snapshotFor(chicago, zoom: cityZoom,   label: "Chicago City"),
    snapshotFor(chicago, zoom: streetZoom, label: "Chicago Local"),

    mapFor(boston,       zoom: cityZoom,   label: "Boston City"),
    mapFor(boston,       zoom: streetZoom, label: "Boston Local"),

    mapFor(champaign,    zoom: cityZoom,   label: "Champaign City"),
    mapFor(champaign,    zoom: streetZoom, label: "Champaign Local")
]

let view = UIView(frame: CGRect(x: 0, y: 0, width: 152, height: (mapViews.count * 150) + mapViews.count))

var currentItem = 0
for item in mapViews {
    item.frame.origin.y = CGFloat(currentItem * 151)
    currentItem += 1
    view.addSubview(item)
}

XCPShowView("Maps", view: view)

