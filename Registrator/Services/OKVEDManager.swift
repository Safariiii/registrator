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

fileprivate let versionURL = "https://apidata.mos.ru/v1/datasets/2745/?api_key=6a83c5ad02350635629ea3628783ac90"
fileprivate let dataURL = "https://apidata.mos.ru/v1/datasets/2745/rows?api_key=6a83c5ad02350635629ea3628783ac90"

class OKVEDManager {
    var realm = try! Realm()
    
    func checkForUpdates(view: UIView) {
        if let date = UserDefaults.standard.string(forKey: "okvedDate") {
            Alamofire.request(versionURL, method: .get).responseJSON { (response) in
                if response.result.isSuccess {
                    let jsonResponse = JSON(response.result.value!)
                    let versionDate = jsonResponse["VersionDate"].stringValue
                    if date != versionDate {
                        self.setupRefreshView(view: view)
                        self.refreshOkveds()
                        UserDefaults.standard.setValue(versionDate, forKey: "okvedDate")
                    }
                }
            }
        } else {
            Alamofire.request(versionURL, method: .get).responseJSON { (response) in
                if response.result.isSuccess {
                    let jsonResponse = JSON(response.result.value!)
                    let versionDate = jsonResponse["VersionDate"].stringValue
                    self.setupRefreshView(view: view)
                    self.refreshOkveds()
                    UserDefaults.standard.setValue(versionDate, forKey: "okvedDate")
                }
            }
        }
    }
    
    private func refreshOkveds() {
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
            getOkveds()
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

    private func getOkveds() {
        Alamofire.request(dataURL, method: .get).responseJSON { (response) in
            if response.result.isSuccess {
                let jsonResponse = JSON(response.result.value!)
                for i in 0..<jsonResponse.count {
                    self.addOkvedsToRealm(i: i, jsonResponse: jsonResponse)
                }
                self.refreshView.removeFromSuperview()
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
    
    let refreshView = UIView()
    let progressLabel = UILabel(text: "Идет обновление данных. Прогресс: 0%", textColor: .white, fontSize: 14, alignment: .center)
    
    func setupRefreshView(view: UIView) {
        view.addSubview(refreshView)
        refreshView.fillSuperview()
        refreshView.backgroundColor = .red
        
        refreshView.addSubview(progressLabel)
        progressLabel.setupAnchors(top: nil, leading: refreshView.leadingAnchor, bottom: nil, trailing: refreshView.trailingAnchor, centerY: refreshView.centerYAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: -20))
    }
}
