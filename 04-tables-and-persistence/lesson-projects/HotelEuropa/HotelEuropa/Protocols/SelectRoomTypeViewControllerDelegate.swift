//
//  SelectRoomTypeTableViewControllerDelegate.swift
//  HotelEuropa
//
//  Created by Brian Sipple on 5/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

protocol SelectRoomTypeViewControllerDelegate: UIViewController {

    func selectRoomTypeViewController(
        _ controller: SelectRoomTypeViewController,
        didSelectRoomType roomType: RoomType
    )
}

