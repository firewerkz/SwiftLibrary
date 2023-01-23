//
//  MapView.swift
//  Landlord2
//
//  Created by Dick Johnson on 18/08/2020.
//  Copyright © 2020 Dick Johnson. All rights reserved.
//

import SwiftUI
import MapKit

#if os(macOS)
#else
public struct MapView: UIViewRepresentable {
    var title: String
    var coordinate: CLLocationCoordinate2D

    public init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }

    public func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    public func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.addAnnotation(Checkpoint(title: title, coordinate: coordinate))
        uiView.showsUserLocation = true
        uiView.setRegion(region, animated: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(title: "Test", coordinate: CLLocationCoordinate2D(latitude: 50.6047859, longitude: -2.4686725))
    }
}

final class Checkpoint: NSObject, MKAnnotation {
  let title: String?
  let coordinate: CLLocationCoordinate2D

  init(title: String?, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.coordinate = coordinate
  }
}
#endif
