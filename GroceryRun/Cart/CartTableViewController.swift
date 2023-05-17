//
//  CartTableViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-05-12.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit
import CoreData

class CartTableViewController: UITableViewController, UISearchBarDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cart:[CartItem] = []
    
    @IBOutlet weak var clearAllButton: UIBarButtonItem!
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cart = ObjectManager.getCartItems()
        tableView.reloadData()
        enableBarButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Clear All", message: "Are you sure you want to remove all items in the cart?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
            //Clear items
            ObjectManager.clearItems(entity: "CartItem")
            self.cart = ObjectManager.getCartItems()
            self.tableView.reloadData()
            self.clearAllButton.isEnabled = false
            self.checkoutButton.isEnabled = false
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)

        // Configure the cell...
        if let cartCell = cell as? CartTableViewCell {
            cartCell.productImage.image = UIImage(data: (cart[indexPath.row].itemImage!))
            cartCell.productName.text = "\(cart[indexPath.row].itemName!)"
            cartCell.price.text = ObjectManager.formatToCurrency(input: cart[indexPath.row].price!)
            cartCell.unit.text = "\(cart[indexPath.row].unit!)"
            cartCell.quantity.text = "\(cart[indexPath.row].quantity)"
            return cartCell
        }

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let productToRemove = cart[indexPath.row]
            context.delete(productToRemove)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                cart = try context.fetch(CartItem.fetchRequest())
                enableBarButtons()
            } catch {
                print("fetch failed")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        
        case "ModifyCart":
            guard let viewController = segue.destination as? CartDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCartCell = sender as? CartTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedCartCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedCartItem = cart[indexPath.row]
            viewController.cartItem = selectedCartItem
            viewController.navigationItem.title = selectedCartItem.itemName
            viewController.itemIndex = indexPath.row
        
        case "OrderSummary":
            guard let viewController = segue.destination as? OrderViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            viewController.cart = cart
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        if !searchText.isEmpty {
            let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "itemName CONTAINS[c] %@",searchText)
            do{
                cart = try context.fetch(fetchRequest)
                tableView.reloadData()
            }catch{
                print("error fetching")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        cart = ObjectManager.getCartItems()
        tableView.reloadData()
    }
    
    // MARK: - Private Functions
    
    /*
     * Enables clear all button and checkout button if there is an item in the cart
     */
    private func enableBarButtons() {
        if cart.count > 0 {
            clearAllButton.isEnabled = true
            checkoutButton.isEnabled = true
        } else {
            clearAllButton.isEnabled = false
            checkoutButton.isEnabled = false
        }
    }
}
