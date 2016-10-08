//
//  TitleListViewController.swift
//  Silverback
//
//  Created by Rahul on 10/8/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

import UIKit

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

let InternetetAlertMessage = "Please check your internet connectio., Please try again latter"
let SomethingWrongAlertMessage = "Something went wrong. Please try again "


let WebApiPath = "https://datatank.stad.gent/4/toerisme/visitgentevents.json"

class TitleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var _reloadBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var _titleListTableView: UITableView!
    var listArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Title list"
        
        //Regsistering tableview cell
        _titleListTableView.register(ListTableViewCell.nib(), forCellReuseIdentifier: ListTableViewCell.identifier())
        
        //call method to fetch data from server
        
        if ReachabilityController.sharedInstance.getReachabilityStatus() {
            fetchWebApiData()
        }else {
            showAlert(message: InternetetAlertMessage)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Private utility methods
    
    private func showAlert(message: String) {
    
        let alertViewController = UIAlertController(title: "SilverBack", message: message, preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
    private func fetchWebApiData() {
        _reloadBarButtonItem.isEnabled = false
        ActivityIndicatorController.sharedInstance.showActivityIndicator()
        
        guard let urlForServer = URL(string: WebApiPath) else {
            print("Error creating user for server")
            self.showAlert(message: SomethingWrongAlertMessage)
            return
        }
        
        let request = URLRequest(url: urlForServer)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data else {
                    ActivityIndicatorController.sharedInstance.removeActivityController()
                    self._reloadBarButtonItem.isEnabled = true
                    self.showAlert(message: SomethingWrongAlertMessage)
                    throw JSONError.NoData
                }
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray else {
                    ActivityIndicatorController.sharedInstance.removeActivityController()
                    self._reloadBarButtonItem.isEnabled = true
                    self.showAlert(message: SomethingWrongAlertMessage)
                    throw JSONError.ConversionFailed
                }
                
                ActivityIndicatorController.sharedInstance.removeActivityController()
                self._reloadBarButtonItem.isEnabled = true
                self.handleJsonResponseArray(jsonArray: jsonArray)
                
            } catch let error as JSONError {
                self.showAlert(message: SomethingWrongAlertMessage)
                print(error.rawValue)
            } catch let error as NSError {
                self.showAlert(message: SomethingWrongAlertMessage)
                print(error.debugDescription)
            }
            }.resume()
    }
    
    
    private func handleJsonResponseArray(jsonArray: NSArray)  {
        listArray = NSMutableArray(array: jsonArray)
        DispatchQueue.main.async {
            self._titleListTableView.reloadData()
        }
        
    }
    
    //MARK: - IBActions methods
    
    @IBAction func realodButtonClicked(_ sender: AnyObject) {
        
        if ReachabilityController.sharedInstance.getReachabilityStatus() {
            fetchWebApiData()
        }else {
            showAlert(message: InternetetAlertMessage)
        }
    }
    
    
    
    //MARK: - UITableViewDelegate UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier(), for: indexPath) as! ListTableViewCell
        let dict = listArray[indexPath.row] as! NSDictionary
        let path = dict["thumbs"] as! NSArray
        let imagePath = path[0]  as! String
        let thumnailUrl = URL.init(string: imagePath as String)
        cell.setupCell(thumnailUrl: thumnailUrl!, titel: dict["title"] as! String)
        return cell
    }
    
    
    
    
}
