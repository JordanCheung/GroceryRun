//
//  ProductDetailViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-04-30.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit
import CoreData

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    
    var quantity:Int = 1
    var product: Product!
    var cartItem: CartItem?
    var isInCart: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.image = UIImage(data: product.itemImage!)
        price.text = ObjectManager.formatToCurrency(input: (product.price)!)
        unit.text = product.unit
        if isInCart {
            quantityLabel.text = String(cartItem!.quantity)
            quantity = Int(cartItem!.quantity)
        } else {
            quantityLabel.text = "1"
        }
        if (quantity <= 1) {
            subtractButton.isEnabled = false
        } else if (quantity >= 30) {
            addButton.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    
    /*
     * Add button tapped, quantity increases
     */
    @IBAction func add(_ sender: UIButton) {
        if quantity < 30 {
            quantity += 1
            quantityLabel.text = String(quantity)
            subtractButton.isEnabled = true
            if quantity >= 30 {
                addButton.isEnabled = false
            }
        }
    }
    
    /*
     * Subtract button tapped, quantity decreases
     */
    @IBAction func subtract(_ sender: UIButton) {
        if quantity > 1 {
            quantity -= 1
            quantityLabel.text = String(quantity)
            addButton.isEnabled = true
            if quantity <= 1 {
                subtractButton.isEnabled = false
            }
        }
    }
    
    @IBAction func addToCart(_ sender: UIBarButtonItem) {
        // If item exist in cart, then modify the quantity
        if isInCart {
            cartItem?.quantity = Int64(quantity)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let _ = navigationController?.popViewController(animated: true)
        } else {
            // If item does not exist in cart, then create a new item in the cart
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let cartItem = CartItem(context: context)
            cartItem.itemImage = product.itemImage
            cartItem.itemName = product.itemName
            cartItem.price = product.price
            cartItem.unit = product.unit
            cartItem.quantity = Int64(quantity)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let _ = navigationController?.popViewController(animated: true)
        }
    }

}


