//
//  Product.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import Foundation

struct PromotedProducts: Codable {
    
    let title: String
    
    let products: [Product]
}

struct Product: Codable {
    
    let id: Int
    
    let title: String
    
    let description: String
    
    let price: Int
    
    let texture: String
    
    let wash: String
    
    let place: String
    
    let note: String
    
    let story: String
    
    let colors: [Color]
    
    let sizes: [String]
    
    let variants: [Variant]
    
    let mainImage: String
    
    let images: [String]
    
    var size: String {
        
        return (sizes.first ?? "") + " - " + (sizes.last ?? "")
    }
    
    var stock: Int {
        
        return variants.reduce(0, { (previousData, upcomingData) -> Int in
            
            return previousData + upcomingData.stock
        })
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case title
        case description
        case price
        case texture
        case wash
        case place
        case note
        case story
        case colors
        case sizes
        case variants
        case mainImage = "main_image"
        case images
    }
    
    static func convert(lsProduct: LSProduct) -> Product? {
        
        guard let title = lsProduct.title,
            let description = lsProduct.detail,
            let texture = lsProduct.texture,
            let wash = lsProduct.wash,
            let place = lsProduct.place,
            let note = lsProduct.note,
            let story = lsProduct.story,
            let colors = lsProduct.colors?.allObjects as? [LSColor],
            let sizes = lsProduct.sizes,
            let variants = lsProduct.variants?.allObjects as? [LSVariant],
            let mainImage = lsProduct.mainImage,
            let images = lsProduct.images else {
                return nil
        }
        
        let product = Product(
            id: Int(lsProduct.id),
            title: title,
            description: description,
            price: Int(lsProduct.price),
            texture: texture,
            wash: wash,
            place: place,
            note: note,
            story: story,
            colors: colors.map {
                Color.convert(lsColor: $0)
            }.compactMap { $0 },
            sizes: sizes,
            variants: variants.map {
                Variant.convert(lsVariant: $0)
            }.compactMap { $0 },
            mainImage: mainImage,
            images: images)
        
        return product
    }
}

struct Color: Codable {
    
    let name: String
    
    let code: String
    
    static func convert(lsColor: LSColor) -> Color? {
        
        guard let name = lsColor.name,
            let code = lsColor.code else { return nil }
        
        let color = Color(name: name, code: code)
        
        return color
    }
}

struct Variant: Codable {
    
    let colorCode: String
    
    let size: String
    
    let stock: Int
    
    enum CodingKeys: String, CodingKey {
        
        case colorCode = "color_code"
        case size
        case stock
    }
    
    static func convert(lsVariant: LSVariant) -> Variant? {
        
        guard let colorCode = lsVariant.colorCode,
            let size = lsVariant.size else { return nil }
        
        let variant = Variant(
            colorCode: colorCode,
            size: size,
            stock: Int(lsVariant.stocks)
        )
        
        return variant
    }
}
