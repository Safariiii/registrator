//
//  Address.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 07.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Firebase

struct Address {
    
    init(item: Registrator.Data?, suggestion: Suggestions?, type: Request) {
        var strValue = ""
        switch type {
        case .addressNote:
            strValue = suggestion?.unrestrictedValue ?? ""
        case .addressParse:
            strValue = item?.result ?? ""
        case .ifns, .none:
            break
        }
        self.region = item?.regionWithType ?? ""
        self.regionCode = item?.regionKladrId ?? ""
        self.regionFiasId = item?.regionFiasId ?? ""
        self.areaType = item?.areaType ?? ""
        self.area = item?.area ?? ""
        self.cityType = item?.cityType ?? ""
        self.city = item?.city ?? ""
        self.villageType = item?.settlementType ?? ""
        self.village = item?.settlement ?? ""
        self.streetType = item?.streetType ?? ""
        self.street = item?.street ?? ""
        self.houseType = item?.houseTypeFull ?? ""
        self.house = item?.house ?? ""
        self.housingType = item?.blockTypeFull ?? ""
        self.housing = item?.block ?? ""
        self.appartementType = item?.flatTypeFull ?? ""
        self.appartement = item?.flat ?? ""
        self.fns = item?.taxOfficeLegal ?? ""
        self.strValue = strValue
    }
    
    var region: String
    var regionCode: String
    var regionFiasId: String
    var areaType: String
    var area: String
    var isAreaNeed = "Yes"
    var cityType: String
    var city: String
    var villageType: String
    var village: String
    var streetType: String
    var street: String
    var houseType: String
    var house: String
    var housingType: String
    var housing: String
    var appartementType: String
    var appartement: String
    var fns: String
    var strValue: String
    
    func save(id: String, collectionName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        var addressToSave: [String : String] = [:]
        addressToSave["regionCode"] = regionCode[0..<2]
        addressToSave["areaType"] = areaType
        addressToSave["area"] = area
        addressToSave["isAreaNeed"] = isAreaNeed
        addressToSave["cityType"] = cityType
        addressToSave["city"] = city
        addressToSave["villageType"] = villageType
        addressToSave["village"] = village
        addressToSave["streetType"] = streetType
        addressToSave["street"] = street
        addressToSave["houseType"] = houseType
        addressToSave["house"] = house
        addressToSave["housingType"] = housingType
        addressToSave["housing"] = housing
        addressToSave["appartementType"] = appartementType
        addressToSave["appartement"] = appartement
        addressToSave["fnsCode"] = fns
        
        db.collection("documents").document(uid).collection(collectionName).document(id).setData(["addressCollection" : [:] as Any, "address" : strValue], merge: true) { (error) in
            db.collection("documents").document(uid).collection(collectionName).document(id).setData(["addressCollection" : addressToSave as Any], merge: true)
        }
        
    }
    
    func cellText(type: AddressType) -> String {
        switch type {
        case .region:
            return region
        case .area:
            return areaType + " " + area == " " ? "" : areaType + " " + area
        case .city:
            return cityType + " " + city == " " ? "" : cityType + " " + city
        case .village:
            return villageType + " " + village == " " ? "" : villageType + " " + village
        case .street:
            return streetType + " " + street == " " ? "" : streetType + " " + street
        case .house:
            return houseType + " " + house == " " ? "" : houseType + " " + house
        case .housing:
            return housingType + " " + housing == " " ? "" : housingType + " " + housing
        case .appartement:
            return appartementType + " " + appartement == " " ? "" : appartementType + " " + appartement
        case .none, .save, .town:
            return ""
        }
    }
}
