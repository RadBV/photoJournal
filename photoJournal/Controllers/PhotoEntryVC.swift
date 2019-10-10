//
//  PhotoEntryVC.swift
//  photoJournal
//
//  Created by Radharani Ribas-Valongo on 10/10/19.
//  Copyright © 2019 Radharani Ribas-Valongo. All rights reserved.
//

import UIKit

class PhotoEntryVC: UIViewController {
    
    //MARK: -- Outlets
    
    @IBOutlet weak var photoImage: UIImageView!
    
    
    //MARK: -- Properties
    
    //MARK: -- Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
