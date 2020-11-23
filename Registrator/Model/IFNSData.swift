//
//  IFNSData.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 20.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation

struct IFNSData: Decodable {
    var ifnsDetails: IfnsDetails?
    var payeeDetails: PayeeDetails?
    var sprofDetails: SprofDetails?

}

struct IfnsDetails: Decodable {
    var ifnsName: String?
    var ifnsAddr: String?
    var ifnsPhone: String?
    var ifnsComment: String?
    var ifnsCode: String?
}

struct PayeeDetails: Decodable {
    var payeeKpp: String?
    var payeeName: String?
    var payeeAcc: String?
    var bankBic: String?
    var payeeInn: String?
    var bankName: String?
}

struct SprofDetails: Decodable {
    var ifnsCode: String?
}

struct DadataData: Decodable {
    var suggestions: [Suggestions]
}

struct Suggestions: Decodable {
    var data: Data
    var unrestrictedValue: String?
    
    enum CodingKeys: String, CodingKey {
        case unrestrictedValue = "unrestricted_value"
        case data = "data"
    }
}

struct Data: Decodable {
    var oktmo: String?
    var postalCode: String?
    var regionKladrId: String?
    var regionWithType: String?
    var regionFiasId: String?
    var areaType: String?
    var area: String?
    var cityType: String?
    var city: String?
    var settlementType: String?
    var settlement: String?
    var streetType: String?
    var street: String?
    var houseTypeFull: String?
    var house: String?
    var blockTypeFull: String?
    var block: String?
    var flatTypeFull: String?
    var flat: String?
    var taxOfficeLegal: String?
    var result: String?
    var Code: String?
    var IFNSFL: String?
    var Name: String?
    var PostalCode: String?

    enum CodingKeys: String, CodingKey {
        case oktmo = "oktmo"
        case postalCode = "postal_code"
        case regionKladrId = "region_kladr_id"
        case regionWithType = "region_with_type"
        case regionFiasId = "region_fias_id"
        case areaType = "area_type"
        case area = "area"
        case cityType = "city_type"
        case city = "city"
        case settlementType = "settlement_type"
        case streetType = "street_type"
        case street = "street"
        case houseTypeFull = "house_type_full"
        case house = "house"
        case blockTypeFull = "block_type_full"
        case block = "block"
        case flatTypeFull = "flat_type_full"
        case flat = "flat"
        case taxOfficeLegal = "tax_office_legal"
        case result = "result"
        case Code = "Code"
        case IFNSFL = "IFNSFL"
        case Name = "Name"
        case PostalCode = "PostalCode"
    }
}

struct FiasData: Decodable {
    var ObjectId: Int?
    var PresentRow: String?
}

struct MunData: Decodable {
    var Data: [Data?]
}

//struct Data: Decodable {
//    var Code: String?
//    var IFNSFL: String?
//    var Name: String?
//    var PostalCode: String?
//}
