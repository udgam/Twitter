//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Udgam Goyal on 6/29/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profPicImage: UIImageView!
    @IBOutlet weak var charactersLeft: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextField.delegate = self
        charactersLeft.text = "140 Characters Left"
        if let user = User.currentUser{
            profPicImage.layer.cornerRadius = profPicImage.frame.size.width / 10
            profPicImage.clipsToBounds = true
            let imageURL = user.profileURL
            profPicImage.setImageWithURL((imageURL!))
        }
        

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength =  textField.text!.utf16.count + string.utf16.count - range.length
        //change the value of the label
        charactersLeft.text =  "\(140 - newLength) Characters Left"
        //you can save this value to a global var
        //myCounter = newLength
        //return true to allow the change, if you want to limit the number of characters in the text field use something like
        return newLength <= 140 // To just allow up to 140 characters
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func composeAction(sender: AnyObject) {
        print("composeAction called")
        TwitterClient.sharedInstance.composeTweet(tweetTextField.text!, success: {
            
        }) { (error: NSError) in
            print("error")
        }
        print("tweet composed")
        self.dismissViewControllerAnimated(true, completion: nil)
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

