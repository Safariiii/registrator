//
//  IFNS.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 20.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

struct IFNS {
    
    init(ifnsDetails: IfnsDetails?, payeeDetails: PayeeDetails?, docType: DocType) {
        self.address = ifnsDetails?.ifnsAddr ?? ""
        self.title = ifnsDetails?.ifnsName ?? ""
        self.workHours = ifnsDetails?.ifnsComment ?? ""
        self.phone = ifnsDetails?.ifnsPhone ?? ""
        self.code = ifnsDetails?.ifnsCode ?? ""
        self.amount = docType.dutyAmount
        self.bank = payeeDetails?.bankName ?? ""
        self.bik = payeeDetails?.bankBic ?? ""
        self.accountNumber = payeeDetails?.payeeAcc ?? ""
        self.receiverTitle = payeeDetails?.payeeName?.replacingOccurrences(of: "Управление Федерального казначейства", with: "УФК").replacingOccurrences(of: "Межрайонная инспекция Федеральной налоговой службы", with: "МИФНС России") ?? ""
        self.receiverInn = payeeDetails?.payeeInn ?? ""
        self.receiverKpp = payeeDetails?.payeeKpp ?? ""
        self.kbk = docType.kbk
    }
    
    var address = ""
    var title = ""
    var workHours = ""
    var phone = ""
    var code = ""
    var amount = ""
    var bank = ""
    var bik = ""
    var accountNumber = ""
    var receiverTitle = ""
    var receiverInn = ""
    var receiverKpp = ""
    var kbk = ""
    var oktmo = ""
    
    func save(collectionName: String, id: String) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("documents").document(uid).collection(collectionName).document(id).setData(["ifns" : ["title": title, "code": code, "address": address, "workHours": workHours, "phone": phone, "amount" : amount, "bank": bank, "bik": bik, "accountNumber": accountNumber, "receiverTitle": receiverTitle, "receiverInn": receiverInn, "receiverKpp": receiverKpp, "kbk": kbk, "oktmo": oktmo]], merge: true)
    }
}
