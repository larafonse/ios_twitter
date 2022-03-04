//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Nicolas Lara on 3/1/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRefreshControl.addTarget(self, action:#selector(loadTweet), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
    }

    override func viewDidAppear(_ animated:Bool){
        super.viewDidAppear(animated)
        loadTweet()
    }
    
    @objc func loadTweet(){
        numberOfTweet = 20
        let URL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count":numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: URL, parameters: params, success: { (tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print("Could not retrieve tweet")
        })
    }
    
    
    func loadMoreTweet(){
        let URL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20
        let params = ["count":numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: URL, parameters: params, success: { (tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { Error in
            print("Could not retrieve tweet")
        })

    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row + 1 == tweetArray.count {
                loadMoreTweet()
            }
        }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion:nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetcell", for: indexPath) as! TweetCellTableViewCell
        
        let user =  tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as! String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as! String
        
        let imgUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        
        let data = try? Data(contentsOf: imgUrl!)
        
        if let imgData = data {
            cell.profileImageView.image = UIImage(data:imgData)
        }
        
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
