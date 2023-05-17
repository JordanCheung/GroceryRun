//
//  PaymentViewController.swift
//  GroceryRun
//
//  Created by Jordan on 2019-05-29.
//  Copyright © 2019 Jordan. All rights reserved.
//

import UIKit

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}

class PaymentViewController: UIViewController, UITextFieldDelegate {
    
    var total:String!
    
    @IBOutlet weak var cardholderName: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expiryDate: UITextField!
    @IBOutlet weak var securityCode: UITextField!
    @IBOutlet weak var totalSales: UILabel!
    
    private var datePicker: MonthYearPickerView?
    private var dateString:String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        totalSales.text = total
        self.cardNumber.keyboardType = .decimalPad
        self.securityCode.keyboardType = .decimalPad
        initializeDatePicker()
        cardNumber.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        cardNumber.delegate = self
        securityCode.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        securityCode.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    
    @IBAction func processPayment(_ sender: UIButton) {
        var errorMessages:String = ""
        
        // Check for cardholder name
        if (cardholderName.text == "") {
            errorMessages = errorMessages + ("\nCardholder name is not valid.")
        }
        
        // Check for card number
        if (cardNumber.text!.count != 16) {
            errorMessages = errorMessages + ("\nCard number is not valid.")
        }
        
        // Check for expiry date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        let enteredDate = dateFormatter.date(from: expiryDate.text!)
        let now = Date()
        if (enteredDate! < now && enteredDate?.month != now.month) {
            errorMessages = errorMessages + ("\nCredit card has expired.")
        }
        
        // Check for security code
        if (securityCode.text!.count != 3) {
            errorMessages = errorMessages + ("\nSecurity code is not valid.")
        }
        
        if errorMessages != "" {
            var message = "Please fix the following error:\n"
            message = message + errorMessages
            let alert = UIAlertController(title: "Payment Error.", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Payment Successful", message: "Your payment of \(total!) is successful.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                ObjectManager.clearItems(entity: "CartItem")
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength:Int?
        if textField == cardNumber {
            maxLength = 16
        } else if textField == securityCode {
            maxLength = 3
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength!
    }
    
    // MARK: - Private Function
    
    private func initializeDatePicker() {
        
        datePicker = MonthYearPickerView()
        datePicker?.onDateSelected = { (month: Int, year: Int) in
            self.expiryDate.text = String(format: "%02d/%d", month, year)
        }
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(PaymentViewController.viewTapped(gestureRecognizer:)))
        expiryDate.inputView = datePicker
        let currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        expiryDate.text = String(format: "%02d/%d", currentMonth, currentYear)
        view.addGestureRecognizer(tapGuesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
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
