//
//  AddressViewVeiwModel.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AddressVeiwModel {
    
    var url: String = "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address"
    var dataArr: [Address] = []
    var step = AddressStep.search
    var chosenAddress: Address?
    let id: String
    var router: AddressRouter!
    let docType: DocType
    
    init(id: String, docType: DocType) {
        self.id = id
        self.docType = docType
    }
    
    func changeStep() {
        step.changeStep()
    }
    
    func didSelectRowAt(row: Int) {
        if step == .search {
            if dataArr.count != 1 {
                chosenAddress = dataArr[row]
            }
            changeStep()
        } else {
            if step.fields[row] == .area {
                let isAreaNeed = chosenAddress?.isAreaNeed == "Yes" ? true : false
                chosenAddress?.isAreaNeed = isAreaNeed ? "No" : "Yes"
            } else if step.fields[row] == .save {
                router.dismissModule()
                chosenAddress?.save(id: id, collectionName: docType.collectionName)
                if let addr = chosenAddress {
                    findFNS(code: addr.fns)
                }
            }
        }
    }
    
    func getFnsRequest(url: String, text: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token 31405e813d6508a98edad78837531476c5b495d8", forHTTPHeaderField: "Authorization")
        let jsonObject: [String : Any] = ["query" : text]
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
        return request
    }
    
    private func findFNS(code: String) {
        let parameters: [String : Any] = [
            "c": "next",
            "step": "1",
            "npKind": "fl",
            "ifns": code
        ]
        let url = URL(string: "https://service.nalog.ru/addrno-proc.json")
        guard let urll = url else { return }
        Alamofire.request(urll, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let jsonResponse = JSON(response.result.value!)
                let parentCode = jsonResponse["sprofDetails"]["ifnsCode"].stringValue
                let parameters: [String : Any] = [
                    "c": "next",
                    "step": "1",
                    "npKind": "fl",
                    "ifns": parentCode
                ]
                Alamofire.request(urll, method: .post, parameters: parameters).responseJSON { (response) in
                    if response.result.isSuccess {
                        let jsonResponse = JSON(response.result.value!)
                        var newIFNS = IFNS()
                        newIFNS.title = jsonResponse["ifnsDetails"]["ifnsName"].stringValue
                        newIFNS.address = jsonResponse["ifnsDetails"]["ifnsAddr"].stringValue
                        newIFNS.phone = jsonResponse["ifnsDetails"]["ifnsPhone"].stringValue
                        newIFNS.workHours = jsonResponse["ifnsDetails"]["ifnsComment"].stringValue
                        newIFNS.amount = self.docType.dutyAmount
                        newIFNS.receiverKpp = jsonResponse["payeeDetails"]["payeeKpp"].stringValue
                        let fullReceiverTitle = jsonResponse["payeeDetails"]["payeeName"].stringValue
                        newIFNS.receiverTitle = fullReceiverTitle.replacingOccurrences(of: "Управление Федерального казначейства", with: "УФК").replacingOccurrences(of: "Межрайонная инспекция Федеральной налоговой службы", with: "МИФНС России")
                        newIFNS.accountNumber = jsonResponse["payeeDetails"]["payeeAcc"].stringValue
                        newIFNS.bik = jsonResponse["payeeDetails"]["bankBic"].stringValue
                        newIFNS.receiverInn = jsonResponse["payeeDetails"]["payeeInn"].stringValue
                        newIFNS.bank = jsonResponse["payeeDetails"]["bankName"].stringValue
                        newIFNS.kbk = self.docType.kbk
                        newIFNS.code = jsonResponse["ifnsDetails"]["ifnsCode"].stringValue
                        let ifnsAddr = jsonResponse["ifnsDetails"]["ifnsAddr"].stringValue
                        Alamofire.request(self.getFnsRequest(url: "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address", text: ifnsAddr)).responseJSON { (response) in
                            if response.result.isSuccess {
                                let jsonResponse = JSON(response.result.value!)
                                newIFNS.oktmo = jsonResponse["suggestions"][0]["data"]["oktmo"].stringValue
                                newIFNS.save(collectionName: self.docType.collectionName, id: self.id)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var numberOfRows: Int {
        if step == .search {
            return dataArr.count
        } else {
            return step.fields.count
        }
    }
    
    func parseAddress(text: String, completion: @escaping(() -> Void)) {
        let parseURl = "https://cleaner.dadata.ru/api/v1/clean/address"
        var request = URLRequest(url: URL(string: parseURl)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token 31405e813d6508a98edad78837531476c5b495d8", forHTTPHeaderField: "Authorization")
        request.setValue("fce19ad98d1c4913577ff517992fa719eb492cab", forHTTPHeaderField: "X-Secret")
        let jsonObject: [String] = [text]
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
        
        Alamofire.request(request).responseJSON {
            (response) in
            if response.result.isSuccess {
                let jsonResponse = JSON(response.result.value!)
                let index = jsonResponse[0]["postal_code"].stringValue
                let regionCode = jsonResponse[0]["region_kladr_id"].stringValue
                let region = jsonResponse[0]["region_with_type"].stringValue
                let regionFIAS = jsonResponse[0]["region_fias_id"].stringValue
                let areaType = jsonResponse[0]["area_type"].stringValue
                let area = jsonResponse[0]["area"].stringValue
                let cityType = jsonResponse[0]["city_type"].stringValue
                let city = jsonResponse[0]["city"].stringValue
                let villageType = jsonResponse[0]["settlement_type"].stringValue
                let village = jsonResponse[0]["settlement"].stringValue
                let streetType = jsonResponse[0]["street_type"].stringValue
                let street = jsonResponse[0]["street"].stringValue
                let houseType = jsonResponse[0]["house_type_full"].stringValue
                let house: String = jsonResponse[0]["house"].stringValue
                let housingType = jsonResponse[0]["block_type_full"].stringValue
                let housing: String = jsonResponse[0]["block"].stringValue
                let appartementType = jsonResponse[0]["flat_type_full"].stringValue
                let appartement: String = jsonResponse[0]["flat"].stringValue
                let fns: String = jsonResponse[0]["tax_office_legal"].stringValue
                let strValue = jsonResponse[0]["result"].stringValue
                let newAddress = Address(index: index, region: region, regionCode: regionCode,regionFiasId: regionFIAS, areaType: areaType, area: area, cityType: cityType, city: city, villageType: villageType, village: village, streetType: streetType, street: street, houseType: houseType, house: house, housingType: housingType, housing: housing, appartementType: appartementType, appartement: appartement, fns: fns, strValue: strValue)
                self.chosenAddress = newAddress
                completion()
            }
        }
    }
    
    func getNote(text: String, completion: @escaping(() -> Void)) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token 31405e813d6508a98edad78837531476c5b495d8", forHTTPHeaderField: "Authorization")
        let jsonObject: [String: Any] = ["query": text, "count": 10]
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
        
        Alamofire.request(request).responseJSON {
            (response) in
            if response.result.isSuccess {
                let jsonResponse = JSON(response.result.value!)
                self.dataArr = []
                for i in 0 ..< jsonResponse["suggestions"].count {
                    let res = jsonResponse["suggestions"][i]["data"]
                    let index = res["postal_code"].stringValue
                    let regionCode = res["region_kladr_id"].stringValue
                    let region = res["region_with_type"].stringValue
                    let regionFIAS = res["region_fias_id"].stringValue
                    let areaType = res["area_type"].stringValue
                    let area = res["area"].stringValue
                    let cityType = res["city_type"].stringValue
                    let city = res["city"].stringValue
                    let villageType = res["settlement_type"].stringValue
                    let village = res["settlement"].stringValue
                    let streetType = res["street_type"].stringValue
                    let street = res["street"].stringValue
                    let houseType = res["house_type_full"].stringValue
                    let house: String = res["house"].stringValue
                    let housingType = res["block_type_full"].stringValue
                    let housing: String = res["block"].stringValue
                    let appartementType = res["flat_type_full"].stringValue
                    let appartement: String = res["flat"].stringValue
                    let fns: String = res["tax_office_legal"].stringValue
                    let strValue = jsonResponse["suggestions"][i]["unrestricted_value"].stringValue
                    let newAddress = Address(index: index, region: region, regionCode: regionCode,regionFiasId: regionFIAS, areaType: areaType, area: area, cityType: cityType, city: city, villageType: villageType, village: village, streetType: streetType, street: street, houseType: houseType, house: house, housingType: housingType, housing: housing, appartementType: appartementType, appartement: appartement, fns: fns, strValue: strValue)
                    self.dataArr.append(newAddress)
                }
                let lastAddr = Address(strValue: "Вы ввели: " + text)
                self.dataArr.append(lastAddr)
                completion()
            }
        }
    }
    
    func cellViewModel(for indexPath: IndexPath) -> AddressCellViewModel? {
        let item = step.fields[indexPath.row]
        let title = item.rawValue
        let note = item.note
        var text = ""
        
        if step == .search {
            text = dataArr[indexPath.row].strValue
        } else {
            if let address = chosenAddress {
                text = address.cellText(type: item)
                if text == " " {
                    text = ""
                }
            } else {
                chosenAddress = Address()
                text = chosenAddress!.cellText(type: item)
            }
        }
        let isAreaNeed = chosenAddress?.isAreaNeed == "Yes" ? true : false
        return AddressCellViewModel(title: title, text: text, step: step, note: note, isAreaNeed: isAreaNeed, type: item)
    }
}
