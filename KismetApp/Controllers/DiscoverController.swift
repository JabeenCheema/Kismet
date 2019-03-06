//
//  DiscoverController.swift
//  KismetApp
//
//  Created by Jabeen's MacBook on 3/6/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import UIKit

class DiscoverController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
    let card = sender.view!
    let point = sender.translation(in: view) // how far you moved your finger
    card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)  // view.center.x/y is centering to its parent view
    
        if sender.state == UIGestureRecognizer.State.ended {
        
            UIView.animate(withDuration: 0.2, animations: {
            card.center = self.view.center
            })
        }
    }
}
