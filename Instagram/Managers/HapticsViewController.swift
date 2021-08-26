//
//  HapticsViewController.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-15.
//

import UIKit

class HapticsViewController: UIViewController {

    static let shared = HapticsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     
    func selectionVibration(){
        
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
        
        let generator = UINotificationFeedbackGenerator()
        
        generator.prepare()
        generator.notificationOccurred(type)
        
    }
    
    
    
    

}
