//
//  docType.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 12.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

enum DocType: String, CaseIterable {
    case makeIP = "Документы на регистрацию ИП"
    case deleteIP = "Документы на ликвидацию ИП"
    case usn = "Заявление для перехода на УСН"
    
    enum PositionInSelectView: CaseIterable{
        case left
        case right
    }
    
    var position: PositionInSelectView {
        switch self {
        case .makeIP, .usn:
            return .right
        case .deleteIP:
            return .left
        }
    }
    
    var title: String {
        switch self {
        case .makeIP:
            return "Зарегистрировать ИП"
        case .deleteIP:
            return "Ликвидировать ИП"
        case .usn:
            return "Перейти на УСН (ИП)"
        }
    }
    
    var firstStep: Step {
        switch self {
        case .makeIP:
            return .step1
        case .deleteIP:
            return .step10
        case .usn:
            return .step20
        }
    }
    
    var steps: [Step] {
        switch self {
        case .makeIP:
            return [.step1, .step2, .step3, .step4, .step5]
        case .deleteIP:
            return [.step10]
        case .usn:
            return [.step20]
        }
    }
    
    var collectionName: String {
        switch self {
        case .makeIP:
            return "IP"
        case .deleteIP:
            return "DeleteIP"
        case .usn:
            return "Usn"
        }
    }
    
    var cloudFunctionName: String {
        switch self {
        case .makeIP:
            return "createDocument"
        case .deleteIP:
            return "createDeleteIPDocument"
        case .usn:
            return "createUSN"
        }
    }
    
    var kbk: String {
        switch self {
        case .makeIP:
            return "182 108 07010 01 1000 110"
        case .deleteIP:
            return "182 108 07010 01 1000 110"
        case .usn:
            return ""
        }
    }
    
    var dutyAmount: String {
        switch self {
        case .makeIP:
            return "800.00"
        case .deleteIP:
            return "160.00"
        case .usn:
            return "0.0"
        }
    }
    
    func createNewDoc(id: String, completion: @escaping(() -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        for step in steps {
            for item in step.fields {
                item.save(text: "", id: id, collectionName: collectionName, okveds: [])
            }
        }
        let db = Firestore.firestore()
        switch self {
        case .makeIP:
            db.collection("documents").document(uid).collection("IP").document(id).setData(["mainOkved" : [:] as Any], merge: true) { (error) in
            }
        default:
            break
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        db.collection("documents").document(uid).collection(collectionName).document(id).setData(["docDate" : formatter.string(from: Date())], merge: true) { (error) in
        }
        completion()
    }
    
    func createTextFields(id: String, completion: @escaping ((File) -> Void)) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("documents").document(uid).collection(collectionName).document(id).addSnapshotListener { (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshot: \(error!)")
                return
            }
            if let data = snapshot.data() {
                completion(self.createNewFile(data: data))
            }
        }
    }
    
    private func createNewFile(data: [String : Any]) -> File {
        var newFile = File()
        newFile.lastName = data["lastName"] as? String
        newFile.firstName = data["firstName"] as? String
        newFile.middleName = data["middleName"] as? String
        newFile.sex = data["sex"] as? String
        newFile.citizenship = data["citizenship"] as? String
        newFile.dateOfBirth = data["dateOfBirth"] as? String
        newFile.email = data["email"] as? String
        newFile.phoneNumber = data["phoneNumber"] as? String
        newFile.passportSeries = data["passportSeries"] as? String
        newFile.passportNumber = data["passportNumber"] as? String
        newFile.passportDate = data["passportDate"] as? String
        newFile.passportGiver = data["passportGiver"] as? String
        newFile.passportCode = data["passportCode"] as? String
        newFile.placeOfBirth = data["placeOfBirth"] as? String
        newFile.address = data["address"] as? String
        newFile.inn = data["inn"] as? String
        newFile.snils = data["snils"] as? String
        newFile.taxesSystem = data["taxesSystem"] as? String
        newFile.taxesRate = data["taxesRate"] as? String
        newFile.giveMethod = data["giveMethod"] as? String
        newFile.ogrnip = data["ogrnip"] as? String
        newFile.usnGiveTime = data["usnGiveTime"] as? String
        
        if let mainOkved = data["mainOkved"] as? [String : String] {
            newFile.mainOkved = [OKVED(kod: "", descr: "")]
            for item in mainOkved {
                newFile.mainOkved = [OKVED(kod: item.key, descr: item.value)]
            }
        }
        if let loadedOkveds = data["okveds"] as? [String : String] {
            newFile.okveds = []
            let a = loadedOkveds.sorted { (aDic, bDic) -> Bool in
                return aDic.key < bDic.key
            }
            for item in a {
                let okved = OKVED(kod: item.key, descr: item.value)
                newFile.okveds?.append(okved)
            }
        }
        return newFile
    }
    
    func load(completion: @escaping (([Document]) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("documents").document(uid).collection(collectionName).addSnapshotListener { (querySnapshot, error) in
            var documents = [Document]()
            guard let snapshot = querySnapshot else { return }
            documents.append(Document(id: "", title: "Создать новый комплект документов", date: ""))
            for doc in snapshot.documents {
                let data = doc.data()
                if let lastName = data["lastName"] as? String, let firstName = data["firstName"] as? String, let middleName = data["middleName"] as? String, let date = data["docDate"] as? String {
                    let title = "\(lastName) \(firstName) \(middleName)"
                    
                    documents.append(Document(id: doc.documentID, title: title, date: date))
                }
            }
            completion(documents)
        }
    }
    
    func delete(id: String) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("documents").document(uid).collection(collectionName).document(id).delete()
    }
    
    func sendDocument(id: String, waiting: @escaping (() -> Void), completion: @escaping ((String) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        waiting()
        let functions = Functions.functions()
        functions.httpsCallable(cloudFunctionName).call(["id": id, "uid": uid]) { (result, error) in
            if let text = result?.data as? [String: Any] {
                if let status =  text["data"] as? String {
                    completion(status)
                }
            }
        }
    }
}
