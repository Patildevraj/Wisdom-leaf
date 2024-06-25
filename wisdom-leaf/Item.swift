//
//  Item.swift
//  wisdom-leaf
//
//  Created by Kibbcom on 25/06/24.
//

import Foundation

struct Item: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
    var isChecked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case download_url
    }
}

