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
    var index = ""
    var region = ""
    var regionCode = ""
    var regionFiasId = ""
    var areaType = ""
    var area = ""
    var isAreaNeed = "Yes"
    var cityType = ""
    var city = ""
    var villageType = ""
    var village = ""
    var streetType = ""
    var street = ""
    var houseType = ""
    var house = ""
    var housingType = ""
    var housing = ""
    var appartementType = ""
    var appartement = ""
    var fns = ""
    var strValue = ""
    
    func save(id: String, collectionName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        var addressToSave: [String : String] = [:]
        addressToSave["index"] = index
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
        case .index:
            return index
        case .region:
            return region
        case .area:
            return areaType + " " + area
        case .city:
            return cityType + " " + city
        case .village:
            return villageType + " " + village
        case .street:
            return streetType + " " + street
        case .house:
            return houseType + " " + house
        case .housing:
            return housingType + " " + housing
        case .appartement:
            return appartementType + " " + appartement
        case .none, .save:
            return ""
        }
    }
}
