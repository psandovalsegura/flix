//
//  MoviesViewController.swift
//  Flix
//
//  Created by Pedro Sandoval Segura on 6/15/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var refreshControl = UIRefreshControl()
    var endpoint: String!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.posterView.setImageWithURL(imageUrl!)
        
        print("row \(indexPath.row)")
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //By default, assume there is network connection
        networkLabel.hidden = true
        
        //Do not display search bar - only displays when search button is clicked
        movieSearchBar.hidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.loadDataFromNetwork(true)
        refreshControl.addTarget(self, action: #selector(loadDataFromNetwork(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())")
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func loadDataFromNetwork(initial: Bool) {
        // Do any additional setup after loading the view.
        let apiKey = "996d1da2a3d7f707fd97b134f290c1ee"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")   //  \(endpoint)
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        
        if (initial) {
        // Display HUD right before the request is made
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            } else {
                self.networkLabel.hidden = false
            }
            
            if (initial) {
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            } else {
                self.refreshControl.endRefreshing()
            }
        })
        task.resume()
    }
    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        movieSearchBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let destinationViewController = segue.destinationViewController as! DetailViewController
        destinationViewController.movie = movie
        
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}
