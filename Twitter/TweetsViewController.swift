//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/27/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var tweets: [Tweet] = []
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var numberOfTweets = 20

    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidAppear(animated: Bool) {
//        let nav = self.navigationController?.navigationBar
//        nav?.barStyle = UIBarStyle.BlackTranslucent
//        let twitterColor = UIColor(red: 29, green: 202, blue: 255, alpha: 1)
//        nav?.backgroundColor = UIColor.blueColor()
        //nav?.tintColor = twitterColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
        refreshControl.addTarget(self, action: #selector(loadData), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        TwitterClient.sharedInstance.homeTimeline(self.numberOfTweets, success:{ (tweets: [Tweet]) in
            self.tweets = tweets
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error: NSError) in
            print("error:\(error.localizedDescription)")
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                self.loadingMoreView?.frame = frame
                self.loadingMoreView!.startAnimating()
                self.numberOfTweets += 20
                
                // Code to load more results
                loadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logOut()
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.tweets.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = self.tweets[indexPath.row]
        
        

        
        return cell
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tweetDetails"{
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = self.tweets[(indexPath!.row)]
            let singleTweetViewController = segue.destinationViewController as! SingleTweetViewController
            singleTweetViewController.tweet = tweet
        }
        
        if segue.identifier == "userProfileSegue"{
            let cell = sender as! UIButton
            let contentView = cell.superview
            let tweetCell = contentView?.superview as! UITableViewCell
            let indexPath = tableView.indexPathForCell(tweetCell)
            let tweet = self.tweets[(indexPath!.row)]
            let user = tweet.user
            let userViewController = segue.destinationViewController as! UserViewController
            userViewController.user = user
        }
        
        if segue.identifier == "composeTweetSegue" {
            print("compose")
        }
            
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
