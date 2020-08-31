const functions = require('firebase-functions');
const admin = require('firebase-admin');
const https = require('https');
admin.initializeApp();

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
