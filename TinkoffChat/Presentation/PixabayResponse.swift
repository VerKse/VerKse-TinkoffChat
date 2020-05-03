//
//  PixabayResponse.swift
//  TinkoffChat
//
//  Created by Vera on 19.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

struct PixabayResponse: Codable {
    let hits: [Question]
    let totalHits: Int
}
