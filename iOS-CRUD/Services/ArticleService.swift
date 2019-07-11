//
//  ArticleService.swift
//  iOS-CRUD
//
//  Created by Muang on 5/7/2562 BE.
//  Copyright © 2562 khrongpop. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class ArticleService {
    
    class func getArticles(onSuccess: @escaping([Article]) -> () ,onError: @escaping(Error) -> ()) {
        
        Alamofire.request(UrlHelper.baseURL, method: .get).responseData(completionHandler: { (resData) in
            if let data = resData.data {
                do {
                    let decode = JSONDecoder()
                    let articles = try decode.decode([Article].self, from: data)
                    onSuccess(articles)
                } catch {
                    print("error : \(error)")
                    print("error.localizedDescription : \(error.localizedDescription)")
                    onError(error)
                }
            } else if let error = resData.error {
                 onError(error)
            }
        })
    }
    
    class func getArticle(withID id: Int, onSuccess: @escaping(Article) -> (), onError: @escaping(Error) -> () ) {
        
        Alamofire.request("\(UrlHelper.baseURL)detail/?id=\(id)", method: .get).responseData(completionHandler: { (resData) in
            if let data = resData.data {
                do {
                    let decode = JSONDecoder()
                    let article = try decode.decode(Article.self, from: data)
                    onSuccess(article)
                } catch {
                    print("error : \(error)")
                    print("error.localizedDescription : \(error.localizedDescription)")
                    onError(error)
                }
            } else if let error = resData.error {
                onError(error)
            }
        })
    }
    
    class func createArticle(parameters: [String:Any] ,completion: @escaping(String) -> ()) {
        Alamofire.request("\(UrlHelper.baseURL)create/", method: .post, parameters: parameters).responseJSON { (resJson) in
            
            guard let json = resJson.value as? NSDictionary ,
                let message = json["message"] as? String
                else { return }
            completion(message)
            
        }
    }
    
    class func updateArticle(parameters: [String:Any] ,completion: @escaping(String) -> ()) {
        Alamofire.request("\(UrlHelper.baseURL)update/", method: .post, parameters: parameters).responseJSON { (resJson) in
            
            guard let json = resJson.value as? NSDictionary ,
                let message = json["message"] as? String
                else { return }
            completion(message)
            
        }
    }
    
    class func deleteArticle(parameters: [String:Any] ,completion: @escaping(String) -> ()) {
        Alamofire.request("\(UrlHelper.baseURL)delete/", method: .post, parameters: parameters).responseJSON { (resJson) in
            
            guard let json = resJson.value as? NSDictionary ,
                let message = json["message"] as? String
                else { return }
            completion(message)
            
        }
    }
    
    class func createArticle(withImage image: UIImage, parameters: [String:Any] ,completion: @escaping(String) -> ()) {
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy_hhmmss"
        let imageName = "\(formatter.string(from: date))_articles.jpeg"
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imageData = image.jpegData(compressionQuality: 0.5){
                multipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/jpeg")
            }
            
            for (key, value) in parameters {
                if let data: Data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: "\(UrlHelper.baseURL)create_image/", method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { resJson in
                    print("Succesfully uploaded")
                    guard let json = resJson.value as? NSDictionary ,
                        let message = json["message"] as? String
                        else { return }
                    completion(message)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion("\(error.localizedDescription)")
            }
        }
        
    }
    
    class func updateArticle(withImage image: UIImage, parameters: [String:Any] ,completion: @escaping(String) -> ()) {
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy_hhmmss"
        let imageName = "\(formatter.string(from: date))_articles.jpeg"
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let imageData = image.jpegData(compressionQuality: 0.5){
                multipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/jpeg")
            }
            
            for (key, value) in parameters {
                if let data: Data = "\(value)".data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: "\(UrlHelper.baseURL)update_image/", method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { resJson in
                    print("Succesfully uploaded")
                    guard let json = resJson.value as? NSDictionary ,
                        let message = json["message"] as? String
//                        let image = json["image"] as? String
                        else { return }
                    completion(message)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion("\(error.localizedDescription)")
            }
        }
        
    }
}
