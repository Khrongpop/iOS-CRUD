//
//  CreateController.swift
//  iOS-CRUD
//
//  Created by Muang on 5/7/2562 BE.
//  Copyright © 2562 khrongpop. All rights reserved.
//

import UIKit

class CreateController: UIViewController {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleTextfiled: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
  
    
    var article: Article! {
        didSet {
            isEdit = true
        }
    }
    var isEdit: Bool = false, statusImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if isEdit {
            // edit
            guard let article = self.article  else { return }
            titleTextfiled.text = article.title
            detailTextView.text = article.detail
            if let image = article.image {
                let imagURL = URL(string: "\(UrlHelper.baseURL)\(image)")
                self.articleImageView.kf.setImage(with: imagURL)
            }
            submitButton.setTitle("Update", for: .normal)
        } else {
            // create
            submitButton.setTitle("Create", for: .normal)
        }
    }
    
    @IBAction func clickSubmit() {
        guard let title = titleTextfiled.text,
            let detail = detailTextView.text  else { return }
        
        var parms: [String: Any] = [
            "title" : title,
            "detail" : detail
        ]
        
        if isEdit {
            parms["id"] = article.id
            if statusImage,  let image = articleImageView.image {
                //  update image
                ArticleService.updateArticle(withImage: image, parameters: parms) { (message)  in
                    self.alertMessage(message: message)
                }
            } else {
                // not update image
                ArticleService.updateArticle(parameters: parms) { (message) in
                    self.alertMessage(message: message)
                }
            }

        } else {
            // create
            if let image = articleImageView.image {
                ArticleService.createArticle(withImage: image, parameters: parms) { (message) in
                    self.alertMessage(message: message)
                }
            } else {
                ArticleService.createArticle(parameters: parms) { (message) in
                    self.alertMessage(message: message)
                }
            }
        }
            
    }
    
    func alertMessage(message: String){
        let  alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
  
}
extension CreateController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func clickAddImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        articleImageView.image = image
        statusImage = true
        dismiss(animated: true)
    }
}
