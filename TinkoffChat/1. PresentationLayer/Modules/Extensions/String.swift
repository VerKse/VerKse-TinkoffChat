//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Vera on 16.02.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import UIKit

func stringFromAny(_ value:Any?) -> String {
    if let nonNil = value, !(nonNil is NSNull) {
        return String(describing: nonNil)
    }
    return ""
}
