//
//  DetailViewController.swift
//  Flix
//
//  Created by Pedro Sandoval Segura on 6/16/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var informationView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320.0, height: 738.0) //CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height + informationView.frame.size.height - 160)
        
        print("The scroll view's content size is \(scrollView.contentSize)") //debugging
        print(movie) //debugging
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overViewLabel.text = overview
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterImageView.setImageWithURL(imageUrl!)
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
