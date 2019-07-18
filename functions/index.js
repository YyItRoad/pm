'use strict';
const util = require('util');
const querystring = require("querystring");
const functions = require('firebase-functions');
const request = require('request');
const express = require('express');
const moment = require('moment');
const admin = require('firebase-admin');
admin.initializeApp();
const firestore = admin.firestore();


const Get = util.promisify(request.get);


// const app = express();
// const port = 3000

// app.get('/', (req, res) => res.send('Hello World!'))
// app.get('/images', (req, res) => {
//     getImages();

// });

// app.listen(port, () => console.log(`Example app listening on port ${port}!`));

async function getImages () {
    var postData = querystring.stringify({
        'key': '12867283-100a2233d88e942ce417982de',
        'image_type': 'photo',
    });
    try {
        let res = await Get('https://pixabay.com/api?' + postData);
        if (res && res.body) return res.body['hits'];
    } catch (error) {
        console.error(error);
        return [{ 'id': "123" }];
    }
}

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.images = functions.https.onRequest(async (req, res) => {
    let today = moment().format('100YYYYMMDD');
    let query = admin.database().ref(`/phases/${today}/images`)
    let val = await query.once('value');
    if (val.exists()) {
        res.json(val.val());
    } else {
        try {
            await query.set(await getImages());
        } catch (error) {
            console.error(error);
        }
    }
    res.json(Object.assign({ "format": today }, val.val()));
});