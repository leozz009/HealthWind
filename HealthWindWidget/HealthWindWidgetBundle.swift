//
//  HealthWindWidgetBundle.swift
//  HealthWindWidget
//
//  Created by Fatima Alonso on 11/24/24.
//

import WidgetKit
import SwiftUI

@main
struct HealthWindWidgetBundle: WidgetBundle {
    var body: some Widget {
        HealthWindWidget()
        HealthWindWidgetControl()
        HealthWindWidgetLiveActivity()
    }
}
