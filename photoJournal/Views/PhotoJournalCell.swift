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
    @IBOutlet weak var cellSettingsButton: UIButton!
    
    weak var delegate: JournalCellDelegate?
    
    //MARK: -- Functions
    @IBAction func photoSettingPressed(_ sender: UIButton) {
        delegate?.showActionSheet(tag: sender.tag)
        print("benis")
        
    }
    
    func configureCell(journal: PhotoJournal) {
        JournalNameLabel.text = journal.description
        date.text = journal.date.description
        if let image = UIImage(data: journal.image) {
            self.image.image = image
        }
        
    }
}
