//
//  ImageViewController.swift
//  Nail Technican Helper
//
//  Created by Hieu Vo on 4/20/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController : UIViewController{
    var image : UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        imageView.image = image
    }
    @IBAction func backAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
