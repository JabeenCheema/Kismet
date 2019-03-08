//
//  SetupProfileViewController.swift
//  KismetApp
//
//  Created by Jabeen's MacBook on 3/6/19.
//  Copyright © 2019 Jabeen's MacBook. All rights reserved.
//

import UIKit
import AVFoundation

class SetupProfileViewController: UIViewController {

    var userSession: UserSession!
    var storageManager: StorageManager!
    // when I did the extension I forgot to create an instance of the image picker controller 
    private var imagePickerController: UIImagePickerController!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var personNameTextField: UITextField!
    @IBOutlet weak var personAgeTextField: UITextField!
    @IBOutlet weak var personGenderTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var photoLibrary: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePicker()
        storageManager = (UIApplication.shared.delegate as! AppDelegate).storageManager
        storageManager.delegate = self
    }
    
    @IBAction func enterButtonPressed(_ sender: UIButton) {
    guard let image = profileImage.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        storageManager.postImage(withData: image)
    }
    
    func setImagePicker() {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false 
        }
    }
    
    func showImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        imagePickerController.sourceType = .camera
        showImagePickerController()
    }
    
    @IBAction func photoLibraryPressed(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        showImagePickerController()
    }
    

}

// I did this extension because everytime we upload a pic from camera or photoLibrary we need an imagepickercontroller
extension SetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            showAlert(title: "Error with image", message: "Try Again", actionTitle: "Ok")
            return
        }
        profileImage.image = image
        
        
        guard let imageDataStorage = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to create data for image to store in firebase")
            return
        }
        // I need a Firebase Storage Manager File
        
        storageManager.postImage(withData: imageDataStorage)
        
        dismiss(animated: true)
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension SetupProfileViewController: StorageManagerDelegate {
    func didFetchImage(_ storageManager: StorageManager, imageURL: URL) { // getting the image back through the StorageManagerDelegate
        guard let name = personNameTextField.text,
            let age = personAgeTextField.text,
            let gender = personGenderTextField.text else {
                return
        }
        let person = PersonModel.init(image: imageURL.absoluteString, name: name, age: age, gender: gender)
        DatabaseManager.postPersonProfileToDatabase(person: person) // this is sending this info to firebase
    }
    }
    
    

