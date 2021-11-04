@objc(AMapViewManager)
class AMapViewManager: RCTViewManager {
  override class func requiresMainQueueSetup() -> Bool { false }

  override func view() -> UIView {
    let view = MapView()
    view.delegate = view
    return view
  }

  @objc func moveCamera(_ reactTag: NSNumber, position: NSDictionary, duration: Int) {
    getView(reactTag: reactTag) { view in
      view.moveCamera(position: position, duration: duration)
    }
  }

  func getView(reactTag: NSNumber, callback: @escaping (MapView) -> Void) {
    bridge.uiManager.addUIBlock { _, viewRegistry in
      callback(viewRegistry![reactTag] as! MapView)
    }
  }
}

class MapView: MAMapView, MAMapViewDelegate {
  var initialized = false
  var overlayMap: [MABaseOverlay: Overlay] = [:]
  var markerMap: [MAPointAnnotation: Marker] = [:]

  @objc var onLoad: RCTDirectEventBlock = { _ in }
  @objc var onCameraMove: RCTDirectEventBlock = { _ in }
  @objc var onCameraIdle: RCTDirectEventBlock = { _ in }
  @objc var onPress: RCTDirectEventBlock = { _ in }
  @objc var onPressPoi: RCTDirectEventBlock = { _ in }
  @objc var onLongPress: RCTDirectEventBlock = { _ in }
  @objc var onLocation: RCTDirectEventBlock = { _ in }

  @objc func setMyLocationEnabled(_ enabled: Bool) {
    showsUserLocation = enabled
  }

  @objc func setBuildingsEnabled(_ enabled: Bool) {
    isShowsBuildings = enabled
  }

  @objc func setTrafficEnabled(_ enabled: Bool) {
    isShowTraffic = enabled
  }

  @objc func setIndoorViewEnabled(_ enabled: Bool) {
    isShowsIndoorMap = enabled
  }

  @objc func setCompassEnabled(_ enabled: Bool) {
    showsCompass = enabled
  }

  @objc func setScaleControlsEnabled(_ enabled: Bool) {
    showsScale = enabled
  }

  @objc func setScrollGesturesEnabled(_ enabled: Bool) {
    isScrollEnabled = enabled
  }

  @objc func setZoomGesturesEnabled(_ enabled: Bool) {
    isZoomEnabled = enabled
  }

  @objc func setRotateGesturesEnabled(_ enabled: Bool) {
    isRotateEnabled = enabled
  }

  @objc func setTiltGesturesEnabled(_ enabled: Bool) {
    isRotateCameraEnabled = enabled
  }

  @objc func setMinZoom(_ value: Double) {
    minZoomLevel = value
  }

  @objc func setMaxZoom(_ value: Double) {
    maxZoomLevel = value
  }

  @objc func setInitialCameraPosition(_ json: NSDictionary) {
    if !initialized {
      initialized = true
      moveCamera(position: json)
    }
  }

  func moveCamera(position: NSDictionary, duration: Int = 0) {
    let status = MAMapStatus()
    if let it = position["zoom"] as? Double { status.zoomLevel = CGFloat(it) }
    if let it = position["tilt"] as? Double { status.cameraDegree = CGFloat(it) }
    if let it = position["bearing"] as? Double { status.rotationDegree = CGFloat(it) }
    if let it = position["target"] as? NSDictionary { status.centerCoordinate = it.coordinate }
    setMapStatus(status, animated: true, duration: Double(duration) / 1000)
  }

  override func didAddSubview(_ subview: UIView) {
    if let overlay = (subview as? Overlay)?.getOverlay() {
      overlayMap[overlay] = subview as? Overlay
      add(overlay)
    }
    if let annotation = (subview as? Marker)?.annotation {
      markerMap[annotation] = subview as? Marker
      addAnnotation(annotation)
    }
  }

  override func removeReactSubview(_ subview: UIView!) {
    if let overlay = (subview as? Overlay)?.getOverlay() {
      overlayMap.removeValue(forKey: overlay)
      remove(overlay)
    }
    if let annotation = (subview as? Marker)?.annotation {
      markerMap.removeValue(forKey: annotation)
      removeAnnotation(annotation)
    }
  }

  func mapView(_: MAMapView, rendererFor overlay: MAOverlay) -> MAOverlayRenderer? {
    if let key = overlay as? MABaseOverlay {
      return overlayMap[key]?.getRenderer()
    }
    return nil
  }

  func mapView(_: MAMapView!, viewFor annotation: MAAnnotation) -> MAAnnotationView? {
    if let key = annotation as? MAPointAnnotation {
      return markerMap[key]?.getView()
    }
    return nil
  }

  func mapView(_: MAMapView!, annotationView view: MAAnnotationView!, didChange newState: MAAnnotationViewDragState, fromOldState _: MAAnnotationViewDragState) {
    if let key = view.annotation as? MAPointAnnotation {
      let market = markerMap[key]!
      if newState == MAAnnotationViewDragState.starting {
        market.onDragStart(nil)
      }
      if newState == MAAnnotationViewDragState.dragging {
        market.onDrag(nil)
      }
      if newState == MAAnnotationViewDragState.ending {
        market.onDragEnd(view.annotation.coordinate.json)
      }
    }
  }

  func mapView(_: MAMapView!, didAnnotationViewTapped view: MAAnnotationView!) {
    if let key = view.annotation as? MAPointAnnotation {
      markerMap[key]?.onPress(nil)
    }
  }

  func mapInitComplete(_: MAMapView!) {
    onLoad(nil)
  }

  func mapView(_: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
    onPress(coordinate.json)
  }

  func mapView(_: MAMapView!, didTouchPois pois: [Any]!) {
    let poi = pois[0] as! MATouchPoi
    onPressPoi(["name": poi.name!, "id": poi.uid!, "position": poi.coordinate.json])
  }

  func mapView(_: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
    onLongPress(coordinate.json)
  }

  func mapViewRegionChanged(_: MAMapView!) {
    onCameraMove([
      "cameraPosition": [
        "target": centerCoordinate.json,
        "zoom": zoomLevel,
        "bearing": rotationDegree,
        "tilt": cameraDegree,
      ],
    ])
  }

  func mapView(_: MAMapView!, regionDidChangeAnimated _: Bool) {
    onCameraIdle([
      "cameraPosition": [
        "target": centerCoordinate.json,
        "zoom": zoomLevel,
        "bearing": rotationDegree,
        "tilt": cameraDegree,
      ],
    ])
  }

  func mapView(_: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation _: Bool) {
    onLocation([
      "coords": [
        "latitude": userLocation.coordinate.latitude,
        "longitude": userLocation.coordinate.longitude,
        "altitude": userLocation.location?.altitude ?? 0,
        "heading": userLocation.heading?.trueHeading,
        "accuracy": userLocation.location?.horizontalAccuracy ?? 0,
        "speed": userLocation.location?.speed ?? 0,
      ],
      "timestamp": NSDate().timeIntervalSince1970 * 1000,
    ])
  }
}
