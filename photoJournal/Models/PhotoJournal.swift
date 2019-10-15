//
//  PhotoJournal.swift
//  photoJournal
//
//  Created by Radharani Ribas-Valongo on 10/12/19.
//  Copyright © 2019 Radharani Ribas-Valongo. All rights reserved.
//

import Foundation

struct PhotoJournal: Codable {
    let image: Data
    let description: String
    let date: Date
}
