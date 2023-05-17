//
//  ProductTableViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-05-06.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController, UISearchBarDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData(category: self.navigationItem.title!)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        if !searchText.isEmpty {
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            let category = self.navigationItem.title
            fetchRequest.predicate = NSPredicate(format: "itemName CONTAINS[c] %@ AND category == %@", searchText, category!)
            do {
                products = try context.fetch(fetchRequest)
                tableView.reloadData()
            } catch {
                print("error fetching")
            }
        } else {
            getData(category: self.navigationItem.title!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        getData(category: self.navigationItem.title!)
        //products = ObjectManager.loadProductsFromJSON(category: self.navigationItem.title!)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        // Configure the cell...
        if let productCell = cell as? ProductTableViewCell {
            productCell.productImage.image = UIImage(data: products[indexPath.row].itemImage!)
            productCell.productName.text = "\(products[indexPath.row].itemName ?? "Name not found")"
            productCell.price.text = ObjectManager.formatToCurrency(input: products[indexPath.row].price!)
            productCell.unit.text = "\(products[indexPath.row].unit ?? "Unit not found")"
            if (ObjectManager.isItemInCart(itemName: products[indexPath.row].itemName!)) {
                productCell.cartImage.image = UIImage(named: "Cart.png")
            } else {
                productCell.cartImage.image = nil
            }
            return productCell
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let viewController = segue.destination as? ProductDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        guard let selectedProductCell = sender as? ProductTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        guard let indexPath = tableView.indexPath(for: selectedProductCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedProduct = products[indexPath.row]
        viewController.product = selectedProduct
        viewController.navigationItem.title = selectedProduct.itemName
        if ObjectManager.isItemInCart(itemName: selectedProduct.itemName!) {
            let existingItem = ObjectManager.getItemInCart(itemName: selectedProduct.itemName!)
            viewController.navigationItem.rightBarButtonItem?.title = "Modify"
            viewController.isInCart = true
            viewController.cartItem = existingItem
        } else {
            viewController.navigationItem.rightBarButtonItem?.title = "Add To Cart"
            viewController.isInCart = false
        }
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    
    // MARK: - Private Functions
    
    private func getData(category: String) {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        do {
            let results = try context.fetch(fetchRequest)
            products = sortByName(products: results)
        } catch {
            print("error fetching")
        }
    }
    
    private func sortByName(products: [Product]) -> [Product] {
        return products.sorted(by: sorterForTitlesAlphabetic)
    }
    
    private func sorterForTitlesAlphabetic(first: Product, second: Product) -> Bool {
        return first.itemName! < second.itemName!
    }
}
