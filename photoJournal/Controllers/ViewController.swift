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
    
    
    //MARK: -- Life Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        dump(journals)
    }
    
    //MARK: -- IBActions
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        presentPhotoEntryModally()
    }
    
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
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

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return journals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentJournals = journals[indexPath.row]
        if let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoJournalCell", for: indexPath) as? PhotoJournalCell {
            if let image = UIImage(data: currentJournals.image) {
                cell.image.image = image
            }
            cell.JournalNameLabel.text = currentJournals.description
            return cell
        }
        return UICollectionViewCell()
    }
    
}
