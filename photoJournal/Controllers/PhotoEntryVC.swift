//
//  PhotoEntryVC.swift
//  photoJournal
//
//  Created by Radharani Ribas-Valongo on 10/10/19.
//  Copyright © 2019 Radharani Ribas-Valongo. All rights reserved.
//

import UIKit
import Photos

class PhotoEntryVC: UIViewController {
    
    //MARK: -- Outlets
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    
    //MARK: -- Properties
    let imagePlaceholder = #imageLiteral(resourceName: "placeholder")
    var photoLibraryAccess = false
    var photoDesc = ""
    
    var image = UIImage() {
        didSet {
            photoImage.image = image
        }
    }
    
    var placeholderLabel: UILabel!
    
    var journalToBeEdited: PhotoJournal?
    var journalIndex = Int()
    var journal = [PhotoJournal]()
    
    //MARK: -- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if journalToBeEdited == nil {
            setUpTextViewPlaceholder()
        } else {
            setEditJournalView()
        }
//        if descriptionTextView.text.isEmpty {
//            placeholderLabel.isHidden = false
//        } else {
//            placeholderLabel.isHidden = true
//        }
        checkPhotoLibraryAccess()
        setUpMiscellaneousViewDidLoadThings()
        descriptionTextView.delegate = self
    }
    
    
    //MARK: -- IBActions
  
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let data = image.pngData() else {
            print("image could not be converted to data")
            return
        }
        
        let newJournal = PhotoJournal(image: data, description: descriptionTextView.text, date: Date())
        DispatchQueue.global(qos: .utility).async {
          try? JournalPersistenceHelper.manager.save(newJournal: newJournal)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -- OTHER Functions

    private func setUpTextViewPlaceholder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter photo description..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: descriptionTextView.font?.pointSize ?? 10)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
        descriptionTextView.addSubview(placeholderLabel)
    }
    
    private func setUpMiscellaneousViewDidLoadThings() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        self.image = imagePlaceholder
        saveButton.isEnabled = false
    }
    
    @objc private func dismissKeyboard() {
        descriptionTextView.resignFirstResponder()
    }
    
    private func setEditJournalView() {
        let image = UIImage(data: journalToBeEdited!.image)
        descriptionTextView.text = journalToBeEdited?.description
        photoImage.image = image
    }
    
    //MARK: -- Photo Library Access
    @IBAction func choosePhotoButtonPressed(_ sender: UIBarButtonItem) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        if self.photoLibraryAccess {
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController,animated: true)
        } else {
            let noAuthenticationAlertalertVC = UIAlertController(title: "ACCESS DENIED", message: "This app has not been authorized to access your photo library. :(", preferredStyle: .alert)
            noAuthenticationAlertalertVC.addAction(UIAlertAction (title: "DENY", style: .destructive, handler: nil))
            self.present(noAuthenticationAlertalertVC, animated: true, completion: nil)
            
            noAuthenticationAlertalertVC.addAction(UIAlertAction (title: "LET ME IN", style: .default, handler: { (action) in
                self.photoLibraryAccess = true
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
    }
    
    
    private func checkPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            print(status)
            self.photoLibraryAccess = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({status in
                switch status {
                case .authorized:
                    self.photoLibraryAccess = true
                    print(status)
                case .denied:
                    self.photoLibraryAccess = false
                    print("denied")
                case .notDetermined:
                    print("not determined")
                case .restricted:
                    print("restricted")
                }
            })
            
        case .denied:
            
            let noAuthenticationAlert = UIAlertController(title: "Denied", message: "This app has not been authorized to access your photo library. Please change your settings", preferredStyle: .alert)
            noAuthenticationAlert.addAction(UIAlertAction (title: "Ok", style: .default, handler: nil))
            self.present(noAuthenticationAlert, animated: true, completion: nil)
        case .restricted:
            print("restricted")
        }
    }
}

//MARK: -- Image Picker Extension
extension PhotoEntryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            print("Error grabbing image")
            return
        }
        self.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



//MARK: -- Text View extention
extension PhotoEntryVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if image != imagePlaceholder && descriptionTextView.text != "" {
            saveButton.isEnabled = true
        } else if descriptionTextView.text == "" {
            saveButton.isEnabled = false
        }

        placeholderLabel.isHidden = !textView.text.isEmpty

    }
}
