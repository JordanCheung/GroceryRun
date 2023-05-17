//
//  ObjectManager.swift
//  GroceryRun
//
//  Created by Jordan on 2019-05-23.
//  Copyright © 2019 Jordan. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class ObjectManager {
    
    static func formatToCurrency(input: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let formattedPrice = numberFormatter.string(from: input)
        return formattedPrice!
    }
    
    static func loadProductsFromJSON()  {
        clearItems(entity: "Product")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let path = Bundle.main.path(forResource: "product", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                
                // Access JSON Array
                if let arr = jsonObj.array {
                    for dict in arr {
                        // Assigning attributes
                        let product = Product(context: context)
                        if let itemImage = dict["itemImage"].string {
                            let image = UIImage(named: itemImage)
                            let imageData = image!.pngData()
                            product.itemImage = imageData
                        }
                        if let name = dict["itemName"].string {
                            product.itemName = name
                        }
                        if let category = dict["category"].string {
                            product.category = category
                        }
                        if let price = dict["price"].double {
                            product.price = NSDecimalNumber(decimal: Decimal(price))
                        }
                        if let unit = dict["unit"].string {
                            product.unit = unit
                        }
                        if let quantity = dict["quantity"].int64 {
                            product.quantity = quantity
                        }
                    }
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        }
    }
    
    static func getCartItems() -> [CartItem] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var cartItems: [CartItem] = []
        do {
            cartItems = try context.fetch(CartItem.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        return cartItems
    }
    
    static func clearItems(entity: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Batch Delete Request Error: \(batchDeleteRequest)")
        }
    }
    
    static func isItemInCart(itemName: String) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CartItem")
        fetchRequest.predicate = NSPredicate(format: "itemName == %@", itemName)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    static func getItemInCart(itemName: String) -> CartItem {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CartItem>(entityName: "CartItem")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "itemName == %@", itemName)
        var result: CartItem?
        do {
            result = try context.fetch(fetchRequest).first
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return result!
    }
    
}
