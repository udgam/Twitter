//
//  LoginViewController.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/27/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogInButton(sender: AnyObject) {
        let twitterClient = TwitterClient.sharedInstance
        
        twitterClient.logIn({
            print("I have logged in")
            self.performSegueWithIdentifier("logInSegue", sender: nil)
            
        }) { (error: NSError) in
                print("error:\(error.localizedDescription)")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
