//
//  ViewController.swift
//  TriviaApp
//
//  Created by tashya on 2/8/18.
//  Copyright © 2018 InterviewTest. All rights reserved.
//

import UIKit
import Alamofire

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    override func awakeFromNib() {
        imgBackground.layer.masksToBounds = true
        imgBackground.layer.cornerRadius = 0.05 * imgBackground.frame.height
    }
    
}

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    var data: NSDictionary?
    var dataCategory: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataCategory()
        self.title = "Select Category"

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getDataCategory(){
        Alamofire.request("https://opentdb.com/api_category.php").responseJSON { (response) in
            if let json = response.result.value {
//                print(json)
                self.data = json as? NSDictionary
                self.dataCategory = self.data!["trivia_categories"] as? NSArray
                print("JSON: \(String(describing: self.dataCategory))")
                self.collectionView.reloadData()
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let row = dataCategory?.count, row > 0 {
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let dict = self.dataCategory![indexPath.row] as! NSDictionary
        let id = dict["id"] as! Int
        cell.lblCategoryName.text = dict["name"] as? String
        switch id {
        case 9:
            cell.imgBackground.image = UIImage(named: "imgKnowledge")
            cell.imgIcon.image = UIImage(named: "iconGeneral")
        case 10:
            cell.imgBackground.image = UIImage(named: "imgBooks")
            cell.imgIcon.image = UIImage(named: "iconBooks")
        case 11:
            cell.imgBackground.image = UIImage(named: "imgFilm")
            cell.imgIcon.image = UIImage(named: "iconFilm")
        case 12:
            cell.imgBackground.image = UIImage(named: "imgMusic")
            cell.imgIcon.image = UIImage(named: "iconMusic")
        case 13:
            cell.imgBackground.image = UIImage(named: "imgGames")
            cell.imgIcon.image = UIImage(named: "iconGames")
        case 14:
            cell.imgBackground.image = UIImage(named: "imgTV")
            cell.imgIcon.image = UIImage(named: "iconTV")
        case 15:
            cell.imgBackground.image = UIImage(named: "imgComputer")
            cell.imgIcon.image = UIImage(named: "iconComputer")
        case 16:
            cell.imgBackground.image = UIImage(named: "imgSelebrities")
            cell.imgIcon.image = UIImage(named: "iconStar")
        case 17:
            cell.imgBackground.image = UIImage(named: "imgHistory")
            cell.imgIcon.image = UIImage(named: "iconHistory")
        case 18:
            cell.imgBackground.image = UIImage(named: "imgAnimals")
            cell.imgIcon.image = UIImage(named: "iconAnimals")
        default:
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width / 2) - 15
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }


}

