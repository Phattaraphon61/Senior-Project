const express = require('express')
const responseCode = require('../../configs/responseCode')
const UserModel = require('../../models/UserModel')
const UserDecorator = require('../../decorators/UserDecorator')

const router = express.Router()


router.post('/create', async (request, response, next) => {
    console.log(request.body)
    let userModel;
    userModel = await UserModel.findOne({ 'fbid': request.body.fbid });
    if (userModel == null) {
        userModel = await UserModel(request.body).save()
    }
    const decorator = await UserDecorator.Decorator(userModel)
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: decorator
    })
})
router.post('/update', async (request, response, next) => {
    console.log(request.body)
    let userMode;
    if (request.body.type == "addbalance") {
        userMode = await UserModel.findOneAndUpdate({ fbid: request.body.fbid },
            {
                $inc: { balance: request.body.balance, total: request.body.balance },
            }, { 'new': true });
    }
    if (request.body.type == "withdraw") {
        userMode = await UserModel.findOneAndUpdate({ fbid: request.body.fbid },
            {
                $inc: { balance: -request.body.balance },
            }, { 'new': true });
    } if (request.body.type == "bank") {
        userMode = await UserModel.findOneAndUpdate({ fbid: request.body.fbid },
            {
                $push: { bank: { bank: request.body.bank, number: request.body.number, name: request.body.name } },
            }, { 'new': true });
    }
    if (request.body.type == "removebank") {
        userMode = await UserModel.updateOne(
            { fbid: request.body.fbid },
            { $pull: { bank: { number: request.body.number } } }
        );
    }
    const decorator = await UserDecorator.Decorator(userMode)
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: decorator
    })
})


module.exports = router