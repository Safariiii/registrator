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
    case region = "Субъект"
    case area = "Район"
    case city = "Город"
    case town = "Населенный пункт"
    case village = "Населенный пункт (поселок,  деревня и тп.)"
    case street = "Улица (проспект, площадь и тп.)"
    case house = "Дом"
    case housing = "Строение (корпус и тп.)"
    case appartement = "Квартира (комната и тп.)"
    case none = "Адрес"
    case save = "Сохранить"
    
    func makeSearchRequest(text: String, completion: @escaping(([FiasData]) -> Void)) {
        var parameters: [String : Any] = [:]
        switch self {
        case .region:
            parameters = [
            "text": text,
            "division": "1",
            "filter[filters][0][value]": "Ямало-Ненецкий автономный округ, городской округ город Салехард, город Салехард, улица Свердлова, дом 42",
            "filter[filters][0][field]": "PresentRow",
            "filter[filters][0][operator]": "contains",
            "filter[filters][0][ignoreCase]": "true",
            "filter[logic]": "and"
            ]
            
        default:
            break
        }
        Alamofire.request(URL(string: "https://fias.nalog.ru/Search/Searching")!, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                if let response = response.result.value as? [[String: Any]] {
                    var dataArr: [FiasData] = []
                    for item in response {
                        let dataModel = FiasData(ObjectId: nil, PresentRow: nil)
                        guard let decodedData = self.getDecodedData(jsonObject: item, dataModel: dataModel) else { return }
                        let newFiasData = FiasData(ObjectId: decodedData.ObjectId, PresentRow: decodedData.PresentRow)
                        dataArr.append(newFiasData)
                    }
                    completion(dataArr)
//                    guard let id = decodedData.ObjectId else { return }
//                    self.secondStage(id: String(id))
                    
                }
            }
        }
    }
    
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
    
    func getDecodedData<T: Decodable, J>(jsonObject: J, dataModel: T) -> T? {
        let decoder = JSONDecoder()
        do {
            let responseData = try JSONSerialization.data(withJSONObject: jsonObject)
            return try decoder.decode(T.self, from: responseData)
        } catch {
            return nil
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


