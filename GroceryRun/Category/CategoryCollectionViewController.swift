//
//  CategoryCollectionViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-05-05.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit
import CoreData
import SWRevealViewController

private let reuseIdentifier = "cell"

struct Category {
    var name: String
    var image: UIImage?
}

let spacing: CGFloat = 5
let defaultImage = UIImage(named: "placeholder.png")

class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories: [Category] = []
    var currentIndex = 0
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories.append(Category(name: "Alcohol", image: UIImage(named: "Alcohol.jpg")))
        categories.append(Category(name: "Bakery", image: UIImage(named: "Bakery.jpg")))
        categories.append(Category(name: "Beverage", image: UIImage(named: "Beverage.jpg")))
        categories.append(Category(name: "Canned Food", image: UIImage(named: "Canned Food.jpg")))
        categories.append(Category(name: "Dairy", image: UIImage(named: "Dairy.jpg")))
        categories.append(Category(name: "Dried Food", image: UIImage(named: "Dried Food.jpg")))
        categories.append(Category(name: "Frozen Food", image: UIImage(named: "Frozen Food.jpg")))
        categories.append(Category(name: "Meat", image: UIImage(named: "Meat.jpg")))
        categories.append(Category(name: "Produce", image: UIImage(named: "Produce.jpg")))
        categories.append(Category(name: "Snacks", image: UIImage(named: "Snacks.jpg")))
        sideMenus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        guard let tableViewController = segue.destination as? ProductTableViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let selectedCategory = categories[currentIndex].name
        tableViewController.navigationItem.title = selectedCategory
        fetchRequest.predicate = NSPredicate(format: "category == %@", selectedCategory)
        do {
            tableViewController.products = try context.fetch(fetchRequest)
        } catch {
            print("error fetching")
        }
    }
 

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        if let customCell = cell as? CategoryCollectionViewCell {
            customCell.categoryName.text = "\(categories[indexPath.row].name)"
            customCell.categoryImage.image = categories[indexPath.row].image
            return customCell
        }
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orientation = UIApplication.shared.statusBarOrientation
        let screenSize = UIScreen.main.bounds
        var numOfCell: Int
        if(orientation == .landscapeLeft || orientation == .landscapeRight)
        {
            numOfCell = 3 //Number of items you want
            let spaceOfCell:CGFloat = (CGFloat((numOfCell + 1)*2)) //Space between Cells
            //print(Int(screenSize.width - spaceOfCell))
            
            return CGSize(width: Int(screenSize.width - spaceOfCell) / numOfCell, height: Int(collectionView.frame.width - spaceOfCell) / numOfCell)
        }
        else{
            numOfCell = 2 //Number of items you want
            let spaceOfCell:CGFloat = (CGFloat((numOfCell + 1)*2)) //Space between Cells
            return CGSize(width: Int(screenSize.width - spaceOfCell) / numOfCell, height: Int(collectionView.frame.width - spaceOfCell) / numOfCell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func sideMenus() {
        if self.revealViewController() != nil {

            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    /*override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
    
    func setCollectionViewItemSize(size: CGSize) -> CGSize {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let width = (size.width - 1 * spacing) / 2
            return CGSize(width: width, height: width)
        } else {
            let width = (size.width - 2 * spacing) / 3
            return CGSize(width: width, height: width)
        }
    }*/

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}
