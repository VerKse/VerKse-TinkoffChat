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
    var imagesList = [Question]()
    var images = [Answer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images.removeAll()
        imagesList.removeAll()
        
        collectionView?.backgroundColor = .white
        collectionView.register(GalleryCollectionCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let urlString = "https://pixabay.com/api/?key=16119655-bd6140c89488532bfaffe9dfb"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        //запускаем таску на получение списка изображений
        
        //обновляем коллекцию
        
        //переходим в бэк и асинхронно подгружаем данные новой таской
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        if let url = url {
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) {(data, response, error) in
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
                    if (pixabayResponse?.totalHits != 0 )
                    {
                        
                        let firstItem = pixabayResponse?.hits.first
                        print("Image id: \(String(describing: firstItem?.id))")
                        if let firstItem = firstItem {
                            let localRequest = URLRequest(url: URL(string: firstItem.webformatURL! )!)
                            let localTask = session.dataTask(with: localRequest) {(data, response, error) in
                                if let data = data {
                                    self.images.append(Answer(id: firstItem.id, webFormatImage: UIImage(data: data)))
                                }
                            }
                            localTask.resume()
                        }
                        DispatchQueue.global(qos: .background).async {
                            if let pixabayResponse = pixabayResponse {
                                for image in pixabayResponse.hits {
                                    self.images.append(Answer(id: image.id, webFormatImage: UIImage()))
                                }
                            }
                        }
                        
                    } else {
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
            task.resume()
        }
        activityIndicator.stopAnimating()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! GalleryCollectionCell
        cell.imageView.image = images[indexPath.row].webFormatImage
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
