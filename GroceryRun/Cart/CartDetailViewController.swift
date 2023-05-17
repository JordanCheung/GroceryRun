//
//  CartDetailViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-05-12.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit

class CartDetailViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    
    var quantity:Int64 = 1
    var cartItem: CartItem!
    var itemIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.image = UIImage(data: cartItem!.itemImage!)
        price.text = ObjectManager.formatToCurrency(input: (cartItem.price)!)
        unit.text = cartItem.unit
        quantity = cartItem.quantity
        quantityLabel.text = "\(cartItem.quantity)"
        if ((cartItem.quantity) <= 1) {
            subtractButton.isEnabled = false
        } else if (cartItem.quantity >= 30) {
            addButton.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    
    @IBAction func add(_ sender: UIButton) {
        if cartItem.quantity < 30 {
            quantity += 1
            quantityLabel.text = "\(quantity)"
            subtractButton.isEnabled = true
            if quantity >= 30 {
                addButton.isEnabled = false
            }
        }
    }
    @IBAction func subtract(_ sender: UIButton) {
        if cartItem.quantity > 1 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
            addButton.isEnabled = true
            if quantity <= 1 {
                subtractButton.isEnabled = false
            }
        }
    }
    
    @IBAction func modifyCartItem(_ sender: UIBarButtonItem) {
        cartItem.quantity = quantity
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
