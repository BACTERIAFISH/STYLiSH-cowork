//
//  FilterManagerDelegate.swift
//  STYLiSH
//
//  Created by Hueijyun  on 2020/1/6.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import Foundation
import UIKit

struct Menu: Decodable {
    var data: [Product1]
}

struct Product1: Decodable {
    var title: String
    var id: Int
    var category: String
    var description: String
    var price: Int
    var texture: String
    var wash: String
    var place: String
    var note: String
    var story: String
    var colors: [Colors]
    var sizes: [String]
    var variants: [Variants]
    var mainImage: String
    var images: [String]
    
    enum CodingKeys: String, CodingKey {
        case mainImage = "main_image"
        case title,id,category,description,price,texture,wash,place,note,story,colors,sizes,variants,images
    }
}

struct Colors: Decodable {
    var code: String
    var name: String
}

struct Variants: Decodable {
    var colorCode: String
    var size: String
    var stock: Int
    
    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size, stock
    }
}

