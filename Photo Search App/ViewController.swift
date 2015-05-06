//
//  ViewController.swift
//  Photo Search App
//
//  Created by Marius on 5/6/15.
//  Copyright (c) 2015 Marius Mukunzi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( "https://api.instagram.com/v1/tags/audi/media/recent?client_id=4111293b265342fc973af2cbbc59078b",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //println("JSON: " + responseObject.description)
                
                if let dataArray = responseObject["data"] as? [AnyObject] {
                    var urlArray:[String] = []                  //1
                    for dataObject in dataArray {               //2
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String { //3
                            urlArray.append(imageURLString)     //4
                        }
                    }
                    // println(urlArray)                           //5
                   
                    // set the height of the scrollView > 320 px times number of items in the data array
                    self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))
                    
                    // generate UIImageViews based on the URLs
                    for var i = 0; i < urlArray.count; i++ {
                        let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)         //1
                        if let imageDataUnwrapped = imageData {                                     //2
                            let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped))   //3
                            imageView.frame = CGRectMake(0, 320 * CGFloat(i), 320, 320)               //4
                            self.scrollView.addSubview(imageView)                                        //5
                        }
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

