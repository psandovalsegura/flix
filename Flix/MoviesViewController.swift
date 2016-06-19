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

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var refreshControl = UIRefreshControl()
    var endpoint: String!
    
    var filteredMovies: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //By default, assume there is network connection
        networkLabel.hidden = true
        
        //Do not display search bar - only displays when search button is clicked
        searchBar.hidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        self.loadDataFromNetwork("initial")
        refreshControl.addTarget(self, action: #selector(loadDataFromNetwork(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(getTimestamp())")
        tableView.insertSubview(refreshControl, atIndex: 0)
        loadDataFromNetwork("-")
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentMovies = filteredMovies {
            return currentMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        //Check if we are looking at the top rated movies
        if self.endpoint == "top_rated" {
            cell.titleLabel.text = "\(indexPath.row + 1). \(title)"
        } else {
            cell.titleLabel.text = title
        }
        
        cell.overviewLabel.text = overview
        
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        cell.posterView.setImageWithURL(imageUrl!)
        
        return cell
    }
    
    
    func loadDataFromNetwork(point: AnyObject) {
        // Do any additional setup after loading the view.
        let apiKey = "996d1da2a3d7f707fd97b134f290c1ee"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")   //  \(endpoint)
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        print(point)
        if (String(point) == "initial") {
            // Display HUD right before the request is made
            print("initial request to load")
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                    
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    self.filteredMovies = self.movies
                }
            } else {
                self.networkLabel.hidden = false
            }
            
            if (String(point) == "initial") {
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            
            self.refreshControl.endRefreshing()
        })
        task.resume()
    }
    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        if searchBar.hidden {
            searchBar.hidden = false
            tableView.frame.origin = CGPoint(x: 0, y: 40)
        } else {
            searchBar.hidden = true
            tableView.frame.origin = CGPoint(x: 0, y: 0)
            searchBar.text = ""
            loadDataFromNetwork("-")
            tableView.reloadData()
        }
    }
    
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredMovies = movies!.filter({(dataItem: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if String(dataItem["title"]).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.hidden = true
        tableView.frame.origin = CGPoint(x: 0, y: 0)
        searchBar.resignFirstResponder()
        loadDataFromNetwork("-")
        loadDataFromNetwork("-")
        tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Credit for this function to Scott Gardner on Stack Overflow: http://stackoverflow.com/questions/24070450/how-to-get-the-current-time-and-hour-as-datetime */
    func getTimestamp() -> String{
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return timestamp
    }

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Check if user is searching
        var movie: NSDictionary = NSDictionary() //Empty Dictionary
        if searchBar.text != nil && searchBar.text != ""{
            let movieTitle = (sender as! MovieCell).titleLabel.text
            //print("User searched for \(movieTitle)")
            for movieDictionary in movies! {
                //print("In for loop... title retrieved is \(movieDictionary["title"]!)")
                //print("Comparing \(String(movieDictionary["title"]!)) and \(String(movieTitle!))")
                
                if String(movieDictionary["title"]!) == String(movieTitle!) {
                    //print("User search tap matched with \(movieDictionary["title"]). Dictionary save is below...")
                    //print(movieDictionary)
                    movie = movieDictionary
                }
            }
        } else {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            movie = movies![indexPath!.row]
        }
        
        /*
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]*/
        
        let destinationViewController = segue.destinationViewController as! DetailViewController
        destinationViewController.movie = movie
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}
