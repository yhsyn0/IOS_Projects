//
//  ViewController.swift
//  SQL
//
//  Created by hsyn on 17.11.2021.
//

import UIKit
import SQLite

class ViewController: UIViewController, UITextFieldDelegate
{
    let firstRun = UserDefaults.standard.bool(forKey: "firstRun") as Bool
    var database: Connection!

    let usersTable = Table("Ders_odev")
    let key = Expression<String>("key")
    let value = Expression<String>("value")
    
    @IBOutlet weak var textF: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        textF.delegate = self
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            
            if firstRun
            {
                
            }
            else
            {
                createTable()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    @IBAction func createTable()
    {
        let createTable = self.usersTable.create { (table) in
            table.column(self.key, unique: true)
            table.column(self.value)
        }
        
        let insertUser = self.usersTable.insert(self.key <- "bil359", self.value <- "Hello World from database")
        
        do {
            try self.database.run(createTable)
            try self.database.run(insertUser)
            print("Created Table")
        }
        catch {
            print(error)
        }
        
        UserDefaults.standard.set(true, forKey: "firstRun")
    }
    
    @IBAction func listUsers()
    {
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("Key: \(user[self.key]), Value: \(user[self.value])")
            }
        }
        catch {
            print(error)
        }
    }
    @IBAction func searchButton(_ sender: UIButton)
    {
        if textF.text! == ""
        {
            return;
        }
        
        var resultValue : String
        resultValue = ""
        
        do
        {
            let rows = try self.database.prepare(self.usersTable.filter(key == textF.text!))
            for row in rows
            {
                resultValue = row[self.value]
            }
        }
        catch
        {
            print(error)
        }
        
        if resultValue == ""
        {
            let alert = UIAlertController(title: "Nothing Found",
                          message: nil,
                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return;
        }
        
        else
        {
            let alert = UIAlertController(title: "Results\n",
                          message: "",
                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let messageText = NSMutableAttributedString(
                string: "Key    : \(textF.text!)\nValue : \(resultValue)",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .body),
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ]
            )
             
            alert.setValue(messageText, forKey: "attributedMessage")
            present(alert, animated: true, completion: nil)
            
            return;
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return textF.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
}

