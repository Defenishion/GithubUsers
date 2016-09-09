//
//  GUser.swift
//  GitHubUsers
//
//  Created by Brain Agency on 09.09.16.
//  Copyright © 2016 Ivan Balychev. All rights reserved.
//
import Foundation
import ObjectMapper

class GUser:Mappable {

    var id:Int?
    var login:String?
    var profile_link:String?
    var profile_avatar_link:String?
    var followers_url:String?

    required init?(_ map: Map){

    }

    func mapping(map: Map) {

        id <- map["id"]
        login <- map["login"]
        profile_link <- map["html_url"]
        profile_avatar_link <- map["avatar_url"]
        followers_url <- map["followers_url"]
        
    }

}