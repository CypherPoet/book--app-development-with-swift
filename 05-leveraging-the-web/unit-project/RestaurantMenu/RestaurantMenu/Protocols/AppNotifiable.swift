//
//  AppNotifiable.swift
//  RestaurantMenu
//
//  Created by Brian Sipple on 5/25/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

protocol AppNotifiable {
    var defaultNotificationCenter: NotificationCenter { get }
}


extension AppNotifiable {
    var defaultNotificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
}
