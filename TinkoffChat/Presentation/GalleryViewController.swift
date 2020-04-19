//
//  GalleryViewController.swift
//  TinkoffChat
//
//  Created by Vera on 19.04.2020.
//  Copyright © 2020 Vera. All rights reserved.
//

import Foundation
import UIKit

class GalleryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    let identifier = String(describing: GalleryCollectionCell.self)
    let activityIndicator  = UIActivityIndicatorView(style: .gray)
    var images = [Answer]()
    var itemsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images.removeAll()
        
        collectionView?.backgroundColor = .white
        collectionView.register(GalleryCollectionCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let urlString = "https://pixabay.com/api/?key=16119655-bd6140c89488532bfaffe9dfb"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        if let url = url {
            let request = URLRequest(url: url)
            let countTask = session.dataTask(with: request) {(data, response, error) in
                if let error = error {
                    let failAlert = UIAlertController(title: "При загрузке данных что-то пошло не так 🤯",
                                                      message: "Error \(error): \(error.localizedDescription)",
                        preferredStyle: .alert)
                    failAlert.addAction(UIAlertAction(title: "Закрыть галлерею", style: .default,
                                                      handler: {action in
                                                        self.dismiss(animated: true, completion: nil)
                                                        return
                    }))
                    self.present(failAlert, animated: true)
                    print(error)
                } else if let data = data {
                    let pixabayResponse = try? JSONDecoder().decode(PixabayResponse.self, from: data)
                    self.itemsCount = pixabayResponse?.totalHits ?? 0
                    if (self.itemsCount == 0){
                        let zeroAlert = UIAlertController(title: "Что-то не так с запросом",
                                                          message: "Не удалось подгрузить ни одной картинки.",
                                                          preferredStyle: .alert)
                        zeroAlert.addAction(UIAlertAction(title: "Закрыть галлерею", style: .default,
                                                          handler: {action in
                                                            self.dismiss(animated: true, completion: nil)
                                                            return
                        }))
                        self.present(zeroAlert, animated: true)
                    }
                }
            }
            countTask.resume()
            
            DispatchQueue.global(qos: .background).async {
                let loadingTask = session.dataTask(with: request) {(data, response, error) in
                    if let error = error {
                        let failAlert = UIAlertController(title: "При загрузке данных что-то пошло не так 🤯",
                                                          message: "Error \(error): \(error.localizedDescription)",
                            preferredStyle: .alert)
                        failAlert.addAction(UIAlertAction(title: "Закрыть галлерею", style: .default,
                                                          handler: {action in
                                                            self.dismiss(animated: true, completion: nil)
                                                            return
                        }))
                        self.present(failAlert, animated: true)
                        print(error)
                    } else if let data = data {
                        let pixabayResponse = try? JSONDecoder().decode(PixabayResponse.self, from: data)
                            if let pixabayResponse = pixabayResponse {
                                for image in pixabayResponse.hits {
                                    self.images.append(Answer(id: image.id, webFormatImage: UIImage()))
                                    
                                    let localRequest = URLRequest(url: URL(string: image.webformatURL! )!)
                                    let localTask = session.dataTask(with: localRequest) {(data, response, error) in
                                        if let data = data {
                                            self.images.append(Answer(id: image.id, webFormatImage: UIImage(data: data)))
                                        }
                                    }
                                    localTask.resume()
                                }
                            }
                        }
                }
                loadingTask.resume()
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        activityIndicator.stopAnimating()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GalleryCollectionCell
        if  (indexPath.row >= images.count) {
            cell.imageView.image = UIImage.init(named: "placeHolder.png")
        } else {
            cell.imageView.image = images[indexPath.row].webFormatImage
        }
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseAvatarAction(_:)))
        singleTap.numberOfTouchesRequired = 1
        cell.imageView.addGestureRecognizer(singleTap)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.frame.width-16)/3)-16, height: ((view.frame.width-16)/3)-16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }
    override func viewWillDisappear(_ animated: Bool) {
        //обновить аватарку
    }
    
    //MARK: Actions
    @objc func chooseAvatarAction(_ sender : UIButton) {
        //тут должно быть присвоение новго знаяения полю с аватаркой в базе и обновление на ProfileViewController, но в базе сильно накосячено и исправить не хватило времени
        dismiss(animated: true, completion: nil)
    }
}
