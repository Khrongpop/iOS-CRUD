//
//  CreateController.swift
//  iOS-CRUD
//
//  Created by Muang on 5/7/2562 BE.
//  Copyright © 2562 khrongpop. All rights reserved.
//

import UIKit

class CreateController: UIViewController {
    
    @IBOutlet weak var titleTextfiled: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSubmit() {
        guard let title = titleTextfiled.text,
            let detail = detailTextView.text  else { return }
        
        let parms: [String: Any] = [
            "title" : title,
            "detail" : detail
        ]
        
        ArticleService.createArticle(parameters: parms) { (message) in
            let  alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(done)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
  
}
