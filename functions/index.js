const functions = require('firebase-functions');
const admin = require('firebase-admin');
const https = require('https');
const { Storage } = require('@google-cloud/storage');
const Excel = require('exceljs')
const nodemailer = require('nodemailer');
const url = require('url');
var serviceAccount = require("./registrator-3c860-firebase-adminsdk-s717n-ba6154020d");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://registrator-3c860.firebaseio.com"
});

let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'taxregistrator@gmail.com',
        pass: 'Rus881358'
    }
});

exports.createDocument = functions.https.onCall((data, context) => {
    const id = data.id;
    const uid = data.uid;
    
    return admin.firestore().collection('documents').doc(uid).collection('IP').doc(id).get().then(document => {
        const lastName = document.data().lastName;
        const firstName = document.data().firstName;
        const middleName = document.data().middleName;
        var inn = document.data().inn;
        const gender = document.data().sex;
        var dateOfBirth = document.data().dateOfBirth;
        const placeOfBirth = document.data().placeOfBirth;
        const passportSeries = document.data().passportSeries;
        const passportNumber = document.data().passportNumber;
        var passportDate = document.data().passportDate;
        const passportGiver = document.data().passportGiver;
        var passportCode = document.data().passportCode;
        const giveMethod = document.data().giveMethod;
        var phoneNumber = document.data().phoneNumber;
        const email = document.data().email;
        const address = document.data().addressCollection;
        const addressStr = document.data().address;
        var mainOkved = document.data().mainOkved;
        var okveds = document.data().okveds;
        const ifns = document.data().ifns;
        const taxesSystem = document.data().taxesSystem;
        const taxesRate = document.data().taxesRate;
                
        return new Promise((resolve, reject) => {
            const bucketName = 'registrator-3c860.appspot.com';
            const filename = '21001.xlsx';
            const gpPath = 'gp.xlsx';
            const usnPath = 'usn.xlsx'
            const zpPath = 'Запрос.xlsx'
            // Creates a client
            const storage = new Storage();
            
            function insertName(firstPage) {
                //фамилия
                insertWord(firstPage, lastName.length, lastName, 'T', '14', [], 34);
                //имя
                insertWord(firstPage, firstName.length, firstName, 'T', '16', [], 34);
                //отчество
                insertWord(firstPage, middleName.length, middleName, 'T', '19', [], 34);
            }
            
            function insertGender(page) {
                if (gender === 'Мужской') {
                    const cell = page.getCell('Q33');
                    cell.value = '1';
                } else {
                    const cell = page.getCell('Q33');
                    cell.value = '2';
                }
            }
            
            function insertPassport(page) {
                //вид документа
                const cell1 = page.getCell('W33');
                cell1.value = '2';
                const cell2 = page.getCell('Z33');
                cell2.value = '1';
                //серия паспорта
                insertWord(page, passportSeries.length, passportSeries, 'AF', '35', [2], 5);
                //номер паспорта
                insertWord(page, passportNumber.length, passportNumber, 'AX', '35', [], 6);
                //дата выдачи
                passportDate = passportDate.replace(/\./gi, '');
                insertWord(page, passportDate.length, passportDate, 'T', '37', [2, 4], 8);
                //кем выдан паспорт
                insertWord(page, passportGiver.length, passportGiver, 'T', '39', [], 114);
                //код подразделения
                passportCode = passportCode.replace(/-/gi, '');
                insertWord(page, passportCode.length, passportCode, 'Z', '45', [3], 9);
            }
            
            function insertCitizenship(page) {
                const cell = page.getCell('W45');
                cell.value = '1';
            }
            
            function insertGiveMethod(page) {
                const cell = page.getCell('K22');
                if (giveMethod === 'По доверенности') {
                    cell.value = '2';
                } else {
                    cell.value = '1';
                }
            }
            
            function insertAddress(page) {
                //индекс
                insertWord(page, address["index"].length, address["index"], 'Z', '11', [], 6);
                //номер региона
                insertWord(page, address["regionCode"].length, address["regionCode"], 'CH', '11', [], 2);
                if (address["isAreaNeed"] === "Yes") {
                    //тип района
                    insertWord(page, address["areaType"].length, address["areaType"], 'B', '14', [], 10);
                    //имя района
                    insertWord(page, address["area"].length, address["area"], 'AL', '14', [], 68);
                }
                //тип города
                insertWord(page, address["cityType"].length, address["cityType"], 'B', '18', [], 10);
                //имя города
                insertWord(page, address["city"].length, address["city"], 'AL', '18', [], 28);
                //тип деревни
                insertWord(page, address["villageType"].length, address["villageType"], 'B', '20', [], 10);
                //имя деревни
                insertWord(page, address["village"].length, address["village"], 'AL', '20', [], 68);
                //тип улицы
                insertWord(page, address["streetType"].length, address["streetType"], 'B', '24', [], 10);
                //имя улицы
                insertWord(page, address["street"].length, address["street"], 'AL', '24', [], 68);
                //тип дома
                insertWord(page, address["houseType"].length, address["houseType"], 'B', '28', [], 10);
                //номер дома
                insertWord(page, address["house"].length, address["house"], 'AI', '28', [], 8);
                //тип корпуса
                insertWord(page, address["housingType"].length, address["housingType"], 'BM', '28', [], 10);
                //номер корпуса
                insertWord(page, address["housing"].length, address["housing"], 'CT', '28', [], 8);
                //тип квартиры
                insertWord(page, address["appartementType"].length, address["appartementType"], 'AI', '30', [], 8);
                //номер квартиры
                insertWord(page, address["appartement"].length, address["appartement"], 'CT', '30', [], 8);
            }
            
            function insertOkveds(page) {
                var main = '';
                for (var key in mainOkved) {
                    insertWord(page, key.length, key, 'AU', '14', [], 8);
                    main = key;
                }
                var starts = ['E', 'AI', 'BM', 'CT']
                var i = 0;
                var rows = '18'
                for (var ok in okveds) {
                    if (ok !== main) {
                        insertWord(page, ok.length, ok, starts[i], rows, [], 8);
                        i += 1;
                        if (i === 4) {
                            i = 0;
                            rows = String(Number(rows)+2);
                        }
                    }
                }
            }
            
            function insertWord(page, count, word, start, row, skip, stop) {
                const alph = ['B', 'E', 'H', 'K', 'N', 'Q', 'T', 'W', 'Z', 'AC', 'AF', 'AI', 'AL', 'AO', 'AR', 'AU', 'AX', 'BA', 'BD', 'BG', 'BJ', 'BM', 'BP', 'BS', 'BV', 'BY', 'CB', 'CE', 'CH', 'CK', 'CN', 'CQ', 'CT', 'CW', 'CZ', 'DC', 'DF', 'DI', 'DL', 'DO']
                var ind = alph.indexOf(start);
                var rows = row;
                for (let i = 0; i < count; i++) {
                    if (i===stop) {
                        break;
                    }
                    if (skip.indexOf(i) !== -1) {
                        ind += 1;
                    }
                    const cellStr = alph[ind]+rows;
                    const cell = page.getCell(cellStr);
                    cell.value = word.slice(i, i+1);
                    ind += 1;
                    if (ind === alph.length) {
                        ind = 0;
                        rows = String(Number(rows)+2);
                    }
                }
            }

            async function createWorkbook() {
                return new Promise((resolve, reject) => {
                    let file = storage.bucket(bucketName).file(id + '.xlsx');
                    var chunks = [];
                    
                    const stream = storage.bucket(bucketName).file(filename).createReadStream()
                    .on('error', function(err) {
                        console.log(err);
                    })
                    .on('response', function(response) {
                        console.log('response: ' + response);
                    }).on('data', function(data) {
                        chunks.push(data);
                    })
                    .on('finish', async function() {
                        const data = Buffer.concat(chunks);
                        const workbook = new Excel.Workbook();
                        await workbook.xlsx.load(data);
                        const firstPage = workbook.worksheets[0];
                        const secondPage = workbook.worksheets[1];
                        const okvedPage = workbook.worksheets[2];
                        const fifthPage = workbook.worksheets[3];
                        //ФИО
                        insertName(firstPage);
                        //инн
                        inn = inn.replace(/ /gi, '');
                        insertWord(firstPage, inn.length, inn, 'AF', '30', [], 12);
                        //Пол
                        insertGender(firstPage);
                        //дата рождения
                        dateOfBirth = dateOfBirth.replace(/\./gi, '');
                        insertWord(firstPage, dateOfBirth.length, dateOfBirth, 'W', '36', [2, 4], 8);
                        //место рождения
                        insertWord(firstPage, placeOfBirth.length, placeOfBirth, 'B', '38', [], 80);
                        //Гражданство
                        insertCitizenship(firstPage);
                        //Адрес
                        insertAddress(secondPage);
                        //Паспорт
                        insertPassport(secondPage);
                        //оквэды
                        insertOkveds(okvedPage);
                        //Метод подачи
                        insertGiveMethod(fifthPage);
                        //номер телефона
                        phoneNumber = phoneNumber.replace(/-/gi,'');
                        insertWord(fifthPage, phoneNumber.length, phoneNumber, 'AR', '26', [], 20);
                        //email
                        insertWord(fifthPage, email.length, email, 'N', '28', [], 35);
                        
                        await workbook.xlsx.write(file.createWriteStream());
                        resolve();
                    })
                    .resume();
                });
            }
            

            createWorkbook().then(async ()=>{
                return new Promise((resolve, reject) => {
                    let file = storage.bucket(bucketName).file('gp_' + id + '.xlsx');
                    var chunks = [];
                    
                    const stream = storage.bucket(bucketName).file(gpPath).createReadStream()
                    .on('error', function(err) {
                        console.log(err);
                    })
                    .on('response', function(response) {
                        console.log('response: ' + response);
                    }).on('data', function(data) {
                        chunks.push(data);
                    })
                    .on('finish', async function() {
                        const data = Buffer.concat(chunks);
                        const workbook = new Excel.Workbook();
                        await workbook.xlsx.load(data);
                        const page = workbook.worksheets[0];
                        
                        //фио
                        const nameCell = page.getCell('B3');
                        nameCell.value = 'ФИО ' + lastName + ' ' + firstName + ' ' + middleName;
                        const nameCell1 = page.getCell('B16');
                        nameCell1.value = 'ФИО ' + lastName + ' ' + firstName + ' ' + middleName;
                        //адрес
                        const addressCell = page.getCell('C3');
                        addressCell.value = 'Адрес ' + addressStr;
                        const addressCell1 = page.getCell('C16');
                        addressCell1.value = 'Адрес ' + addressStr;
                        //Инн
                        const innCell = page.getCell('B4');
                        innCell.value = 'ИНН ' + inn;
                        const innCell1 = page.getCell('B17');
                        innCell1.value = 'ИНН ' + inn;
                        //сумма
                        const amountCell = page.getCell('C4');
                        amountCell.value = 'Сумма ' + ifns["amount"];
                        const amountCell1 = page.getCell('C17');
                        amountCell1.value = 'Сумма ' + ifns["amount"];
                        //банк
                        const bankCell = page.getCell('B5');
                        bankCell.value = 'Банк получателя ' + ifns["bank"];
                        const bankCell1 = page.getCell('B18');
                        bankCell1.value = 'Банк получателя ' + ifns["bank"];
                        //бик
                        const bikCell = page.getCell('C5');
                        bikCell.value = 'БИК ' + ifns["bik"];
                        const bikCell1 = page.getCell('C18');
                        bikCell1.value = 'БИК ' + ifns["bik"];
                        //получатель
                        const receiverCell = page.getCell('B8');
                        receiverCell.value = 'Получатель ' + ifns["receiverTitle"];
                        const receiverCell1 = page.getCell('B21');
                        receiverCell1.value = 'Получатель ' + ifns["receiverTitle"];
                        //счет№
                        const accountCell = page.getCell('C7');
                        accountCell.value = 'Сч. № ' + ifns["accountNumber"];
                        const accountCell1 = page.getCell('C20');
                        accountCell1.value = 'Сч. № ' + ifns["accountNumber"];
                        //инн получателя
                        const receiverInnCell = page.getCell('C8');
                        receiverInnCell.value = 'ИНН ' + ifns["receiverInn"];
                        const receiverInnCell1 = page.getCell('C21');
                        receiverInnCell1.value = 'ИНН ' + ifns["receiverInn"];
                        //кпп получателя
                        const receiverKppCell = page.getCell('C9');
                        receiverKppCell.value = 'КПП ' + ifns["receiverKpp"];
                        const receiverKppCell1 = page.getCell('C22');
                        receiverKppCell1.value = 'КПП ' + ifns["receiverKpp"];
                        //кбк
                        const kbkCell = page.getCell('B10');
                        kbkCell.value = 'КБК ' + ifns["kbk"];
                        const kbkCell1 = page.getCell('B23');
                        kbkCell1.value = 'КБК ' + ifns["kbk"];
                        //октмо
                        const oktmoCell = page.getCell('C10');
                        oktmoCell.value = 'ОКТМО ' + ifns["oktmo"];
                        const oktmoCell1 = page.getCell('C23');
                        oktmoCell1.value = 'ОКТМО ' + ifns["oktmo"];
                        
                        await workbook.xlsx.write(file.createWriteStream());
                        resolve();
                    })
                    .resume();
                });
            }).then(async ()=>{
                if (taxesSystem === 'Упрощенная система налогообложения (УСН)') {
                    return new Promise((resolve, reject) => {
                        let file = storage.bucket(bucketName).file('usn_' + id + '.xlsx');
                        var chunks = [];
                        
                        const stream = storage.bucket(bucketName).file(usnPath).createReadStream()
                        .on('error', function(err) {
                            console.log(err);
                        })
                        .on('response', function(response) {
                            console.log('response: ' + response);
                        }).on('data', function(data) {
                            chunks.push(data);
                        })
                        .on('finish', async function() {
                            const data = Buffer.concat(chunks);
                            const workbook = new Excel.Workbook();
                            await workbook.xlsx.load(data);
                            const page = workbook.worksheets[0];
                            
                            //фио
                            const fio = lastName + ' ' + firstName + ' ' + middleName
                            insertWord(page, fio.length, fio, 'B', '15', [], 160);
                            //инн
                            insertWord(page, inn.length, inn, 'AL', '1', [], 12);
                            //код
                            insertWord(page, ifns["code"].length, ifns["code"], 'AO', '11', [], 4);
                            
                            if (taxesRate === "Доходы (6% от всех доходов)") {
                                const cell = page.getCell('AT29');
                                cell.value = '1';
                            } else {
                                const cell = page.getCell('AT29');
                                cell.value = '2';
                            }
                            await workbook.xlsx.write(file.createWriteStream());
                            resolve();
                        })
                        .resume();
                    });
                } else {
                    return console.log('osno');
                }
            }).then(async ()=>{
                return new Promise((resolve, reject) => {
                    var chunks = [];
                    const file = storage.bucket(bucketName).file('zp_' + id + '.xlsx');
                    const stream = storage.bucket(bucketName).file(zpPath).createReadStream()
                    .on('error', function(err) {
                        console.log(err);
                    })
                    .on('response', function(response) {
                        console.log('response: ' + response);
                    }).on('data', function(data) {
                        chunks.push(data);
                    })
                    .on('finish', async function() {
                        const data = Buffer.concat(chunks);
                        
                        const fio = lastName + ' ' + firstName + ' ' + middleName;
                        const workbook = new Excel.Workbook();
                        await workbook.xlsx.load(data);
                        const page = workbook.worksheets[0];
                        const cell = page.getCell('A1');
                        cell.value = 'От: ' + fio;
                        const cell1 = page.getCell('A2');
                        cell1.value = 'В: ' + ifns["title"];
                        const cell2 = page.getCell('A9');
                        cell2.value = fio + ' / _______________________';
                        const cell3 = page.getCell('A5');
                        cell3.value = 'Я подал документы на государственную регистрацию себя в качестве индивидуального предпринимателя.';
                        await workbook.xlsx.write(file.createWriteStream());
                        
                        resolve();
                    })
                    .resume();
                });
            }).then(async ()=>{
                const options = {
                version: 'v4',
                action: 'read',
                expires: Date.now() + 60 * 60 * 1000, // 60 minutes
                };
                const [fileURL] = await storage.bucket(bucketName).file(id + '.xlsx').getSignedUrl(options);
                const [gpURL] = await storage.bucket(bucketName).file('gp_' + id + '.xlsx').getSignedUrl(options);
                const [zpURL] = await storage.bucket(bucketName).file('zp_' + id + '.xlsx').getSignedUrl(options);
                if (taxesSystem === 'Упрощенная система налогообложения (УСН)') {
                    const [usnURL] = await storage.bucket(bucketName).file('usn_' + id + '.xlsx').getSignedUrl(options);
                    const urls = [fileURL, gpURL, usnURL, zpURL]
                    return urls;
                } else {
                    const urls = [fileURL, gpURL, zpURL]
                    return urls;
                }
                
            }).then((urls) => {
                var attachments = [];
                if (taxesSystem === 'Упрощенная система налогообложения (УСН)') {
                    attachments = [{filename: 'P21001.xlsx', path: urls[0]}, {filename: 'Квитанция на оплату госпошлины.xlsx', path: urls[1]}, {filename: 'Уведомление о переходе на УСН.xlsx', path: urls[2]}, {filename: 'Запрос на получение документов.xlsx', path: urls[3]}]
                } else {
                    attachments = [{filename: 'P21001.xlsx', path: urls[0]}, {filename: 'Квитанция на оплату госпошлины.xlsx', path: urls[1]}, {filename: 'Запрос на получение документов.xlsx', path: urls[2]}]
                }
                
                var letter = '<p><b>Спасибо, что воспользовались нашим сервисом!</b></p><p>Для успешного завершения регистрации ИП вам необходимо совершить следующие действия:</p><ul><li>Распечатать полученный комплект документов</li>'
                
                if (giveMethod === "По доверенности") {
                    letter += '<li>Заверить у нотариуса свою подпись на форме Р21001</li><li>Оформить нотариальную доверенность на человека, который будет подавать документы в налоговую</li><li>Сделать нотариальную копию паспорта</li>'
                } else {
                    letter += '<li>Сделать ксерокопию всех страниц паспорта</li>'
                }
                
                if (taxesSystem === 'Упрощенная система налогообложения (УСН)') {
                    letter += '<li>В Заявлении о переходе на УСН в нижней левой части листа необходимо поставить свою подпись и вписать дату подачи документов. Дату можно вписать либо <b>черной</b> ручкой либо на компьютере. <b>Заявление необходимо распечатать в 3-х экземплярах(один вам вернут с отметкой налогового органа)</b></li>'
                }
                
                letter += '<li>С 29 апреля 2018 г, документы о регистрации отправляются на адрес электронной почты. Если вам необходимы бумажные документы, подпишите Запрос на получение документов и подайте его с остальными документами.</li><li>Оплатите государственную пошлину и получите квитанцию об оплате госпошлины</li><li>Подайте все вышеперечисленные документы в ' + ifns["title"] + ', адрес: ' + ifns["address"] + ', время работы: ' + ifns["workHours"] + '</li><li>Обратите внимание, что документы можно подавать также и через нотариуса, в этом случае выдача документов также будет производиться нотариусом</li><li><b>Обратите внимание, что какой бы способ подачи документов вы не выбрали, форму Р21001 не надо сшивать и подписывать. Сшивка документа и постановка вашей подписи на нем производится либо в присутствии сотрудника налоговой, либо в присутствии нотариуса</b></li></ul>'
                
                var mailOptions = {
                    from: '"Registrator" <taxregistrator@gmail.com>',
                to: email,
                subject: 'Документы на регистрацию ИП ' + lastName + ' ' + firstName + ' ' + middleName,
                text: 'Документы на регистрацию ИП ' + lastName + ' ' + firstName + ' ' + middleName,
                html: letter,
                attachments: attachments
                };
                return transporter.sendMail(mailOptions, function(error, info){
                    if (error) {
                        reject(new Error("wrongEmail"));
                    } else {
                        resolve();
                    }
                });
            }).catch(err => {
                console.log(err);
            });
        }).then(() => {
            return {
                data: "ok"
            };
        }, (error) => {
            return {
                data: "error"
            };
        });
    });
});


exports.createDeleteIPDocument = functions.https.onCall((data, context) => {
    const id = data.id;
    const uid = data.uid;
    
    return admin.firestore().collection('documents').doc(uid).collection('DeleteIP').doc(id).get().then(document => {
        const lastName = document.data().lastName;
        const firstName = document.data().firstName;
        const middleName = document.data().middleName;
        var inn = document.data().inn;
        var ogrnip = document.data().ogrnip;
        var phoneNumber = document.data().phoneNumber;
        const email = document.data().email;
        const address = document.data().addressCollection;
        const addressStr = document.data().address;
        const ifns = document.data().ifns;
                
        return new Promise((resolve, reject) => {
            const bucketName = 'registrator-3c860.appspot.com';
            const filename = '26001.xlsx';
            const gpPath = 'gp.xlsx';
            const zpPath = 'Запрос.xlsx';
            // Creates a client
            const storage = new Storage();
            function insertName(firstPage) {
                //фамилия
                insertWord(firstPage, lastName.length, lastName, 'T', '16', [], 34);
                //имя
                insertWord(firstPage, firstName.length, firstName, 'T', '18', [], 34);
                //отчество
                insertWord(firstPage, middleName.length, middleName, 'T', '20', [], 34);
            }
            
            function insertGiveMethod(page) {
                const cell = page.getCell('I27');
                cell.value = '2';
            }
            
            function insertWord(page, count, word, start, row, skip, stop) {
                const alph = ['B', 'E', 'H', 'K', 'N', 'Q', 'T', 'W', 'Z', 'AC', 'AF', 'AI', 'AL', 'AO', 'AR', 'AU', 'AX', 'BA', 'BD', 'BG', 'BJ', 'BM', 'BP', 'BS', 'BV', 'BY', 'CB', 'CE', 'CH', 'CK', 'CN', 'CQ', 'CT', 'CW', 'CZ', 'DC', 'DF', 'DI', 'DL', 'DO']
                var ind = alph.indexOf(start);
                var rows = row;
                for (let i = 0; i < count; i++) {
                    if (i===stop) {
                        break;
                    }
                    if (skip.indexOf(i) !== -1) {
                        ind += 1;
                    }
                    const cellStr = alph[ind]+rows;
                    const cell = page.getCell(cellStr);
                    cell.value = word.slice(i, i+1);
                    ind += 1;
                    if (ind === alph.length) {
                        ind = 0;
                        rows = String(Number(rows)+2);
                    }
                }
            }

            async function createWorkbook() {
                return new Promise((resolve, reject) => {
                    let file = storage.bucket(bucketName).file(id + '.xls');
                    var chunks = [];
                    const stream = storage.bucket(bucketName).file(filename).createReadStream()
                    .on('error', function(err) {
                        console.log(err);
                    })
                    .on('response', function(response) {
                        console.log('response: ' + response);
                    }).on('data', function(data) {
                        chunks.push(data);
                    })
                    .on('finish', async function() {
                        const data = Buffer.concat(chunks);
                        const workbook = new Excel.Workbook();
                        await workbook.xlsx.load(data);
                        const firstPage = workbook.worksheets[0];
                        //ФИО
                        insertName(firstPage);
                        //инн
                        inn = inn.replace(/ /gi, '');
                        insertWord(firstPage, inn.length, inn, 'T', '22', [], 12);
                        //огрнип
                        ogrnip = ogrnip.replace(/ /gi, '');
                        insertWord(firstPage, ogrnip.length, ogrnip, 'T', '14', [], 15);
                        //Метод подачи
                        insertGiveMethod(firstPage);
                        //номер телефона
                        phoneNumber = phoneNumber.replace(/-/gi,'');
                        insertWord(firstPage, phoneNumber.length, phoneNumber, 'AR', '30', [], 20);
                        //email
                        insertWord(firstPage, email.length, email, 'N', '32', [], 35);
                        await workbook.xlsx.write(file.createWriteStream());
                        resolve();
                    })
                    .resume();
                });
            }
            

            createWorkbook().then(async ()=>{
                return new Promise((resolve, reject) => {
                    let file = storage.bucket(bucketName).file('gp_' + id + '.xlsx');
                    var chunks = [];
                    
                    const stream = storage.bucket(bucketName).file(gpPath).createReadStream()
                    .on('error', function(err) {
                        console.log(err);
                    })
                    .on('response', function(response) {
                        console.log('response: ' + response);
                    }).on('data', function(data) {
                        chunks.push(data);
                    })
                    .on('finish', async function() {
                        const data = Buffer.concat(chunks);
                        const workbook = new Excel.Workbook();
                        await workbook.xlsx.load(data);
                        const page = workbook.worksheets[0];
                        
                        //фио
                        const nameCell = page.getCell('B3');
                        nameCell.value = 'ФИО ' + lastName + ' ' + firstName + ' ' + middleName;
                        const nameCell1 = page.getCell('B16');
                        nameCell1.value = 'ФИО ' + lastName + ' ' + firstName + ' ' + middleName;
                        //адрес
                        const addressCell = page.getCell('C3');
                        addressCell.value = 'Адрес ' + addressStr;
                        const addressCell1 = page.getCell('C16');
                        addressCell1.value = 'Адрес ' + addressStr;
                        //Инн
                        const innCell = page.getCell('B4');
                        innCell.value = 'ИНН ' + inn;
                        const innCell1 = page.getCell('B17');
                        innCell1.value = 'ИНН ' + inn;
                        //сумма
                        const amountCell = page.getCell('C4');
                        amountCell.value = 'Сумма ' + ifns["amount"];
                        const amountCell1 = page.getCell('C17');
                        amountCell1.value = 'Сумма ' + ifns["amount"];
                        //банк
                        const bankCell = page.getCell('B5');
                        bankCell.value = 'Банк получателя ' + ifns["bank"];
                        const bankCell1 = page.getCell('B18');
                        bankCell1.value = 'Банк получателя ' + ifns["bank"];
                        //бик
                        const bikCell = page.getCell('C5');
                        bikCell.value = 'БИК ' + ifns["bik"];
                        const bikCell1 = page.getCell('C18');
                        bikCell1.value = 'БИК ' + ifns["bik"];
                        //получатель
                        const receiverCell = page.getCell('B8');
                        receiverCell.value = 'Получатель ' + ifns["receiverTitle"];
                        const receiverCell1 = page.getCell('B21');
                        receiverCell1.value = 'Получатель ' + ifns["receiverTitle"];
                        //счет№
                        const accountCell = page.getCell('C7');
                        accountCell.value = 'Сч. № ' + ifns["accountNumber"];
                        const accountCell1 = page.getCell('C20');
                        accountCell1.value = 'Сч. № ' + ifns["accountNumber"];
                        //инн получателя
                        const receiverInnCell = page.getCell('C8');
                        receiverInnCell.value = 'ИНН ' + ifns["receiverInn"];
                        const receiverInnCell1 = page.getCell('C21');
                        receiverInnCell1.value = 'ИНН ' + ifns["receiverInn"];
                        //кпп получателя
                        const receiverKppCell = page.getCell('C9');
                        receiverKppCell.value = 'КПП ' + ifns["receiverKpp"];
                        const receiverKppCell1 = page.getCell('C22');
                        receiverKppCell1.value = 'КПП ' + ifns["receiverKpp"];
                        //кбк
                        const kbkCell = page.getCell('B10');
                        kbkCell.value = 'КБК ' + ifns["kbk"];
                        const kbkCell1 = page.getCell('B23');
                        kbkCell1.value = 'КБК ' + ifns["kbk"];
                        //октмо
                        const oktmoCell = page.getCell('C10');
                        oktmoCell.value = 'ОКТМО ' + ifns["oktmo"];
                        const oktmoCell1 = page.getCell('C23');
                        oktmoCell1.value = 'ОКТМО ' + ifns["oktmo"];
                        
                        await workbook.xlsx.write(file.createWriteStream());
                        resolve();
                    })
                    .resume();
                });
            }).then(async ()=>{
                return new Promise((resolve, reject) => {
                    var chunks = [];
                    const file = storage.bucket(bucketName).file('zp_' + id + '.xlsx');
                    const stream = storage.bucket(bucketName).file(zpPath).createReadStream()
                    .on('error', function(err) {
                        console.log(err);
                    })
                    .on('response', function(response) {
                        console.log('response: ' + response);
                    }).on('data', function(data) {
                        chunks.push(data);
                    })
                    .on('finish', async function() {
                        const data = Buffer.concat(chunks);
                        
                        const fio = lastName + ' ' + firstName + ' ' + middleName;
                        const workbook = new Excel.Workbook();
                        await workbook.xlsx.load(data);
                        const page = workbook.worksheets[0];
                        const cell = page.getCell('A1');
                        cell.value = 'От: ' + fio;
                        const cell1 = page.getCell('A2');
                        cell1.value = 'В: ' + ifns["title"];
                        const cell2 = page.getCell('A9');
                        cell2.value = fio + ' / _______________________';
                        const cell3 = page.getCell('A5');
                        cell3.value = 'Я подал документы о государственной регистрации прекращения физическим лицом деятельности в качестве индивидуального предпринимателя.';
                        await workbook.xlsx.write(file.createWriteStream());
                        
                        resolve();
                    })
                    .resume();
                });
            }).then(async ()=>{
                const options = {
                version: 'v4',
                action: 'read',
                expires: Date.now() + 10 * 60 * 1000, // 10 minutes
                };
                const [fileURL] = await storage.bucket(bucketName).file(id + '.xls').getSignedUrl(options);
                const [gpURL] = await storage.bucket(bucketName).file('gp_' + id + '.xlsx').getSignedUrl(options);
                const [zpURL] = await storage.bucket(bucketName).file('zp_' + id + '.xlsx').getSignedUrl(options);
                const urls = [fileURL, gpURL, zpURL]
                return urls;
            }).then((urls) => {
                
                var letter = '<p><b>Спасибо, что воспользовались нашим сервисом!</b></p><p>Для успешного завершения ликвидации ИП вам необходимо совершить следующие действия:</p><ul><li>Распечатать полученный комплект документов</li>'
                
                
                letter += '<li>В случае если документы на ликвидацию ИП будут подаваться по доверенности другим человеком вам необходимо: заверить у нотариуса свою подпись на форме Р26001; оформить нотариальную доверенность на человека, который будет подавать документы в налоговую</li>'
                
                
                letter += '<li>С 29 апреля 2018 г, документы о регистрации отправляются на адрес электронной почты. Если вам необходимы бумажные документы, подпишите Запрос на получение документов и подайте его с остальными документами.</li><li>Оплатите государственную пошлину и получите квитанцию об оплате госпошлины</li><li>Подайте все вышеперечисленные документы в ' + ifns["title"] + ', адрес: ' + ifns["address"] + ', время работы: ' + ifns["workHours"] + '</li><li>Обратите внимание, что документы можно подавать также и через нотариуса, в этом случае выдача документов также будет производиться нотариусом</li><li><b>Обратите внимание, что какой бы способ подачи документов вы не выбрали, форму Р26001 не надо сшивать и подписывать. Сшивка документа и постановка вашей подписи на нем производится либо в присутствии сотрудника налоговой, либо в присутствии нотариуса</b></li></ul>'
                
                var mailOptions = {
                    from: '"Registrator" <taxregistrator@gmail.com>',
                to: email,
                subject: 'Документы на ликвидацию ИП ' + lastName + ' ' + firstName + ' ' + middleName,
                text: 'Документы на ликвидацию ИП ' + lastName + ' ' + firstName + ' ' + middleName,
                html: letter,
                attachments: [
                              {
                filename: 'P26001.xlsx',
                path: urls[0]
                },
                              {
                filename: 'Квитанция на оплату госпошлины.xlsx',
                path: urls[1]
                },
                              {
                filename: 'Запрос на получение документов.xlsx',
                path: urls[2]
                }
                              ]
                };
                return transporter.sendMail(mailOptions, function(error, info){
                    if (error) {
                        reject(new Error("wrongEmail"));
                    } else {
                        resolve();
                    }
                });
            }).catch(err => {
                console.log(err);
            });
        }).then(() => {
            return {
                data: "ok"
            };
        }, (error) => {
            return {
                data: "error"
            };
        });
    });
});

exports.createUSN = functions.https.onCall((data, context) => {
    const id = data.id;
    const uid = data.uid;
    
    return admin.firestore().collection('documents').doc(uid).collection('Usn').doc(id).get().then(document => {
        const lastName = document.data().lastName;
        const firstName = document.data().firstName;
        const middleName = document.data().middleName;
        var inn = document.data().inn;
        const email = document.data().email;
        const ifnsCode = document.data().addressCollection["fnsCode"];
        const ifns = document.data().ifns;
        const taxesRate = document.data().taxesRate;
        const usnGiveTime = document.data().usnGiveTime;
                
        return new Promise((resolve, reject) => {
            const bucketName = 'registrator-3c860.appspot.com';
            const usnPath = 'usn.xlsx'
            const storage = new Storage();
            
            function insertWord(page, count, word, start, row, skip, stop) {
                const alph = ['B', 'E', 'H', 'K', 'N', 'Q', 'T', 'W', 'Z', 'AC', 'AF', 'AI', 'AL', 'AO', 'AR', 'AU', 'AX', 'BA', 'BD', 'BG', 'BJ', 'BM', 'BP', 'BS', 'BV', 'BY', 'CB', 'CE', 'CH', 'CK', 'CN', 'CQ', 'CT', 'CW', 'CZ', 'DC', 'DF', 'DI', 'DL', 'DO']
                var ind = alph.indexOf(start);
                var rows = row;
                for (let i = 0; i < count; i++) {
                    if (i===stop) {
                        break;
                    }
                    if (skip.indexOf(i) !== -1) {
                        ind += 1;
                    }
                    const cellStr = alph[ind]+rows;
                    const cell = page.getCell(cellStr);
                    cell.value = word.slice(i, i+1);
                    ind += 1;
                    if (ind === alph.length) {
                        ind = 0;
                        rows = String(Number(rows)+2);
                    }
                }
            }
            
            function getTaxPayerCode() {
                if (usnGiveTime === "С момента регистрации ИП") {
                    return "1"
                } else if (usnGiveTime === "Не более 30 дней после регистрации ИП") {
                    return "2"
                } else if (usnGiveTime === "C 1-го числа следующего месяца") {
                    return "2"
                } else {
                    return "3"
                }
            }
            
            function getDateCode() {
                if (usnGiveTime === "С момента регистрации ИП") {
                    return "2"
                } else if (usnGiveTime === "Не более 30 дней после регистрации ИП") {
                    return "2"
                } else if (usnGiveTime === "C 1-го числа следующего месяца") {
                    return "3"
                } else {
                    return "1"
                }
            }
            
            async function createWorkbook() {
                return new Promise((resolve, reject) => {
                    let file = storage.bucket(bucketName).file('usn_' + id + '.xlsx');
                    var chunks = [];
                    
                    const stream = storage.bucket(bucketName).file(usnPath).createReadStream()
                    .on('error', function(err) {
                        console.log(err);
                    })
                    .on('response', function(response) {
                        console.log('response: ' + response);
                    }).on('data', function(data) {
                        chunks.push(data);
                    })
                    .on('finish', async function() {
                        const data = Buffer.concat(chunks);
                        const workbook = new Excel.Workbook();
                        await workbook.xlsx.load(data);
                        const page = workbook.worksheets[0];
                        
                        //фио
                        const fio = lastName + ' ' + firstName + ' ' + middleName
                        insertWord(page, fio.length, fio, 'B', '15', [], 160);
                        //инн
                        inn = inn.replace(/ /gi, '');
                        insertWord(page, inn.length, inn, 'AL', '1', [], 12);
                        //код
                        insertWord(page, ifnsCode.length, ifnsCode, 'AO', '11', [], 4);
                        //признак налогоплательщика
                        const payerCell = page.getCell('CQ11');
                        payerCell.value = getTaxPayerCode();
                        //код даты перехода на упрощенку
                        const dateCell = page.getCell('AZ24');
                        dateCell.value = getDateCode();
                        //дата перехода на упрощенку
                        var now = new Date();
                        var current = new Date(now.getFullYear(), now.getMonth(), 1);
                        if (getDateCode() === "1") {
                            const nextYear = current.getFullYear() + 1;
                            const strYear = nextYear.toString();
                            insertWord(page, strYear.length, strYear, 'T', '26', [], 4);
                        } else if (getDateCode() === "3") {
                            const nextMonth = new Date(current.getFullYear(), current.getMonth() + 1, 1);
                            const year = nextMonth.getFullYear();
                            const month = nextMonth.getMonth() + 1;
                            const strYear = year.toString();
                            const strMonth = month.toString();
                            const date = "01" + strMonth + strYear;
                            insertWord(page, date.length, date, 'CH', '26', [2, 4], 8);
                        }
                        //дата подачи заявления
                        insertWord(page, now.getFullYear().toString().length, now.getFullYear().toString(), 'BY', '32', [], 4);
                        
                        
                        if (taxesRate === "Доходы (6% от всех доходов)") {
                            const cell = page.getCell('AT29');
                            cell.value = '1';
                        } else {
                            const cell = page.getCell('AT29');
                            cell.value = '2';
                        }
                        await workbook.xlsx.write(file.createWriteStream());
                        resolve();
                    })
                    .resume();
                });
            }
            
            createWorkbook().then(async ()=>{
                const options = {
                version: 'v4',
                action: 'read',
                expires: Date.now() + 60 * 60 * 1000, // 60 minutes
                };
                const [url] = await storage.bucket(bucketName).file('usn_' + id + '.xlsx').getSignedUrl(options);
                return url;
                
            }).then((url) => {
                var attachments = [{filename: 'Уведомление о переходе на УСН.xlsx', path: url}]
                var letter = '<p><b>Спасибо, что воспользовались нашим сервисом!</b></p><p>Для успешной подачи уведомления о переходе на УСН вам необходимо совершить следующие действия:</p><ul>'
                letter += '<li>В Заявлении о переходе на УСН в нижней левой части листа необходимо поставить свою подпись и вписать дату подачи документов. Дату можно вписать либо <b>черной</b> ручкой либо на компьютере. <b>Заявление необходимо распечатать в 3-х экземплярах(один вам вернут с отметкой налогового органа)</b></li>'
                letter += '<li>Подайте 3 копии уведомления в ' + ifns["title"] + ', адрес: ' + ifns["address"] + ', время работы: ' + ifns["workHours"] + '</li></ul>'
                
                var mailOptions = {
                    from: '"Registrator" <taxregistrator@gmail.com>',
                to: email,
                subject: 'Документы о переходе на УСН ИП ' + lastName + ' ' + firstName + ' ' + middleName,
                text: 'Документы о переходе на УСН ИП ' + lastName + ' ' + firstName + ' ' + middleName,
                html: letter,
                attachments: attachments
                };
                return transporter.sendMail(mailOptions, function(error, info){
                    if (error) {
                        reject(new Error("wrongEmail"));
                    } else {
                        resolve();
                    }
                });
            }).catch(err => {
                console.log(err);
            });
        }).then(() => {
            return {
            data: "ok"
            };
        }, (error) => {
            return {
            data: "error"
            };
        });
    });
});
