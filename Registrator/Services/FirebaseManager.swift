//
//  FirebaseService.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 25.09.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseManager {
    let db = Firestore.firestore()
    func load(completion: @escaping (([Document]) -> Void)) {
        self.db.collection("documents").document("CurrentUser").collection("IP").addSnapshotListener { (querySnapshot, error) in
            var documents = [Document]()
            guard let snapshot = querySnapshot else { return }
            documents.append(Document(id: "", title: "Создать новый комплект документов", date: ""))
            for doc in snapshot.documents {
                let data = doc.data()
                if let lastName = data["lastName"] as? String, let firstName = data["firstName"] as? String, let middleName = data["middleName"] as? String, let date = data["dateOfBirth"] as? String {
                    let title = "\(lastName) \(firstName) \(middleName)"
                    
                    documents.append(Document(id: doc.documentID, title: title, date: date))
                }
            }
            completion(documents)
        }
    }
    
    func createTextFields(id: String, completion: @escaping ((File, [String]) -> Void)) {
        db.collection("documents").document("CurrentUser").collection("IP").document(id).addSnapshotListener { (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshot: \(error!)")
                return
            }
            var newFile = File()
            if let data = snapshot.data() {
                newFile.lastName = data["lastName"] as! String
                newFile.firstName = data["firstName"] as! String
                newFile.middleName = data["middleName"] as! String
                newFile.sex = data["sex"] as! String
                newFile.citizenship = data["citizenship"] as! String
                newFile.dateOfBirth = data["dateOfBirth"] as! String
                newFile.email = data["email"] as! String
                newFile.phoneNumber = data["phoneNumber"] as! String
                newFile.passportSeries = data["passportSeries"] as! String
                newFile.passportNumber = data["passportNumber"] as! String
                newFile.passportDate = data["passportDate"] as! String
                newFile.passportGiver = data["passportGiver"] as! String
                newFile.passportCode = data["passportCode"] as! String
                newFile.placeOfBirth = data["placeOfBirth"] as! String
                newFile.address = data["address"] as! String
                newFile.inn = data["inn"] as! String
                newFile.snils = data["snils"] as! String
                newFile.taxesSystem = data["taxesSystem"] as! String
                newFile.taxesRate = data["taxesRate"] as! String
                newFile.giveMethod = data["giveMethod"] as! String
    
                let loadedOkveds = data["okveds"] as! [String : String]
                var okvedsToDisplay: [String] = []
                
                for item in loadedOkveds {
                    let okved = OKVED(kod: item.key, descr: item.value)
                    newFile.okveds.append(okved)
                    okvedsToDisplay.append("\(item.key). \(item.value)")
                }
                completion(newFile, okvedsToDisplay)
            }
        }
    }
    
    func deleteDocument(id: String) {
        db.collection("documents").document("CurrentUser").collection("IP").document(id).delete()
    }
}
