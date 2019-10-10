//
//  PhotoJournalCell.swift
//  photoJournal
//
//  Created by Radharani Ribas-Valongo on 10/10/19.
//  Copyright © 2019 Radharani Ribas-Valongo. All rights reserved.
//

import UIKit

class PhotoJournalCell: UICollectionViewCell {
    
    //MARK: -- Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var JournalNameLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    
    //MARK: -- Functions
    @IBAction func photoSettingPressed(_ sender: UIButton) {
        
    }
    
}
