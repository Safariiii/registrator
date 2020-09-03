const functions = require('firebase-functions');
const admin = require('firebase-admin');
const https = require('https');

const { Storage } = require('@google-cloud/storage');
const Excel = require('exceljs')
const nodemailer = require('nodemailer');
const path = require('path');
const os = require('os');
const fs = require('fs');
admin.initializeApp();

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
         const bucketName = 'reg';
         const filename = '21001.XLS';

        // Creates a client
        const storage = new Storage();

        function generateV4ReadSignedUrl() {
          // These options will allow temporary read access to the file
          const options = {
            version: 'v4',
            action: 'read',
            expires: Date.now() + 15 * 60 * 1000, // 15 minutes
          };

          // Get a v4 signed URL for reading the file
          const [url] = await storage.bucket(bucketName).file(filename).getSignedUrl(options);

          console.log('Generated GET signed URL:');
          console.log(url);
          console.log('You can use this URL with any user agent, for example:');
          console.log(`curl '${url}'`);
        }

        generateV4ReadSignedUrl().catch(console.error);
        
//
//        const storage = new Storage();
//////
//        let bucket = storage.bucket("reg");
//////        let file = bucket.file("21001.XLS");
////
//        const tempFilePath = path.join(os.tmpdir(), "new.xls");
//////
//        bucket.file("21001.XLS").download({destination: tempFilePath});
//
////        let workbook = file;
////        let worksheet = workbook.addWorksheet('Debtors');
//
//
//
//        var mailOptions = {
//            from: 'safargaleev16@gmail.com',
//        to: 'safargaleev92@mail.ru',
//        subject: 'Sending Email using Node.js',
//        text: 'That was easy!',
//        attachments: [
//            {
//                filename: 'text1.xls',
//                path: tempFilePath
//            }
//            ]
//        };
//        transporter.sendMail(mailOptions, function(error, info){
//            if (error) {
//                console.log(error);
//            } else {
//                console.log('Email sent: ' + info.response);
//
//            }
//            fs.unlinkSync(tempFilePath);
//        });
        resolve();
    }).then(() => {
        return {
            data: "ok"
        };
    });
});
