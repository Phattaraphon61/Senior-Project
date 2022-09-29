const express = require('express')
const responseCode = require('../../configs/responseCode')
const WashingModel = require('../../models/WashingModel')
const DashbordModel = require('../../models/DashbordModel')
const WashingDecorator = require('../../decorators/WashingDecorator')
import constants from '../../configs/constants'
var mqttHandler = require('../../mqtt');
const mqtt = constants.MQTT
var mqttClient = new mqttHandler(mqtt);


const router = express.Router()

router.post('/getinfo', async (request, response, next) => {
    console.log(request.body)
    const washingModel = await WashingModel.findOne({ 'washingid': request.body.washingid }).populate('userid')
    const decorator = await WashingDecorator.Decorator(washingModel)
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: decorator
    })
})
router.post('/getmywashing', async (request, response, next) => {
    console.log(request.body)
    const washingModel = await WashingModel.find({ 'userid': request.body.userid })
    const decorator = await washingModel.map(mywashing => WashingDecorator.Decorator(mywashing));
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: decorator
    })
})

router.post('/login', async (request, response, next) => {
    console.log(request.body)
    const washingModel = await WashingModel(request.body).save()
    const decorator = await WashingDecorator.Decorator(washingModel)
    mqttClient.sendMessage(request.body.washingid, 'login,1');
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: decorator
    })
})

router.post('/update', async (request, response, next) => {
    console.log(request.body)
    let washingModel;
    if (request.body.type == "addnoti") {
        washingModel = await WashingModel.findOneAndUpdate({ washingid: request.body.washingid },
            {
                $push: { noti: { lineid: request.body.lineid } },
            }, { 'new': true });
    }
    if (request.body.type == "edit") {
        washingModel = await WashingModel.findOneAndUpdate({ washingid: request.body.washingid },
            {
                $set: { detail: request.body.detail, price: request.body.price },
            }, { 'new': true });
        mqttClient.sendMessage(request.body.washingid, `setcoin,${request.body.price}`);
    }
    const decorator = await WashingDecorator.Decorator(washingModel)
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: decorator
    })
})
router.post('/logout', async (request, response, next) => {
    console.log(request.body)
    const washingModel = await WashingModel.remove({ 'washingid': request.body.washingid })
    const decorator = await WashingDecorator.Decorator(washingModel)
    mqttClient.sendMessage(request.body.washingid, 'login,0');
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: decorator
    })
})


module.exports = router