//
//  LoginViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-06-16.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldLoginUsername: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ObjectManager.loadProductsFromJSON()
        textFieldLoginUsername.delegate = self
        textFieldLoginPassword.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        if (textFieldLoginUsername.text == "Admin" && textFieldLoginPassword.text == "admin") {
            self.textFieldLoginUsername.text = nil
            self.textFieldLoginPassword.text = nil
            self.performSegue(withIdentifier: "Login", sender: self)
        } else {
            let alert = UIAlertController(title: "Login Failed", message: "Incorrect username or password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        /*// Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let barViewControllers = segue.destination as! UITabBarController
        let nav = barViewControllers.viewControllers![0] as! UINavigationController
        let destinationViewController = nav.topViewController as! CategoryCollectionViewController*/
    }
 

}
