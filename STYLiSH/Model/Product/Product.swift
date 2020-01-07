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
    
    static func convert(scProduct: SCProduct) -> Product? {
        
        guard let title = scProduct.title,
            let description = scProduct.detail,
            let texture = scProduct.texture,
            let wash = scProduct.wash,
            let place = scProduct.place,
            let note = scProduct.note,
            let story = scProduct.story,
            let colors = scProduct.colors?.allObjects as? [SCColor],
            let sizes = scProduct.sizes,
            let variants = scProduct.variants?.allObjects as? [SCVariant],
            let mainImage = scProduct.mainImage,
            let images = scProduct.images else {
                return nil
        }
        
        let product = Product(
            id: Int(scProduct.id),
            title: title,
            description: description,
            price: Int(scProduct.price),
            texture: texture,
            wash: wash,
            place: place,
            note: note,
            story: story,
            colors: colors.map {
                Color.convert(scColor: $0)
            }.compactMap { $0 },
            sizes: sizes,
            variants: variants.map {
                Variant.convert(scVariant: $0)
            }.compactMap { $0 },
            mainImage: mainImage,
            images: images)
        
        return product
    }
}

struct Color: Codable {
    
    let name: String
    
    let code: String
    
    static func convert(scColor: SCColor) -> Color? {
        
        guard let name = scColor.name,
            let code = scColor.code else { return nil }
        
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
    
    static func convert(scVariant: SCVariant) -> Variant? {
        
        guard let colorCode = scVariant.colorCode,
            let size = scVariant.size else { return nil }
        
        let variant = Variant(
            colorCode: colorCode,
            size: size,
            stock: Int(scVariant.stocks)
        )
        
        return variant
    }
}
