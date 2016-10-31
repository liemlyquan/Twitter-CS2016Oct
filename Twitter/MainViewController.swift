//
//  MainViewController.swift
//  Twitter
//
//  Created by Liem Ly Quan on 10/26/16.
//  Copyright © 2016 liemlyquan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tweetList:[Tweet] = []
    let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegate()
        initUI()
        refreshControl.addTarget(self, action: #selector(initData), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        initData()
    }
    
    func initDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func initUI(){
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
    }
    
    func initData(){
        TwitterClient.sharedInstance?.getTimeline(completion: { (tweetList, error) in
            guard let tweetList = tweetList else {
                return
            }
            self.tweetList = tweetList
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetailSegue" {
            guard
                let vc = segue.destination as? TweetDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
            else {
                return
            }
            vc.tweetData = tweetList[indexPath.row]
        } else if segue.identifier == "newTweetSegue" {
            guard
                let nvc = segue.destination as? UINavigationController,
                let vc = nvc.topViewController as? NewTweetViewController
            else {
                return
            }
            vc.delegate = self
            vc.userData = User.currentUser
        }
    }
    
    @IBAction func onLogoutButtonTapped(_ sender: UIBarButtonItem){
        User.currentUser = nil
        TwitterClient.sharedInstance?.requestSerializer.removeAccessToken()
        UserDefaults.standard.removeObject(forKey: "accessToken")
        let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        cell.tweetData = tweetList[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension MainViewController: TweetTableViewCellDelegate {
    func retweetButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell) {
        guard
            let indexPath = tableView.indexPath(for: tweetTableViewCell),
            let id = tweetList[indexPath.row].id,
            let retweeted = tweetList[indexPath.row].retweeted
        else {
            return
        }
        if retweeted{
            let tweet = tweetList[indexPath.row]
            // This line of code is actually super dangerous, as long as Twitter change API, it crash
            // TODO: change later
            unretweet(id: tweetList[indexPath.row].currentUserRetweet!["id"] as! Int, indexPath: indexPath)
        } else {
            retweet(id: id, indexPath: indexPath)
        }
    }
    
    func retweet(id: Int, indexPath: IndexPath){
        TwitterClient.sharedInstance?.retweetWithCompletion(
            id: id,
            completion: { (tweet, error) in
                guard let _ = tweet else {
                    return
                }
                self.tweetList[indexPath.row].retweeted = true
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        )
    }
    
    func unretweet(id: Int, indexPath: IndexPath){
        TwitterClient.sharedInstance?.removeTweetWithCompletion(
            id: id,
            completion: { (tweet, error) in
                guard let _ = tweet else {
                    return
                }
                self.tweetList[indexPath.row].retweeted = false
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        )
    }
    
    func favoriteButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell) {
        guard
            let indexPath = tableView.indexPath(for: tweetTableViewCell),
            let id = tweetList[indexPath.row].id,
            let favorited = tweetList[indexPath.row].favorited
        else {
            return
        }
        if favorited {
            unfavorite(id: id, indexPath: indexPath)
        } else {
            favorite(id: id, indexPath: indexPath)
        }
    }
    
    func favorite(id: Int, indexPath: IndexPath){
        TwitterClient.sharedInstance?.favoriteWithCompletion(
            id: id,
            completion: { (tweet, error) in
                guard let _ = tweet else {
                    return
                }
                self.tweetList[indexPath.row].favorited = true
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        )
    }
    
    func unfavorite(id: Int, indexPath: IndexPath){
        TwitterClient.sharedInstance?.unfavoriteWithCompletion(
            id: id,
            completion: { (tweet, error) in
                guard let _ = tweet else {
                    return
                }
                self.tweetList[indexPath.row].favorited = false
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        )
    }
    
    func replyButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell) {
//      Uncomment later
//        guard
//            let indexPath = tableView.indexPath(for: tweetTableViewCell),
//            let id = tweetList[indexPath.row].id else {
//                return
//        }
        self.performSegue(withIdentifier: "newTweetSegue", sender: self)
    }
}

extension MainViewController: NewTweeViewControllerDelegate {
    func tweetButtonDidTap(newTweetViewController: NewTweetViewController, tweet: Tweet) {
        tweetList.insert(tweet,at: 0)
        tableView.reloadData()
    }
}
