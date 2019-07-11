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
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "show", let vc = segue.destination as? DetailController ,let article = sender as? Article else { return }
        vc.articleID = article.id
        
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
        performSegue(withIdentifier: "show", sender: article)
//        alertDelete(id: article.id)
    }
}
