//
//  NetworkingManager.swift
//  MarsPhotoApp-MiraPhilip
//
//  Created by Mira Philip on 2023-07-23.
//

import Foundation
import UIKit

protocol NetworkingDelegate {
    
    func networkingDidFinishWithPhotos(allPhotos: [Photo])
    func netwokingDidFinishWithoutPhotos()
    
    func networkingDidFinishWithDownloadImage(image: UIImage)
    func networkingDidFinishWithoutDownloadImage()

}

class NetworkingManager {
    
    public static var shared = NetworkingManager()
    var delegate : NetworkingDelegate? = nil
    
    func getPhotos( earthDate : String, rover: String ){
        var photosArray = [Photo]()
        let API_KEY = "LydOC9RgkyBQvYG4ausBm07DpHOsdZow7Eomu1cc"
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos?earth_date=\(earthDate)&api_key=\(API_KEY)"
        print(urlString)
        if let urlObject = URL(string: urlString){
            let task = URLSession.shared.dataTask(with: urlObject) { data, response, error in
                if error != nil {
                    self.delegate?.netwokingDidFinishWithoutPhotos()
                    return
                        }
                guard let httpResponse = response as? HTTPURLResponse,
                           (200...299).contains(httpResponse.statusCode) else {
                    self.delegate?.netwokingDidFinishWithoutPhotos()
                    return
                       }
                
                let decoder = JSONDecoder()
                do {
                    let photosData = try decoder.decode(Photos.self, from: data!)
                    for photo in photosData.photos {
                        photosArray.append(Photo(imageId: photo.id, imgSrc: photo.img_src, earthDate: photo.earth_date, cameraName: photo.camera.name, roverName: photo.rover.name))
                    }
                   
                    DispatchQueue.main.async {
                        self.delegate?.networkingDidFinishWithPhotos(allPhotos: photosArray)
                    }

                } catch let error {
                    print("Error decoding JSON: \(error)")
                }
            }
            task.resume()
        }
    }
    
    
    func getImage( imgSrc: String ) {
        if let urlObject = URL(string: imgSrc){
            let task = URLSession.shared.dataTask(with: urlObject) { data, response, error in
                if error != nil {
                    self.delegate?.networkingDidFinishWithoutDownloadImage()
                    return
                        }
                guard let httpResponse = response as? HTTPURLResponse,
                           (200...299).contains(httpResponse.statusCode) else {
                    self.delegate?.networkingDidFinishWithoutDownloadImage()
                    return
                       }
                do {
                    if let imgData = data {
                        let image = UIImage(data: imgData)
                        DispatchQueue.main.async {
                            self.delegate?.networkingDidFinishWithDownloadImage(image: image!)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}

