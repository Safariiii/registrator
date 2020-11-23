//
//  AddressType.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 11.10.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Alamofire

enum AddressType: String, CaseIterable {
    case index = "Индекс"
    case region = "Субъект"
    case area = "Район"
    case city = "Город"
    case village = "Населенный пункт (поселок,  деревня и тп.)"
    case street = "Улица (проспект, площадь и тп.)"
    case house = "Дом"
    case housing = "Строение (корпус и тп.)"
    case appartement = "Квартира (комната и тп.)"
    case none = "Адрес"
    case save = "Сохранить"
    case parsed
    
    var note: String? {
        switch self {
        case .area:
            return "Указывается только если запись о районе, поселении, гор округе и тп. содержится в паспорте на странице с регистрацией. В случае отсутствия такой записи нажмите на ячейку с названием района, для того, что вычеркнуть запись о нем"
        default:
            return nil
        }
    }
    
    func didSelectRow(address: Address, id: String, docType: DocType, completion: @escaping((Address?) -> Void)) {
        switch self {
        case .parsed:
            let text = address.strValue
            parseAddress(text: text) { (address) in
                completion(address)
            }
        case .none:
            completion(address)
        case .area:
            var newAddress = address
            newAddress.isAreaNeed = address.isAreaNeed == "Yes" ? "No" : "Yes"
            completion(newAddress)
        case .save:
            address.save(id: id, collectionName: docType.collectionName)
            docType.findFNS(id: id, code: address.fns)
            completion(nil)
        default:
            break
        }
    }
    
    private func parseAddress(text: String, completion: @escaping((Address) -> Void)) {
        let type = Request.addressParse
        guard let request = type.getRequest(text: text) else { return }
        Alamofire.request(request).responseJSON { (response) in
            if response.result.isSuccess {
                if let response = response.result.value as? [[String: Any]] {
                    let dataModel = Registrator.Data()
                    guard let decodedData = type.getDecodedData(jsonObject: response[0], dataModel: dataModel) else { return }
                    let chosenAddress = Address(item: decodedData, suggestion: nil, type: .addressParse)
                    completion(chosenAddress)
                }
            }
        }
    }
}
