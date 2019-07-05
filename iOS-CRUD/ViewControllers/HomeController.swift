//
//  HomeController.swift
//  iOS-CRUD
//
//  Created by Muang on 5/7/2562 BE.
//  Copyright © 2562 khrongpop. All rights reserved.
//

import UIKit
import Kingfisher

class HomeController: UIViewController {
    
    @IBOutlet weak var articleTableView: UITableView!
    fileprivate var articles: [Article] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.delegate = self
        articleTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchArticle()
    }
    
    
    func fetchArticle() {
        ArticleService.getArticles(onSuccess: { (articles) in
            self.articles = articles
            self.articleTableView.reloadData()
        }) { (error) in
            print("error : \(error.localizedDescription)")
        }
    }
    
    func alertDelete(id: Int) {
        let alert = UIAlertController(title: "Delete Article", message: nil, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            self.removeArticle(id: id)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(cancelAction)
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
}
extension HomeController: UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell {
            let article = articles[indexPath.row]
            cell.titleLabel.text = article.title
            if let image = article.image {
                cell.articleImageView.isHidden = false
                let imageURL = URL(string: UrlHelper.baseURL + image)
                cell.articleImageView.kf.setImage(with: imageURL)
            } else {
                cell.articleImageView.isHidden = true
            }
            return cell
        }
        return ArticleCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        alertDelete(id: article.id)
    }
}
