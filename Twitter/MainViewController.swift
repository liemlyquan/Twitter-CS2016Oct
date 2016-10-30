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
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            vc.userData = User.currentUser
        }
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
            let id = tweetList[indexPath.row].id else {
            return
        }
        TwitterClient.sharedInstance?.retweetWithCompletion(
            id: id,
            completion: { (tweet, error) in
                guard let _ = tweet else {
                    return
                }
                tweetTableViewCell.activateRetweet()
            }
        )
    }
    
    func favoriteButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell) {
        guard
            let indexPath = tableView.indexPath(for: tweetTableViewCell),
            let id = tweetList[indexPath.row].id else {
                return
        }
        TwitterClient.sharedInstance?.favoriteWithCompletion(
            id: id,
            completion: { (tweet, error) in
                guard let _ = tweet else {
                    return
                }
                tweetTableViewCell.activateStar()
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
