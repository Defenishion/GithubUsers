//
//  GUserTableViewCell.swift
//  GitHubUsers
//
//  Created by Brain Agency on 09.09.16.
//  Copyright © 2016 Ivan Balychev. All rights reserved.
//
import UIKit
import SDWebImage

class GUserTableViewCell: UITableViewCell {

    @IBOutlet weak var login_label:UILabel!
    @IBOutlet weak var profile_link_button:UIButton!
    @IBOutlet weak var profile_avatar_view:UIImageView!

    private let placeholder_image = UIImage(named: "avatar_placeholder")

    override func prepareForReuse() {

        super.prepareForReuse()

        self.profile_avatar_view.image = placeholder_image

    }

    var user:GUser? {

        didSet {
            
            self.login_label.text = user?.login
            self.profile_link_button.setTitle(user?.profile_link, forState: .Normal)

            self.accessoryType = user?.followers_url == nil ? .None : .DisclosureIndicator

            if let profile_link = user?.profile_avatar_link {

                if let profile_url = NSURL(string: profile_link) {

                    self.profile_avatar_view.sd_setImageWithURL(profile_url, placeholderImage: placeholder_image)

                }

            }

        }

    }

    @IBAction func open_profile_action(sender:AnyObject) {

        guard let profile_url = self.user?.profile_link else {
            return
        }

        if let open_url = NSURL(string: profile_url){
            UIApplication.sharedApplication().openURL(open_url)
        }

    }

}