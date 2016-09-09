//
//  ApiHelper.swift
//  GitHubUsers
//
//  Created by Brain Agency on 09.09.16.
//  Copyright © 2016 Ivan Balychev. All rights reserved.
//
import Alamofire
import AlamofireObjectMapper
import Foundation

class ApiHelper {

    private let users_path = "users"
    private let followers_path = "followers"
    private let api_path = "https://api.github.com/"

    private let per_page_key = "per_page"
    private let since_key = "since"

    static let shared = ApiHelper()

    func getUsers(followerUser user:GUser?, count_per_page per_page:Int, since:Int?, completion:(users:[GUser]) -> (), error:(error:NSError) -> ()){

        var params = [per_page_key:per_page]
        params[since_key] = since == nil ? nil : since!

        let query_path = api_path +  users_path + (user == nil ? "" : "/" + user!.login! + "/" + followers_path)

        print(query_path)

        Alamofire.request(.GET, query_path, parameters: params).responseArray { (response:Response<[GUser], NSError>) in

            if let response_error = response.result.error {
                error(error: response_error)
            } else {
                completion(users: response.result.value == nil ? [] : response.result.value!)
            }

        }


    }

}