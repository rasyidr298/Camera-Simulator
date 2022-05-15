//
//  LearningViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 11/05/22.
//

import UIKit

class LearningViewController: UITableViewController {
    
    @IBOutlet var learningTableView: UITableView!
    
    var listLearning: [Learning] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
    }
}

extension LearningViewController {
    
    func setupTable() {
        let nib = UINib(nibName: learningCellId, bundle: nil)
        learningTableView.register(nib, forCellReuseIdentifier: learningCellId)
        
        listLearning.append(contentsOf: Learning.dataLearning())
    }
}

extension LearningViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listLearning.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let learningListData = listLearning[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: learningCellId) as! LearningTableViewCell
        
        cell.learning = learningListData
        cell.updateCell()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: detailVCId) as! DetailViewController
        destinationVC.learning = listLearning[indexPath.row]
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
