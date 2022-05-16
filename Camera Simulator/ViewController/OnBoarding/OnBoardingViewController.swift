//
//  OnBoardingViewController.swift
//  Camera Simulator
//
//  Created by Rasyid Ridla on 12/05/22.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var onBoardingPageViewController: OnboardingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onBoardingViewController = segue.destination as? OnboardingPageViewController {
            onBoardingViewController.pageViewControllerDelegate = self
            onBoardingPageViewController = onBoardingViewController
        }
    }
}

extension OnBoardingViewController {
    
    @IBAction func nextButton(_ sender: Any) {
        onBoardingPageViewController?.turnPage(index: pageControl.currentPage + 1, type: 1)
        
        if nextButton.titleLabel?.text == "skip" {
            dismiss(animated: true)
            UserDefaults.standard.set(true, forKey: showOnBoard)
        }
    }
    
    @IBAction func previousButton(_ sender: Any) {
        onBoardingPageViewController?.turnPage(index: pageControl.currentPage - 1, type: 2)
    }
}

extension OnBoardingViewController: onboardingPageViewControllerDelegate {
    func setupPageController(numberOfPage: Int) {
        pageControl.numberOfPages = numberOfPage
    }
    
    func turnPageController(to index: Int) {
        pageControl.currentPage = index
        nextButton.setTitle(index == 2 ? "skip" : "next", for: .normal)
    }
}
