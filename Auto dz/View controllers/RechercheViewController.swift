//
//  RechercheViewController.swift
//  Auto dz
//
//  Created by hadj aissa hadj said on 26.12.2020.
//

import UIKit

class RechercheViewController: UIViewController, UITabBarControllerDelegate {
    
    let tabBarViewController = TabBarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
    }

}
