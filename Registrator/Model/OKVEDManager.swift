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

class OKVEDManager {
    var realm = try! Realm()
    
    func checkForUpdates(view: UIView) {
        if let date = UserDefaults.standard.string(forKey: "okvedDate") {
            let url = "https://apidata.mos.ru/v1/datasets/2745/?api_key=6a83c5ad02350635629ea3628783ac90"
            Alamofire.request(url, method: .get).responseJSON { (response) in
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
            let url = "https://apidata.mos.ru/v1/datasets/2745/?api_key=6a83c5ad02350635629ea3628783ac90"
            Alamofire.request(url, method: .get).responseJSON { (response) in
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
            print("okokokok", error.localizedDescription)
        }
    }
    
    private func getOkvedClasses() {
        for singleClass in okvedClasses {
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

    var request: DataRequest?
    private func getOkveds() {
        let url = "https://apidata.mos.ru/v1/datasets/2745/rows?api_key=6a83c5ad02350635629ea3628783ac90"
        request = Alamofire.request(url, method: .get)
            
        request?.responseJSON { (response) in
            if response.result.isSuccess {
                let jsonResponse = JSON(response.result.value!)
                var counter = 1
                for i in 0..<jsonResponse.count {
                    counter += 1
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
                    self.progressLabel.text = "Идет обновление данных. Прогресс: \(floorf(Float(counter) / Float(jsonResponse.count) * 100))%"
                }
                self.refreshView.removeFromSuperview()
                
            } else {
                print(response)
            }
            self.request = nil
        }
        request?.downloadProgress { (progress) in
            DispatchQueue.main.async {
                print(progress.fractionCompleted)
                self.progressLabel.text = "Идет обновление данных. Прогресс: \(progress.fractionCompleted) * 100))%"
            }
            
        }
    }
    
    
    let refreshView = UIView()
    let progressLabel = UILabel()
    
    func setupRefreshView(view: UIView) {
        view.addSubview(refreshView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        refreshView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        refreshView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        refreshView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        refreshView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        refreshView.backgroundColor = .red
        
        refreshView.addSubview(progressLabel)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.trailingAnchor.constraint(equalTo: refreshView.trailingAnchor, constant: -20).isActive = true
        progressLabel.leadingAnchor.constraint(equalTo: refreshView.leadingAnchor, constant: 20).isActive = true
        progressLabel.centerYAnchor.constraint(equalTo: refreshView.centerYAnchor).isActive = true
        progressLabel.font = UIFont.systemFont(ofSize: 14)
        progressLabel.textColor = .white
        progressLabel.textAlignment = .center
        progressLabel.text = "Идет обновление данных. Прогресс: 0%"
    }
    
    let okvedClasses = [
        ["01", "Растениеводство и животноводство, охота и предоставление соответствующих услуг в этих областях"],
        ["02", "Лесоводство и лесозаготовки"],
        ["03", "Рыболовство и рыбоводство"],
        ["05", "Добыча угля"],
        ["06", "Добыча нефти и природного газа"],
        ["07", "Добыча металлических руд"],
        ["08", "Добыча прочих полезных ископаемых"],
        ["09", "Предоставление услуг в области добычи полезных ископаемых"],
        ["10", "Производство пищевых продуктов"],
        ["11", "Производство напитков"],
        ["12", "Производство табачных изделий"],
        ["13", "Производство текстильных изделий"],
        ["14", "Производство одежды"],
        ["15", "Производство кожи и изделий из кожи"],
        ["16", "Обработка древесины и производство изделий из дерева и пробки, кроме мебели, производство изделий из соломки и материалов для плетения"],
        ["17", "Производство бумаги и бумажных изделий"],
        ["18", "Деятельность полиграфическая и копирование носителей информации"],
        ["19", "Производство кокса и нефтепродуктов"],
        ["20", "Производство химических веществ и химических продуктов"],
        ["21", "Производство лекарственных средств и материалов, применяемых в медицинских целях"],
        ["22", "Производство резиновых и пластмассовых изделий"],
        ["23", "Производство прочей неметаллической минеральной продукции"],
        ["24", "Производство металлургическое"],
        ["25", "Производство готовых металлических изделий, кроме машин и оборудования"],
        ["26", "Производство компьютеров, электронных и оптических изделий"],
        ["27", "Производство электрического оборудования"],
        ["28", "Производство машин и оборудования, не включенных в другие группировки"],
        ["29", "Производство автотранспортных средств, прицепов и полуприцепов"],
        ["30", "Производство прочих транспортных средств и оборудования"],
        ["31", "Производство мебели"],
        ["32", "Производство прочих готовых изделий"],
        ["33", "Ремонт и монтаж машин и оборудования"],
        ["35", "Обеспечение электрической энергией, газом и паром; кондиционирование воздуха"],
        ["36", "Забор, очистка и распределение воды"],
        ["37", "Сбор и обработка сточных вод"],
        ["38", "Сбор, обработка и утилизация отходов; обработка вторичного сырья"],
        ["39", "Предоставление услуг в области ликвидации последствий загрязнений и прочих услуг, связанных с удалением отходов"],
        ["41", "Строительство зданий"],
        ["42", "Строительство инженерных сооружений"],
        ["43", "Работы строительные специализированные"],
        ["45", "Торговля оптовая и розничная автотранспортными средствами и мотоциклами и их ремонт"],
        ["46", "Торговля оптовая, кроме оптовой торговли автотранспортными средствами и мотоциклами"],
        ["47", "Торговля розничная, кроме торговли автотранспортными средствами и мотоциклами"],
        ["49", "Деятельность сухопутного и трубопроводного транспорта"],
        ["50", "Деятельность водного транспорта"],
        ["51", "Деятельность воздушного и космического транспорта"],
        ["52", "Складское хозяйство и вспомогательная транспортная деятельность"],
        ["53", "Деятельность почтовой связи и курьерская деятельность"],
        ["55", "Деятельность по предоставлению мест для временного проживания"],
        ["56", "Деятельность по предоставлению продуктов питания и напитков"],
        ["58", "Деятельность издательская"],
        ["59", "Производство кинофильмов, видеофильмов и телевизионных программ, издание звукозаписей и нот"],
        ["60", "Деятельность в области телевизионного и радиовещания"],
        ["61", "Деятельность в сфере телекоммуникаций"],
        ["62", "Разработка компьютерного программного обеспечения, консультационные услуги в данной области и другие сопутствующие услуги"],
        ["63", "Деятельность в области информационных технологий"],
        ["64", "Деятельность по предоставлению финансовых услуг, кроме услуг по страхованию и пенсионному обеспечению"],
        ["65", "Страхование, перестрахование, деятельность негосударственных пенсионных фондов, кроме обязательного социального обеспечения"],
        ["66", "Деятельность вспомогательная в сфере финансовых услуг и страхования"],
        ["68", "Операции с недвижимым имуществом"],
        ["69", "Деятельность в области права и бухгалтерского учета"],
        ["70", "Деятельность головных офисов; консультирование по вопросам управления"],
        ["71", "Деятельность в области архитектуры и инженерно-технического проектирования; технических испытаний, исследований и анализа"],
        ["72", "Научные исследования и разработки"],
        ["73", "Деятельность рекламная и исследование конъюнктуры рынка"],
        ["74", "Деятельность профессиональная научная и техническая прочая"],
        ["75", "Деятельность ветеринарная"],
        ["77", "Аренда и лизинг"],
        ["78", "Деятельность по трудоустройству и подбору персонала"],
        ["79", "Деятельность туристических агентств и прочих организаций, предоставляющих услуги в сфере туризма"],
        ["80", "Деятельность по обеспечению безопасности и проведению расследований"],
        ["81", "Деятельность по обслуживанию зданий и территорий"],
        ["82", "Деятельность административно-хозяйственная, вспомогательная деятельность по обеспечению функционирования организации, деятельность по предоставлению прочих вспомогательных услуг для бизнеса"],
        ["84", "Деятельность органов государственного управления по обеспечению военной безопасности, обязательному социальному обеспечению"],
        ["85", "Образование"],
        ["86", "Деятельность в области здравоохранения"],
        ["87", "Деятельность по уходу с обеспечением проживания"],
        ["88", "Предоставление социальных услуг без обеспечения проживания"],
        ["90", "Деятельность творческая, деятельность в области искусства и организации развлечений"],
        ["91", "Деятельность библиотек, архивов, музеев и прочих объектов культуры"],
        ["92", "Деятельность по организации и проведению азартных игр и заключению пари, по организации и проведению лотерей"],
        ["93", "Деятельность в области спорта, отдыха и развлечений"],
        ["94", "Деятельность общественных организаций"],
        ["95", "Ремонт компьютеров, предметов личного потребления и хозяйственно-бытового назначения"],
        ["96", "Деятельность по предоставлению прочих персональных услуг"],
        ["97", "Деятельность домашних хозяйств с наемными работниками"],
        ["98", "Деятельность недифференцированная частных домашних хозяйств по производству товаров и предоставлению услуг для собственного потребления"],
        ["99", "Деятельность экстерриториальных организаций и органов"]
    ]
}
