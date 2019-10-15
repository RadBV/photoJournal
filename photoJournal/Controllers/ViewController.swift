//
//  ViewController.swift
//  photoJournal
//
//  Created by Radharani Ribas-Valongo on 10/8/19.
//  Copyright © 2019 Radharani Ribas-Valongo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    //MARK: -- Outlets
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    //MARK: -- Properties
    
    var journals = [PhotoJournal]() {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    
    var verticalScroll = true
    
    
    //MARK: -- Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    //MARK: -- IBActions
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        presentPhotoEntryModally()
    }
    
    @IBAction func journalSettingsButtonPressed(_ sender: UIButton) {

        
    }
    
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
        //TODO: - segue to SettingsVC
        
    }
    
    //MARK: -- Other Functions
    
    func loadData() {
        do {
            journals = try JournalPersistenceHelper.manager.getJournals()
        } catch {
            print(error)
        }
    }
    
    private func presentPhotoEntryModally() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        guard let photoEntryVC = storyboard.instantiateViewController(withIdentifier: "PhotoEntryVC") as? PhotoEntryVC else {
            return
        }
        photoEntryVC.modalPresentationStyle = .currentContext
        self.present(photoEntryVC, animated: true, completion: nil)
    }

}


//MARK: -- Extensions

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return journals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentJournals = journals[indexPath.row]
        if let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoJournalCell", for: indexPath) as? PhotoJournalCell {
            cell.configureCell(journal: currentJournals)
            cell.delegate = self
            cell.cellSettingsButton.tag = indexPath.row
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension ViewController: JournalCellDelegate {
    
    func showActionSheet(tag: Int) {
        
 
        let journal = self.journals[tag]
        let settingsActionSheet = UIAlertController(title: "Journal Settings", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        ///vvv This segues to the PhotoEntryVC but that view controller is buggy so I'm keeping this out vvv
//        let editAction = UIAlertAction.init(title: "Edit", style: .default) { (action) in
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let photoEntryVC =  storyBoard.instantiateViewController(identifier: "PhotoEntryVC") as! PhotoEntryVC
//
//            photoEntryVC.journalToBeEdited = journal
//            photoEntryVC.journalIndex = tag
//            photoEntryVC.journal = self.journals
//            photoEntryVC.modalPresentationStyle = .currentContext
//            self.present(photoEntryVC, animated: true)
//        }
        
        let deleteAction = UIAlertAction.init(title: "Delete", style: .destructive) { (action) in
            DispatchQueue.global(qos: .utility).async {
                try? JournalPersistenceHelper.manager.deleteJournal(date: journal.date)
            }
            
            ///I tried to get the collection view to reload after the persistence helper deleted the cell but i couldn't figure it out
//            DispatchQueue.main.async {
//                self.photoCollectionView.reloadData()
//            }

        }
        
        let shareAction = UIAlertAction.init(title: "Share", style: .default) { (action) in
            let item = [UIImage(data: journal.image)]
            
            let activityController = UIActivityViewController(activityItems: item as [Any], applicationActivities: nil)
            
            self.present(activityController, animated: true)
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
//        settingsActionSheet.addAction(editAction)
        settingsActionSheet.addAction(UIAlertAction(title: "Edit", style: .default))
        settingsActionSheet.addAction(shareAction)
        settingsActionSheet.addAction(deleteAction)
        settingsActionSheet.addAction(cancelAction)
        
        present(settingsActionSheet, animated: true, completion:  nil)
    }
}
