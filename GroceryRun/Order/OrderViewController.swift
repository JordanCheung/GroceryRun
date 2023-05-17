//
//  OrderViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-05-28.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cart:[CartItem] = []
    
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTableView.delegate = self
        orderTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        total.text = ObjectManager.formatToCurrency(input: NSNumber(value: getSalesTotal(cart: cart)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        if let orderCell = cell as? OrderTableViewCell {
            orderCell.productName.text = cart[indexPath.row].itemName
            orderCell.price.text = ObjectManager.formatToCurrency(input: cart[indexPath.row].price!)
            orderCell.quantity.text = String(cart[indexPath.row].quantity)
            return orderCell
        }
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let viewController = segue.destination as? PaymentViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        viewController.total = total.text
    }
 
    
    // MARK: - Private Functions
    
    private func getSalesTotal(cart: [CartItem]) -> Double {
        var total: Double = 0
        for item in cart {
            let individualPrice = item.price!.doubleValue
            let itemQuantity = Double(item.quantity)
            let priceForItems = individualPrice*itemQuantity
            total += priceForItems
        }
        return total
    }

}
