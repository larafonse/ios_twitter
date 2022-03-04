//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Nicolas Lara on 3/1/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited:Bool = false
    var tweetId:Int = -1
    var retweeted:Bool = false
    
    @IBAction func retweet(_ sender: Any) {
        
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (error) in
            print("Error in Retweet")
        })
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        
        let toBeFavorited = !favorited
        
        if (toBeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(true)
            }, failure: {(error) in
                print( "Favorite did not succed")
            })
        }
        else{
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(false)
            }, failure: {(error) in
                print( "Favorite did not succed")
            })
        }
    }
    
    func setFavorited(_ isFavorited:Bool){
        favorited = isFavorited
        
        if(favorited){
            favButton.setImage(UIImage(named :"favor-icon-red"), for: UIControl.State.normal)
        }else{
            favButton.setImage(UIImage(named :"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool){
        if (isRetweeted){
            retweetButton.setImage(UIImage(named:"retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else{
            retweetButton.setImage(UIImage(named:"retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
