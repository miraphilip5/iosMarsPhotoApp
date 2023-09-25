//
//  FavPhotosTableTableViewController.swift
//  MarsPhotoApp-MiraPhilip
//
//  Created by Mira Philip on 2023-07-23.
//

import UIKit

class FavPhotosTableTableViewController: UITableViewController {

    var favPhotos : [Photo] = [Photo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.shared.getAllFavPhotos { array in
            self.favPhotos = array
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        FirebaseManager.shared.getAllFavPhotos { array in
            self.favPhotos = array
            self.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favPhotos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = favPhotos[indexPath.row].rover.name
        cell.detailTextLabel?.text = favPhotos[indexPath.row].earth_date

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavPhotoDetail"){
            let photoDetailVC = segue.destination as! FavPhotoDetailViewController
            photoDetailVC.photo = favPhotos[tableView.indexPathForSelectedRow!.row]
        }
    }
    

}
