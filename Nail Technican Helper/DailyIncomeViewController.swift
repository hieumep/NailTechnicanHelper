//
//  DailyIncomeViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/10/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class DailyIncomeViewController : UIViewController {
    
    @IBOutlet weak var pickShopLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickShopLabel.text = " You don't set up Nail Shop yet, please tap EDIT to pick your current Nail Shop"
    }
}
