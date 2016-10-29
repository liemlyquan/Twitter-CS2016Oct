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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegate()
        initUI()
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
        })
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
        
    }
    
    func favoriteButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell) {
        
    }
    
    func replyButtonDidTapped(_ tweetTableViewCell: TweetTableViewCell) {
        
    }
}
