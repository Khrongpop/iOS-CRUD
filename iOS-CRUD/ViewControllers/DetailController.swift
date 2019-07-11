//
//  DetailController.swift
//  iOS-CRUD
//
//  Created by Muang on 10/7/2562 BE.
//  Copyright © 2562 khrongpop. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    var articleID: Int?
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchArticle()
    }
    
    func fetchArticle() {
        guard let id = articleID else { return }
        self.navigationController?.title = "Article \(id)"
        ArticleService.getArticle(withID: id, onSuccess: { (article) in
            self.article = article
            self.titleLabel.text = article.title
            self.detailLabel.text = article.detail
            if let image = article.image {
                let imagURL = URL(string: "\(UrlHelper.baseURL)\(image)")
                self.articleImageView.kf.setImage(with: imagURL)
            }
        }, onError: { _ in
            
        })
    }
    
    @IBAction func clickDelete() {
         guard let id = articleID else { return }
        alertDelete(id: id)
    }
    
    func alertDelete(id: Int) {
        let alert = UIAlertController(title: "Delete Article", message: nil, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            self.removeArticle(id: id)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(cancelAction)
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(deleteAction)
        
        present(alert,animated: true)
    }
    
    func removeArticle(id: Int) {
        let parm = ["id":id]
        ArticleService.deleteArticle(parameters: parm) { (string) in
            let alert = UIAlertController(title: string, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(cancelAction)
            self.fetchArticle()
            self.present(alert,animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit", let vc = segue.destination as? CreateController ,let article = article {
            vc.article = article
        }
    }
}
