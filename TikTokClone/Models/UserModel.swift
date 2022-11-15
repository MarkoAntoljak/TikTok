//
//  UserModel.swift
//  TikTokClone
//
//  Created by Marko Antoljak on 11/13/22.
//

import Foundation

struct UserModel: Codable {
    
    let username: String
    
    let profilePicURL: URL?
    
    let identifier: String
}
