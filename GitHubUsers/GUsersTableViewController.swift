//
//  GUsersTableViewController.swift
//  GitHubUsers
//
//  Created by Brain Agency on 09.09.16.
//  Copyright © 2016 Ivan Balychev. All rights reserved.
//
import UIKit
import iShowcase
import SVPullToRefreshImprove

class GUsersTableViewController: UITableViewController {

    var user:GUser?

    private let per_page_count = 100

    private let cell_identifier = "user_cell"

    var users:[GUser] = []

    //MARK: - view life cycle

    override func viewDidLoad() {

        super.viewDidLoad()

        self.initialSetup()

    }

    //MARK: - view setup

    func initialSetup() {

        self.setupRefresh()
        self.setupBackground()
        self.updateTitle()
        self.startLoad()

    }

    func setupBackground() {

        self.tableView.backgroundView = {

            let label = UILabel(frame: self.tableView.frame)
            label.font = UIFont(name: "HelveticaNeue", size: 15.0)
            label.numberOfLines = 0
            label.textColor = UIColor.blackColor()
            label.textAlignment = .Center

            return label

        }()

    }

    func setupRefresh() {

        self.tableView.addInfiniteScrollingWithActionHandler { 
            self.loadData(reload: false, completion: nil)
        }

        self.tableView.addPullToRefreshWithActionHandler { 
            self.loadData(reload: true, completion: nil)
        }

    }

    func updateTitle() {

        self.title = self.user == nil ? "GitHub users" : "\(self.user!.login!) followers"

    }

    //MARK: - load data

    func startLoad() {

        AnimationLoader.shared.show()

        self.loadData(reload: true) {

            AnimationLoader.shared.hide()

        }

    }

    func loadData(reload is_reload:Bool, completion:(() -> ())?) {

        self.tableView.backgroundView?.hidden = true

        let since = is_reload ? nil : self.users.maxElement {$0.0.id < $0.1.id }?.id

        ApiHelper.shared.getUsers(followerUser:self.user, count_per_page: per_page_count, since: since, completion: { (users) in

            completion?()

            if is_reload {
                self.users.removeAll()
            }

            //check for last users
            if let first_user = users.first where self.containUser(first_user) == false {

                self.users = is_reload ? users : self.users + users
                self.tableView.reloadData()

            }

            self.tableView.pullToRefreshView.stopAnimating()
            self.tableView.infiniteScrollingView.stopAnimating()

            if self.users.count == 0 {
                self.showError("No results found", inTableView: true)
            }

            self.beginShowCase()

            }) { (error) in

                completion?()

                self.showError(error.localizedDescription, inTableView: self.users.count == 0)

                self.tableView.pullToRefreshView.stopAnimating()
                self.tableView.infiniteScrollingView.stopAnimating()

        }

    }

    //MARK: - check

    //add this function to check because if cise
    //one follower of user with id 10762 and if pass id 10762 to since then api return user with 10762
    func containUser(user:GUser) -> Bool{
        return self.users.contains{ $0.id == user.id}
    }

    //MARK: - show error alert

    func showError(error:String, inTableView:Bool) {

        self.tableView.backgroundView?.hidden = !inTableView

        if inTableView {

            if let label = self.tableView.backgroundView as? UILabel {

                label.text = error

            }

        } else {

            let alert_controller = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
            alert_controller.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
            self.presentViewController(alert_controller, animated: true, completion: nil)

        }

    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.users.count

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return tableView.dequeueReusableCellWithIdentifier(cell_identifier, forIndexPath: indexPath)

    }

    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let _cell = cell as? GUserTableViewCell {
            _cell.user = users[indexPath.row]
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let user = self.users[indexPath.row]
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("gusers_tvc") as! GUsersTableViewController
        controller.user = user
        self.navigationController?.pushViewController(controller, animated: true)

    }

    //MARK: - show case

    func beginShowCase() {

        if let path = self.tableView.indexPathsForVisibleRows?.first {

            if let cell = self.tableView.cellForRowAtIndexPath(path){

                let showcase = iShowcase()

                showcase.titleLabel.text = "Application Options"
                showcase.detailsLabel.text = "Click to show user followers"

                showcase.delegate = self
                showcase.singleShotId = 1
                showcase.type = .RECTANGLE

                showcase.setupShowcaseForView(cell)

                showcase.show()
                
            }
            
        }

    }

}

extension GUsersTableViewController:iShowcaseDelegate {

    func iShowcaseDismissed(showcase: iShowcase) {

        if let path = self.tableView.indexPathsForVisibleRows?.first {

            if let cell = self.tableView.cellForRowAtIndexPath(path) as? GUserTableViewCell{

                showcase.detailsLabel.text = "Click to open user profile"

                showcase.singleShotId = 2

                showcase.setupShowcaseForView(cell.profile_link_button)
                
                showcase.show()
                
            }
            
        }

    }

}