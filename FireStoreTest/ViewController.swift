//
//  ViewController.swift
//  FireStoreTest
//
//  Created by Ashish Kumar Mourya on 23/01/18.
//  Copyright © 2018 Ashish Kumar Mourya. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var db:Firestore!
    var userArray = [user]()
  
    
    @IBOutlet weak var tableViewFire: UITableView!
    
    //MARK:- View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        loadData()
        checkForUpdate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.userArray.description)
    }
    
    
    //MARK:-
    func loadData(){
        db.collection("UserDetail").getDocuments(completion: { (querySnapShot, error) in
            if let error = error {
                print(error.localizedDescription)
            }  else {
                self.userArray = (querySnapShot?.documents.flatMap({
                    user(dictionay: $0.data())
                }))!
                self.tableViewFire.reloadData()
            }
        }
        )
    }
    
    
    func checkForUpdate(){
        db.collection("UserDetail").whereField("date", isGreaterThan: Date()).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                return
            }
            snapshot.documentChanges.forEach({ (diff) in
                if diff.type == .added{
                    self.userArray.append(user(dictionay: diff.document.data())!)
                    DispatchQueue.main.async {
                        self.tableViewFire.reloadData()
                    }
                }
            })
        }
    }
    
    //MARK:-
    @IBAction func AddBarButton(_ sender: Any) {
        let composerAlert = UIAlertController(title: "Message", message: "Enter Fields", preferredStyle: .alert)
        composerAlert.addTextField(configurationHandler: {(textfield:UITextField) in
            textfield.placeholder = "Enter Name"
        })
        composerAlert.addTextField(configurationHandler: {(textfield:UITextField) in
            textfield.placeholder = "Enter Address"
        })
        composerAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        composerAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: {(action:UIAlertAction) in
            if let name = composerAlert.textFields?.first?.text, let address = composerAlert.textFields?.last?.text {
                let newUser = user(name: name, address: address, timestamp: Date())
                var ref:DocumentReference? = nil
                ref = self.db.collection("UserDetail").addDocument(data: newUser.dictionary) {
                    error in
                    if let error = error {
                        print(error.localizedDescription)
                
                    } else {
                        print("Document added: \(String(describing: ref?.documentID))")
                    }
                }
            }
        }))
        self.present(composerAlert, animated: true, completion: nil)
    }
    
    
    //MARK:- Table view delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userArray.count > 0{
            return userArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userDetail = userArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        cell?.textLabel?.text = userDetail.name
        return cell!
    }
    
    
    
    
    
    
    
}

