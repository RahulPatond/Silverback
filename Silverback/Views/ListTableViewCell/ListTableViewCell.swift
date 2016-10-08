//
//  ListTableViewCell.swift
//  WebService
//
//  Created by Rahul on 10/7/16.
//  Copyright © 2016 Rahul. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var thumnailImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titelLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Class functions
    class func identifier() -> String {
        return "ListTableViewCell"
    }
    
    class func nib() -> UINib {
        let nib = UINib(nibName: "ListTableViewCell", bundle: Bundle.main)
        return nib
    }
    
    
    //MARK: - Configuration
   func setupCell(thumnailUrl:URL, titel:String) {
        
        titelLabel.text = titel
        DispatchQueue.global(qos: .background).async {
            do {
                //getting image data
                   self.activityIndicator.startAnimating()
                 let thumnailData = try Data(contentsOf: thumnailUrl)
                
                DispatchQueue.main.async {
                   self.thumnailImageView.image = UIImage(data: thumnailData)
                    self.activityIndicator.stopAnimating()
                }
            }catch{
                print("Error while gettind image data from thumnail url")
            }
        }
    }
   
    
}
