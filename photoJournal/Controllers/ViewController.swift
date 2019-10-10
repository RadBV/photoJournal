//
//  ViewController.swift
//  photoJournal
//
//  Created by Radharani Ribas-Valongo on 10/8/19.
//  Copyright © 2019 Radharani Ribas-Valongo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        presentPhotoEntryModally()
        
    }
    @IBAction func settingsButton(_ sender: UIBarButtonItem) {
    }
    
    
    private func presentPhotoEntryModally() {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "PhotoEntryVC")
        
        let photoEntryVC = UINavigationController(rootViewController: popoverContent ?? UIViewController())
        
        self.present(photoEntryVC, animated: true, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
