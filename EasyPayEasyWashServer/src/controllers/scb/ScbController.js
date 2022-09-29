const express = require('express')
const router = express.Router()
const DashbordModel = require('../../models/DashbordModel')
const WashingModel = require('../../models/WashingModel')
const UserModel = require('../../models/UserModel')
var mqttHandler = require('../../mqtt');
import constants from '../../configs/constants'
const mqtt = constants.MQTT

var mqttClient = new mqttHandler(mqtt);


router.post('/', async (request, response) => {
    let { transactionId, billPaymentRef1, amount } = request.body
    mqttClient.sendMessage(billPaymentRef1, 'op,1');
    console.log(billPaymentRef1, amount)
    let dashbordModel;
    const washingModel = await WashingModel.findOne({ 'washingid': billPaymentRef1 }).populate('userid')
    console.log(washingModel.userid.fbid)
    await UserModel.updateOne({ fbid: washingModel.userid.fbid },
        {
            $inc: { balance: amount, total: amount },
        });
    dashbordModel = await DashbordModel.findOneAndUpdate({
        $expr: {
            $and: [
                {
                    "$eq": [
                        {
                            "$month": "$createdAt"
                        },
                        new Date().getMonth() + 1
                    ]
                },
                {
                    "$eq": [
                        {
                            "$year": "$createdAt"
                        },
                        new Date().getFullYear()
                    ]
                }
            ]
        }
    }, { $inc: { amounttotal: amount } })
    if (dashbordModel == null) {
        dashbordModel = await DashbordModel({ amounttotal: amount }).save();
    }

    // res.status(200).send("scb");
    response.status(200).json({
        "resCode": "00",
        "resDesc ": "success",
        "transactionId": transactionId,
        // "confirmId" : "xxx"
    });
})

module.exports = router