//
//  FirebaseManager.swift
//  MarsPhotoApp-MiraPhilip
//
//  Created by Mira Philip on 2023-07-23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class FirebaseManager {
    static var shared  = FirebaseManager()
    let db = Firestore.firestore()
    
    func insertNewFavPhoto(p: Photo ){
        
        let data = [
            "img_src": p.img_src,
            "earth_data": p.earth_date,
            "camera_name": p.camera.name,
            "rover_name": p.rover.name
        ]
        
        let ref = db.collection("FavPhotos").document()
        ref.setData(data) { error in
            print(error ?? " error ")
        }
        
    }
    
    func getAllFavPhotos( completion: @escaping ([Photo])->Void){
        
        var photos = [Photo]()
        
         db.collection("FavPhotos").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let firestoreMap = document.data()
                    let i = firestoreMap["img_src"]!
                    let d = firestoreMap["earth_data"]!
                    let c = firestoreMap["camera_name"]!
                    let r = firestoreMap["rover_name"]!
            
                    photos.append(Photo(imgSrc: i as! String, earthDate: d as! String, cameraName: c as! String, roverName: r as! String))
                }
                completion(photos)
            }
        }
        
    }
}
