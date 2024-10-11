//
//  SearchResult.swift
//  MapKitApp
//
//  Created by Rafael Alejandro Rivas González on 09/10/24.
//

import SwiftUI
import MapKit
struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
