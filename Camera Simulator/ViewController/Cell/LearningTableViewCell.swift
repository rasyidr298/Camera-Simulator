//
//  LearningTableViewCell.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 15/05/22.
//

import UIKit

class LearningTableViewCell: UITableViewCell {

    
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var learningImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var learning: Learning?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        learningImg.image = UIImage(named: learning?.learningImg ?? "img_error")
        learningImg.layer.cornerRadius = learningImg.frame.size.width / 12
        learningImg.layer.borderColor = UIColor.darkGray.cgColor
        learningImg.layer.borderWidth = 2
        
        titleLabel.text = learning?.learningTitle
        descLabel.text = learning?.learningDesc
        
        fieldView.layer.cornerRadius = 12
    }
    
}
