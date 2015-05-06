//
//  ViewController.swift
//  Photo Search App
//
//  Created by Marius on 5/6/15.
//  Copyright (c) 2015 Marius Mukunzi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchInstagramByHashtag("Audi")
    }
    
     // Utility methods
    func searchInstagramByHashtag(searchString:String) {
        
        //instantiate a gray Activity Indicator View
        var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        //add the activity to the ViewController's view
        view.addSubview(activityIndicatorView)
        //position the Activity Indicator View in the center of the view
        activityIndicatorView.center = view.center
        //tell the Activity Indicator View to begin animating
        activityIndicatorView.startAnimating()
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( "https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=4111293b265342fc973af2cbbc59078b",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //println("JSON: " + responseObject.description)
                
                if let dataArray = responseObject["data"] as? [AnyObject] {
                    var urlArray:[String] = []
                    for dataObject in dataArray {
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String { 
                            urlArray.append(imageURLString)
                        }
                    }
                    // println(urlArray)
                    
                    
                    // set the height of the scrollView > 320 px times number of items in the data array
                    //self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))

                    let imageWidth = self.view.frame.width
                    self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(dataArray.count))
                    
                    // generate UIImageViews based on the URLs
                    for var i = 0; i < urlArray.count; i++ {
                        let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)         //1
                        if let imageDataUnwrapped = imageData {                                     //2
                            
                            // display images synchronously
                            //let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped))   //3
                            //imageView.frame = CGRectMake(0, 320 * CGFloat(i), 320, 320)               //4
                            
                            // display images asynchronously
                            let imageView = UIImageView(frame: CGRectMake(0, imageWidth*CGFloat(i), imageWidth, imageWidth))     //1
                            imageView.setImageWithURL( NSURL(string: urlArray[i])) //UIKit+AFNetworking magic! //2
                            self.scrollView.addSubview(imageView)                                     //5
                        }
                    }
                }
                // remove the activity indicator
                activityIndicatorView.removeFromSuperview()
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    // UISearchBarDelegate protocol methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        // make sure the keyboard goes away once the user taps "Search"
        searchBar.resignFirstResponder()
        searchInstagramByHashtag(searchBar.text)
    }
}

