//
//  Request.swift
//  Registrator
//
//  Created by Руслан Сафаргалеев on 20.11.2020.
//  Copyright © 2020 Руслан Сафаргалеев. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Request {
    case addressNote
    case addressParse
    case ifns
    case none
    
    private var url: URL? {
        switch self {
        case .addressNote, .ifns:
            return URL(string: "https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address")
        case .addressParse:
            return URL(string: "https://cleaner.dadata.ru/api/v1/clean/address")
        case .none:
            return nil
        }
    }
    
    func getRequestBody<T>(object: T) -> Foundation.Data? {
        do {
            return try JSONSerialization.data(withJSONObject: object)
        } catch {
            return nil
        }
    }
        
    func getRequest(text: String) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token 31405e813d6508a98edad78837531476c5b495d8", forHTTPHeaderField: "Authorization")
        switch self {
        case .addressNote:
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let jsonObject: [String: Any] = ["query": text, "count": 10]
            request.httpBody = getRequestBody(object: jsonObject)
        case .addressParse:
            request.setValue("fce19ad98d1c4913577ff517992fa719eb492cab", forHTTPHeaderField: "X-Secret")
            let jsonObject: [String] = [text]
            request.httpBody = getRequestBody(object: jsonObject)
        case .ifns:
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let jsonObject: [String : Any] = ["query" : text]
            request.httpBody = getRequestBody(object: jsonObject)
        case .none:
            return nil
        }
        return request
    }
    
//    func getNote(text: String, completion: @escaping(([Address]) -> Void)) {
//        guard let request = getRequest(text: text) else { return }
//        Alamofire.request(request).responseJSON { (response) in
//            if response.result.isSuccess {
//                var dataArr = [Address]()
//                print(JSON(response.result.value))
//                if let response = response.result.value as? [String: Any] {
//                    let dataModel = DadataData(suggestions: [])
//                    guard let decodedData = self.getDecodedData(jsonObject: response, dataModel: dataModel) else { return }
//                    for suggestion in decodedData.suggestions {
//                        let item = suggestion.data
//                        let newAddress = Address(item: item, suggestion: suggestion, type: .addressNote)
//                        dataArr.append(newAddress)
//                    }
//                    var lastAddr = Address(item: nil, suggestion: nil, type: .none)
//                    lastAddr.strValue = "Вы ввели: " + text
//                    dataArr.append(lastAddr)
//                    completion(dataArr)
//
//                }
//            }
//        }
//    }

    func getDecodedData<T: Decodable, J>(jsonObject: J, dataModel: T) -> T? {
        let decoder = JSONDecoder()
        do {
            let responseData = try JSONSerialization.data(withJSONObject: jsonObject)
            return try decoder.decode(T.self, from: responseData)
        } catch {
            return nil
        }
    }
    
    func getNote(text: String, completion: @escaping(([Address]) -> Void)) {
        //        guard let request = getRequest(text: text) else { return }
        let parameters: [String : Any] = [
            "text": "Ямало-Ненецкий автономный округ, городской округ город Салехард, город Салехард, улица Свердлова, дом 42 квартира 41",
            "division": "1",
            "filter[filters][0][value]": "Ямало-Ненецкий автономный округ, городской округ город Салехард, город Салехард, улица Свердлова, дом 42",
            "filter[filters][0][field]": "PresentRow",
            "filter[filters][0][operator]": "contains",
            "filter[filters][0][ignoreCase]": "true",
            "filter[logic]": "and"
        ]
        Alamofire.request(URL(string: "https://fias.nalog.ru/Search/Searching")!, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                if let response = response.result.value as? [[String: Any]] {
                    let dataModel = FiasData(ObjectId: nil, PresentRow: nil)
                    guard let decodedData = self.getDecodedData(jsonObject: response[0], dataModel: dataModel) else { return }
                    let newFiasData = FiasData(ObjectId: decodedData.ObjectId, PresentRow: decodedData.PresentRow)
                    guard let id = decodedData.ObjectId else { return }
                    self.secondStage(id: String(id))
                    
                }
            }
        }
    }
    
    func secondStage(id: String) {
        let parameters: [String : Any] = [
            "objId": id,
            "objLvl": "10",
            "tabStripLvl": "3",
            "division": "1"
        ]
        Alamofire.request(URL(string: "https://fias.nalog.ru/AddressObjectDetailPage/ObjHierarchyInfoGrid")!, method: .post, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                if let response = response.result.value as? [String: Any] {
                    let dataModel = MunData(Data: [])
                    guard let decodedData = self.getDecodedData(jsonObject: response, dataModel: dataModel) else { print(3);return }
                    let newMunData = MunData(Data: decodedData.Data)
                    print(newMunData)
                } else {
                    print(2)
                }
            } else {
                print(1)
            }
        }
    }
}
