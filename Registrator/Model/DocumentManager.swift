//
//  IPManager.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 28.07.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import UIKit
import Firebase

class DocumentManager {
    private let db = Firestore.firestore()
    private let id: String?
    var documents: [Document] = []
    
    init(id: String?) {
        self.id = id
    }
    
    func saveDocument(textFields: [[String]], id: String, okveds: [String : String]?, giveMethod: String) {
        db.collection("documents").document("CurrentUser").collection("IP").document(id).setData(
            [
                "lastName" : textFields[0][0],
                "firstName" : textFields[0][1],
                "middleName" : textFields[0][2],
                "sex" : textFields[0][3],
                "citizenship" : textFields[0][4],
                "dateOfBirth" : textFields[0][5],
                "email" : textFields[0][6],
                "phoneNumber" : textFields[0][7],
                "passportSeries" : textFields[1][0],
                "passportNumber" : textFields[1][1],
                "passportDate" : textFields[1][2],
                "passportGiver" : textFields[1][3],
                "passportCode" : textFields[1][4],
                "placeOfBirth" : textFields[1][5],
                "address" : textFields[1][6],
                "inn" : textFields[1][7],
                "snils" : textFields[1][8],
                "okveds" : [:],
                "taxesSystem" : textFields[3][0],
                "taxesRate" : textFields[3][1],
                "giveMethod" : giveMethod
            ], merge: true){ (error) in
                self.db.collection("documents").document("CurrentUser").collection("IP").document(id).setData(["okveds" : okveds as Any], merge: true)
            }

    }
    
    func createTextFields(id: String) -> [String] {
        var textFields: [String] = []
        db.collection("documents").document("CurrentUser").collection("IP").document(id).getDocument { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshot: \(error!)")
                return
            }
            if let data = snapshot.data() {
                textFields.append(data["lastName"] as! String)
                textFields.append(data["firstName"] as! String)
                textFields.append(data["middleName"] as! String)
                textFields.append(data["sex"] as! String)
                textFields.append(data["citizenship"] as! String)
                textFields.append(data["dateOfBirth"] as! String)
                textFields.append(data["passportSeries"] as! String)
                textFields.append(data["passportNumber"] as! String)
                textFields.append(data["passportDate"] as! String)
                textFields.append(data["passportGiver"] as! String)
                textFields.append(data["passportCode"] as! String)
                textFields.append(data["placeOfBirth"] as! String)
                textFields.append(data["address"] as! String)
                textFields.append(data["inn"] as! String)
                textFields.append(data["snils"] as! String)
                textFields.append(data["email"] as! String)
                textFields.append(data["phoneNumber"] as! String)
            }
        }
        return textFields
    }
    
    func loadDocuments() {
        print("start")
        self.db.collection("documents").document("CurrentUser").collection("IP").getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else { return }
            for doc in snapshot.documents {
                let data = doc.data()
                let title = "\(data["lastName"] as! String) \(data["firstName"] as! String) \(data["middleName"] as! String)"
                let date = data["dateOfBirth"] as! String
                self.documents.append(Document(id: doc.documentID, title: title, date: date))
                
            }
        }
    }
}
