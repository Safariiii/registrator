const functions = require('firebase-functions');
const admin = require('firebase-admin');
const https = require('https');

const { Storage } = require('@google-cloud/storage');
const Excel = require('exceljs')
const nodemailer = require('nodemailer');
const path = require('path');
const os = require('os');
const fs = require('fs');
const url = require('url');
var serviceAccount = require("./registrator-3c860-firebase-adminsdk-s717n-ba6154020d");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://registrator-3c860.firebaseio.com"
});

let transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'safargaleev16@gmail.com',
        pass: 'Rus881358'
    }
});

exports.getOKVED = functions.https.onCall((data, context) => {
    
    const razdel = data.razdel;
    
    var url = 'https://apidata.mos.ru/v1/datasets/2745/rows?api_key=6a83c5ad02350635629ea3628783ac90&$filter=Cells/Kod eq ' + razdel;
    
    
    return new Promise((resolve, reject) => {
        https.get(url, (res) => {
                let chunks = '';
                res.on('data', (data) => {
                    chunks += data;
                }).on('end', () => {
                    const data = JSON.parse(chunks);
                    const finalData = [];
                    for(let i = 0; i < data.length; i++) {
                        const kod = data[i].Cells.Kod;
                        if ((kod.startsWith(razdel)) && (kod.length > 4)) {
                            const name = data[i].Cells.Name;
                            const nomdescr = data[i].Cells.Nomdescr;
                            const dataToPush = [kod, name, nomdescr];
                            finalData.push(dataToPush);
                        }
                    }
                    resolve(finalData);
                });
            }).on('error', (e) => {
                console.error(e);
            });
    }).then((finalData) => {
        return {
            data: finalData
        };
    });
});


exports.createDocument = functions.https.onCall((data, context) => {
    return new Promise((resolve, reject) => {
        const bucketName = 'registrator-3c860.appspot.com';
        const filename = '21001.xlsx';
        // Creates a client
        const storage = new Storage();
        
        const lastName = 'САФАРГАЛЕЕВ';
        const firstName = 'РУСЛАН';
        const middleName = 'РИШАТОВИЧ';
        const inn = '123456789123';
        const gender = 'мужской';
        const dateOfBirth = '22.01.1992';
        const placeOfBirth = 'г. Салехард Тюменской обл.';
        const passportSeries = '7411';
        const passportNumber = '788111';
        const passportDate = '02.02.2012';
        const passportGiver = 'Межрайонным отделом УФМС России по Ямало-Ненецкому А.О. в г. Салехард';
        const passportCode = '890-032';
        const giveMethod = 'По доверенности';
        const phoneNumber = '+7(915)215-23-88';
        const email = 'safargaleev92@mail.ru';
        
        
        function insertName(firstPage, name) {
            var str = '';
            let row = '';
            
            if (name === "first") {
                str = lastName;
                row = '14';
            } else if (name === "second") {
                str = firstName;
                row = '16';
            } else if (name === "third") {
                str = middleName;
                row = '19';
            }
            
            for (let i = 0; i < str.length; i++) {
                let column = '';

                if (i === 0) {
                    column = 'T';
                } else if (i === 1) {
                    column = 'W';
                } else if (i === 2) {
                    column = 'Z';
                } else if (i === 3) {
                    column = 'AC';
                } else if (i === 4) {
                    column = 'AF';
                } else if (i === 5) {
                    column = 'AI';
                } else if (i === 6) {
                    column = 'AL';
                } else if (i === 7) {
                    column = 'AO';
                } else if (i === 8) {
                    column = 'AR';
                } else if (i === 9) {
                    column = 'AU';
                } else if (i === 10) {
                    column = 'AX';
                } else if (i === 11) {
                    column = 'BA';
                } else if (i === 12) {
                    column = 'BD';
                } else if (i === 13) {
                    column = 'BG';
                } else if (i === 14) {
                    column = 'BJ';
                } else if (i === 15) {
                    column = 'BM';
                } else if (i === 16) {
                    column = 'BP';
                } else if (i === 17) {
                    column = 'BS';
                } else if (i === 18) {
                    column = 'BV';
                } else if (i === 19) {
                    column = 'BY';
                } else if (i === 20) {
                    column = 'CB';
                } else if (i === 21) {
                    column = 'CE';
                } else if (i === 22) {
                    column = 'CH';
                } else if (i === 23) {
                    column = 'CK';
                } else if (i === 24) {
                    column = 'CN';
                } else if (i === 25) {
                    column = 'CQ';
                } else if (i === 26) {
                    column = 'CT';
                } else if (i === 27) {
                    column = 'CW';
                } else if (i === 28) {
                    column = 'CZ';
                } else if (i === 29) {
                    column = 'DC';
                } else if (i === 30) {
                    column = 'DF';
                } else if (i === 31) {
                    column = 'DI';
                } else if (i === 32) {
                    column = 'DL';
                } else if (i === 33) {
                    column = 'DO';
                } else {
                    continue;
                }
                const cellStr = column+row;
                const cell = firstPage.getCell(cellStr);
                cell.value = str.slice(i, i+1);
            }
        }
        
        function insertINN(page) {
            for (let i = 0; i<inn.length; i++) {
                let column = '';
                if (i === 0) {
                    column = 'AF';
                } else if (i===1) {
                    column = 'AI';
                } else if (i===2) {
                    column = 'AL';
                } else if (i===3) {
                    column = 'AO';
                } else if (i===4) {
                    column = 'AR';
                } else if (i===5) {
                    column = 'AU';
                } else if (i===6) {
                    column = 'AX';
                } else if (i===7) {
                    column = 'BA';
                } else if (i===8) {
                    column = 'BD';
                } else if (i===9) {
                    column = 'BG';
                } else if (i===10) {
                    column = 'BJ';
                } else if (i===11) {
                    column = 'BM';
                } else {
                    continue;
                }
                const cellStr = column+'30';
                const cell = page.getCell(cellStr);
                cell.value = inn.slice(i, i+1);
            }
        }
        
        function insertGender(page) {
            if (gender === 'мужской') {
                const cell = page.getCell('Q33');
                cell.value = '1';
            } else {
                const cell = page.getCell('Q33');
                cell.value = '2';
            }
        }
        
        function insertDateOfBirth(page) {
            for (let i = 0; i<dateOfBirth.length; i++) {
                let column = '';
                if (i === 0) {
                    column = 'X';
                } else if (i===1) {
                    column = 'AA';
                } else if (i===2) {
                    continue;
                } else if (i===3) {
                    column = 'AG';
                } else if (i===4) {
                    column = 'AJ';
                } else if (i===5) {
                    continue;
                } else if (i===6) {
                    column = 'AP';
                } else if (i===7) {
                    column = 'AS';
                } else if (i===8) {
                    column = 'AV';
                } else if (i===9) {
                    column = 'AY';
                } else {
                    continue;
                }
                const cellStr = column+'36';
                const cell = page.getCell(cellStr);
                cell.value = dateOfBirth.slice(i, i+1);
            }
        }
        
        function insertPlaceOfBirth(page) {
            for (let i = 0; i<placeOfBirth.length; i++) {
                let column = '';
                let row = '';
                if (i === 0 || i === 40) {
                    column = 'B';
                } else if (i === 1 || i === 41) {
                    column = 'E';
                } else if (i === 2 || i === 42) {
                    column = 'H';
                } else if (i === 3 || i === 43) {
                    column = 'K';
                } else if (i === 4 || i === 44) {
                    column = 'N';
                } else if (i === 5 || i === 45) {
                    column = 'Q';
                } else if (i === 6 || i === 46) {
                    column = 'T';
                } else if (i === 7 || i === 47) {
                    column = 'W';
                } else if (i === 8 || i === 48) {
                    column = 'Z';
                } else if (i === 9 || i === 49) {
                    column = 'AC';
                } else if (i === 10 || i === 50) {
                    column = 'AF';
                } else if (i === 11 || i === 51) {
                    column = 'AI';
                } else if (i === 12 || i === 52) {
                    column = 'AL';
                } else if (i === 13 || i === 53) {
                    column = 'AO';
                } else if (i === 14 || i === 54) {
                    column = 'AR';
                } else if (i === 15 || i === 55) {
                    column = 'AU';
                } else if (i === 16 || i === 56) {
                    column = 'AX';
                } else if (i === 17 || i === 57) {
                    column = 'BA';
                } else if (i === 18 || i === 58) {
                    column = 'BD';
                } else if (i === 19 || i === 59) {
                    column = 'BG';
                } else if (i === 20 || i === 60) {
                    column = 'BJ';
                } else if (i === 21 || i === 61) {
                    column = 'BM';
                } else if (i === 22 || i === 62) {
                    column = 'BP';
                } else if (i === 23 || i === 63) {
                    column = 'BS';
                } else if (i === 24 || i === 64) {
                    column = 'BV';
                } else if (i === 25 || i === 65) {
                    column = 'BY';
                } else if (i === 26 || i === 66) {
                    column = 'CB';
                } else if (i === 27 || i === 67) {
                    column = 'CE';
                } else if (i === 28 || i === 68) {
                    column = 'CH';
                } else if (i === 29 || i === 69) {
                    column = 'CK';
                } else if (i === 30 || i === 70) {
                    column = 'CN';
                } else if (i === 31 || i === 71) {
                    column = 'CQ';
                } else if (i === 32 || i === 72) {
                    column = 'CT';
                } else if (i === 33 || i === 73) {
                    column = 'CW';
                } else if (i === 34 || i === 74) {
                    column = 'CZ';
                } else if (i === 35 || i === 75) {
                    column = 'DC';
                } else if (i === 36 || i === 76) {
                    column = 'DF';
                } else if (i === 37 || i === 77) {
                    column = 'DI';
                } else if (i === 38 || i === 78) {
                    column = 'DL';
                } else if (i === 39 || i === 79) {
                    column = 'DO';
                } else {
                    continue;
                }
                if (i <= 39) {
                    row = '38';
                } else {
                    row = '40';
                }
                const cellStr = column+row;
                const cell = page.getCell(cellStr);
                cell.value = placeOfBirth.slice(i, i+1);
            }
        }
        
        function insertPassport(page) {
            //вид документа
            const cell1 = page.getCell('W33');
            cell1.value = '2';
            const cell2 = page.getCell('Z33');
            cell2.value = '1';
            
            //серия паспорта
            for (let i = 0; i < passportSeries.length; i++) {
                let column = '';
                if (i===0) {
                    column = 'AG';
                } else if (i===1) {
                    column = 'AJ';
                } else if (i===2) {
                    column = 'AP';
                } else if (i===3) {
                    column = 'AS';
                } else {
                    continue;
                }
                const cellStr = column+'35';
                const cell = page.getCell(cellStr);
                cell.value = passportSeries.slice(i, i+1);
            }
            
            //номер паспорта
            for (let i = 0; i<passportNumber.length; i++) {
                let column = '';
                if (i===0) {
                    column = 'AY';
                } else if (i===1) {
                    column = 'BB';
                } else if (i===2) {
                    column = 'BE';
                } else if (i===3) {
                    column = 'BH';
                } else if (i===4) {
                    column = 'BK';
                } else if (i===5) {
                    column = 'BN';
                } else {
                    continue;
                }
                const cellStr = column+'35';
                const cell = page.getCell(cellStr);
                cell.value = passportNumber.slice(i, i+1);
            }
            
            //дата выдачи
            for (let i = 0; i<passportDate.length; i++) {
                let column = '';
                if (i===0) {
                    column = 'T';
                } else if (i===1) {
                    column = 'W';
                } else if (i===2) {
                    continue;
                } else if (i===3) {
                    column = 'AC';
                } else if (i===4) {
                    column = 'AF';
                } else if (i===5) {
                    continue;
                } else if (i===6) {
                    column = 'AL';
                } else if (i===7) {
                    column = 'AO';
                } else if (i===8) {
                    column = 'AR';
                } else if (i===9) {
                    column = 'AU';
                } else {
                    continue;
                }
                const cellStr = column+'37';
                const cell = page.getCell(cellStr);
                cell.value = passportDate.slice(i, i+1);
            }
            
            //кем выдан паспорт
            for (let i=0; i<passportGiver.length; i++) {
                let column = '';
                let row = '';
                if (i===0 || i===40 || i===80) {
                    column = 'T';
                } else if (i===1 || i===41 || i===81) {
                    column = 'W';
                } else if (i===2 || i===42 || i===82) {
                    column = 'Z';
                } else if (i===3 || i===43 || i===83) {
                    column = 'AC';
                } else if (i===4 || i===44 || i===84) {
                    column = 'AF';
                } else if (i===5 || i===45 || i===85) {
                    column = 'AI';
                } else if (i===6 || i===46 || i===86) {
                    column = 'AL';
                } else if (i===7 || i===47 || i===87) {
                    column = 'AO';
                } else if (i===8 || i===48 || i===88) {
                    column = 'AR';
                } else if (i===9 || i===49 || i===89) {
                    column = 'AU';
                } else if (i===10 || i===50 || i===90) {
                    column = 'AX';
                } else if (i===11 || i===51 || i===91) {
                    column = 'BA';
                } else if (i===12 || i===52 || i===92) {
                    column = 'BD';
                } else if (i===13 || i===53 || i===93) {
                    column = 'BG';
                } else if (i===14 || i===54 || i===94) {
                    column = 'BJ';
                } else if (i===15 || i===55 || i===95) {
                    column = 'BM';
                } else if (i===16 || i===56 || i===96) {
                    column = 'BP';
                } else if (i===17 || i===57 || i===97) {
                    column = 'BS';
                } else if (i===18 || i===58 || i===98) {
                    column = 'BV';
                } else if (i===19 || i===59 || i===99) {
                    column = 'BY';
                } else if (i===20 || i===60 || i===100) {
                    column = 'CB';
                } else if (i===21 || i===61 || i===101) {
                    column = 'CE';
                } else if (i===22 || i===62 || i===102) {
                    column = 'CH';
                } else if (i===23 || i===63 || i===103) {
                    column = 'CK';
                } else if (i===24 || i===64 || i===104) {
                    column = 'CN';
                } else if (i===25 || i===65 || i===105) {
                    column = 'CQ';
                } else if (i===26 || i===66 || i===106) {
                    column = 'CT';
                } else if (i===27 || i===67 || i===107) {
                    column = 'CW';
                } else if (i===28 || i===68 || i===108) {
                    column = 'CZ';
                } else if (i===29 || i===69 || i===109) {
                    column = 'DC';
                } else if (i===30 || i===70 || i===110) {
                    column = 'DF';
                } else if (i===31 || i===71 || i===111) {
                    column = 'DI';
                } else if (i===32 || i===72 || i===112) {
                    column = 'DL';
                } else if (i===33 || i===73 || i===113) {
                    column = 'DO';
                } else if (i===34 || i===74) {
                    column = 'B';
                } else if (i===35 || i===75) {
                    column = 'E';
                } else if (i===36 || i===76) {
                    column = 'H';
                } else if (i===37 || i===77) {
                    column = 'K';
                } else if (i===38 || i===78) {
                    column = 'N';
                } else if (i===39 || i===79) {
                    column = 'Q';
                } else {
                    continue;
                }
                if (i <= 33) {
                    row = '39';
                } else if (i>=34 && i<=73) {
                    row = '41';
                } else if (i>=74) {
                    row = '43';
                }
                const cellStr = column+row;
                const cell = page.getCell(cellStr);
                cell.value = passportGiver.slice(i, i+1);
            }
            
            //код подразделения
            for (let i = 0; i<passportCode.length; i++) {
                let column = '';
                if (i===0) {
                    column = 'Z';
                } else if(i===1) {
                    column = 'AC';
                } else if(i===2) {
                    column = 'AF';
                } else if(i===3) {
                    continue;
                } else if(i===4) {
                    column = 'AL';
                } else if(i===5) {
                    column = 'AO';
                } else if(i===6) {
                    column = 'AR';
                } else {
                    continue;
                }
                const cellStr = column+'45';
                const cell = page.getCell(cellStr);
                cell.value = passportCode.slice(i, i+1);
            }
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
        
        function insertPhoneNumber(page) {
            for (let i=0; i<phoneNumber.length; i++) {
                column = '';
                if (i===0) {
                    column = 'AQ';
                } else if (i===1) {
                    column = 'AT';
                } else if (i===2) {
                    column = 'AW';
                } else if (i===3) {
                    column = 'AZ';
                } else if (i===4) {
                    column = 'BC';
                } else if (i===5) {
                    column = 'BF';
                } else if (i===6) {
                    column = 'BI';
                } else if (i===7) {
                    column = 'BL';
                } else if (i===8) {
                    column = 'BO';
                } else if (i===9) {
                    column = 'BR';
                } else if (i===10) {
                    continue;
                } else if (i===11) {
                    column = 'BU';
                } else if (i===12) {
                    column = 'BX';
                } else if (i===13) {
                    continue;
                } else if (i===14) {
                    column = 'CA';
                } else if (i===15) {
                    column = 'CD';
                } else {
                    continue;
                }
                const cellStr = column+'26';
                const cell = page.getCell(cellStr);
                cell.value = phoneNumber.slice(i, i+1);
            }
        }
        
        function insertEmail(page) {
            for (let i=0; i<email.length; i++) {
                let column = '';
                if (i===0) {
                    column = 'M';
                } else if (i===1) {
                    column = 'P';
                } else if (i===2) {
                    column = 'S';
                } else if (i===3) {
                    column = 'V';
                } else if (i===4) {
                    column = 'Y';
                } else if (i===5) {
                    column = 'AB';
                } else if (i===6) {
                    column = 'AE';
                } else if (i===7) {
                    column = 'AH';
                } else if (i===8) {
                    column = 'AK';
                } else if (i===9) {
                    column = 'AN';
                } else if (i===10) {
                    column = 'AQ';
                } else if (i===11) {
                    column = 'AT';
                } else if (i===12) {
                    column = 'AW';
                } else if (i===13) {
                    column = 'AZ';
                } else if (i===14) {
                    column = 'BC';
                } else if (i===15) {
                    column = 'BF';
                } else if (i===16) {
                    column = 'BI';
                } else if (i===17) {
                    column = 'BL';
                } else if (i===18) {
                    column = 'BO';
                } else if (i===19) {
                    column = 'BR';
                } else if (i===20) {
                    column = 'BU';
                } else if (i===21) {
                    column = 'BX';
                } else if (i===22) {
                    column = 'CA';
                } else if (i===23) {
                    column = 'CD';
                } else if (i===24) {
                    column = 'CG';
                } else if (i===25) {
                    column = 'CJ';
                } else if (i===26) {
                    column = 'CM';
                } else if (i===27) {
                    column = 'CP';
                } else if (i===28) {
                    column = 'CS';
                } else if (i===29) {
                    column = 'CV';
                } else if (i===30) {
                    column = 'CY';
                } else if (i===31) {
                    column = 'DB';
                } else if (i===32) {
                    column = 'DE';
                } else if (i===33) {
                    column = 'DH';
                } else if (i===34) {
                    column = 'DK';
                } else {
                    continue;
                }
                const cellStr = column+'28';
                const cell = page.getCell(cellStr);
                cell.value = email.slice(i, i+1);
            }
        }
        
        async function generateV4ReadSignedUrl() {
            const options = {
                version: 'v4',
                action: 'read',
                expires: Date.now() + 60 * 60 * 1000, // 60 minutes
            };
            
            let newFile = storage.bucket(bucketName).file('data888.xls');
            const writeStream = newFile.createWriteStream();
            let file = storage.bucket(bucketName).file('data999.xls');
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
                const fifthPage = workbook.worksheets[4];
                insertName(firstPage, 'first');
                insertName(firstPage, 'second');
                insertName(firstPage, 'third');
                insertINN(firstPage);
                insertGender(firstPage);
                insertDateOfBirth(firstPage);
                insertPlaceOfBirth(firstPage);
                insertCitizenship(firstPage);
                insertPassport(secondPage);
                insertGiveMethod(fifthPage);
                insertPhoneNumber(fifthPage);
                insertEmail(fifthPage);
                
                await workbook.xlsx.write(file.createWriteStream());
                console.log('end');
//                resolve();
            })
            .resume();
            
            
//            const [url] = await storage.bucket(bucketName).file('data.xlsx').getSignedUrl(options);
//            return url;
            return console.log('done');

        }

        generateV4ReadSignedUrl().then( (url) => {
            
//            var mailOptions = {
//                from: 'safargaleev16@gmail.com',
//            to: 'safargaleev92@mail.ru',
//            subject: 'Sending Email using Node.js',
//            text: 'That was easy!',
//            attachments: [
//                {
//                    filename: 'text1.xls',
//                    path: url
//                }
//                ]
//            };
//            return transporter.sendMail(mailOptions, function(error, info){
//                if (error) {
//                    console.log(error);
//                } else {
//                    console.log('Email sent: ' + info.response);
//                    resolve();
//                }
//            });
//            resolve();
            return console.log(22);
        }).catch(err => {
            console.log(err);
        });
    }).then(() => {
        return {
            data: "ok"
        };
    });
});
