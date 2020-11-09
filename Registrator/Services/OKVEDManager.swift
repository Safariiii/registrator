//
//  OKVEDManager.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 06.08.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import RxSwift

fileprivate let versionURL = "https://apidata.mos.ru/v1/datasets/2745/?api_key=6a83c5ad02350635629ea3628783ac90"
fileprivate let dataURL = "https://apidata.mos.ru/v1/datasets/2745/rows?api_key=6a83c5ad02350635629ea3628783ac90"

class OKVEDManager {
    var realm = try! Realm()
    
    static var isUpdating = false
    static var subject = PublishSubject<Bool>()
    
    func checkForUpdates() {
        if let date = UserDefaults.standard.string(forKey: "okvedDate") {
            Alamofire.request(versionURL, method: .get).responseJSON { (response) in
                if response.result.isSuccess {
                    let jsonResponse = JSON(response.result.value!)
                    let versionDate = jsonResponse["VersionDate"].stringValue
                    if date != versionDate {
                        self.refreshOkveds(versionDate: versionDate)
                    }
                }
            }
        } else {
            Alamofire.request(versionURL, method: .get).responseJSON { (response) in
                if response.result.isSuccess {
                    let jsonResponse = JSON(response.result.value!)
                    let versionDate = jsonResponse["VersionDate"].stringValue
                    self.refreshOkveds(versionDate: versionDate)
                }
            }
        }
    }
    
    let task = UIApplication.shared.beginBackgroundTask(){}
    
    private func refreshOkveds(versionDate: String) {
        OKVEDManager.isUpdating = true
        let cat = realm.objects(Class.self)
        do {
            try realm.write {
                for item in cat {
                    for i in item.codes {
                        self.realm.delete(i)
                    }
                    self.realm.delete(item)
                }
            }
            getOkvedClasses()
            let queue = DispatchQueue(label: "okvedQueue")
            queue.async {
                self.getOkveds(versionDate: versionDate)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getOkvedClasses() {
        for singleClass in Constants.okvedClasses {
            let newClass = Class()
            newClass.code = singleClass[0]
            newClass.descr = singleClass[1]
            do {
                try self.realm.write {
                    self.realm.add(newClass)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func getOkveds(versionDate: String) {
        Alamofire.request(dataURL, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let jsonResponse = JSON(response.result.value!)
                for i in 0..<jsonResponse.count {
                    self.addOkvedsToRealm(i: i, jsonResponse: jsonResponse)
                }
                UserDefaults.standard.setValue(versionDate, forKey: "okvedDate")
                OKVEDManager.isUpdating = false
                OKVEDManager.subject.onNext(OKVEDManager.isUpdating)
                UIApplication.shared.endBackgroundTask(self.task)
            } else {
                print(response)
            }
        }
    }
    
    private func addOkvedsToRealm(i: Int, jsonResponse: JSON) {
        let kod = jsonResponse[i]["Cells"]["Kod"].stringValue
        if let range = Range(NSRange(location: 0, length: 2), in: kod) {
            if kod.count > 4 {
                let descr = jsonResponse[i]["Cells"]["Name"].stringValue
                let newCode = Code()
                newCode.code = kod
                newCode.descr = descr
                newCode.parentClassCode = String(kod[range])
                do {
                    try self.realm.write {
                        self.realm.add(newCode)
                        self.realm.object(ofType: Class.self, forPrimaryKey: kod[range])?.codes.append(newCode)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
