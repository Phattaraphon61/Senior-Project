const express = require('express')
const moment = require('moment')
const responseCode = require('../../configs/responseCode')
const DashbordModel = require('../../models/DashbordModel')
const UserModel = require('../../models/UserModel')
const WithdrawModel = require('../../models/WithdrawModel')
const WashingModel = require('../../models/WashingModel')
const DashbordDecorator = require('../../decorators/DashbordDecorator')

const router = express.Router()

router.get('/:year', async (request, response, next) => {
    let withdraw;
    let dashbord
    // const dashbordModel = await DashbordModel.find({ "$expr": { "$eq": [{ "$year": "$createdAt" }, new Date().getFullYear()] } })
    const dashbordModel = await DashbordModel.aggregate([
        {

            $facet: {
                "thisyear": [
                    {
                        "$redact": {
                            "$cond": {
                                "if": {
                                    "$eq": [{ "$year": "$createdAt" }, new Date(request.params.year).getFullYear()]
                                },
                                "then": "$$KEEP",
                                "else": "$$PRUNE"
                            }
                        }
                    },
                ],
                "lasyear": [
                    {
                        "$redact": {
                            "$cond": {
                                "if": {
                                    "$eq": [{ "$year": "$createdAt" }, new Date().getFullYear() - 1]
                                },
                                "then": "$$KEEP",
                                "else": "$$PRUNE"
                            }
                        }
                    },
                ],
            }

        }
    ])
    const washingModel = await WashingModel.aggregate([
        {

            $facet: {
                "count": [
                    { $count: "count" },
                ],
                "thismonth": [
                    {
                        "$redact": {
                            "$cond": {
                                "if": {
                                    "$eq": [{ "$month": "$createdAt" }, new Date().getMonth() + 1]
                                },
                                "then": "$$KEEP",
                                "else": "$$PRUNE"
                            }
                        }
                    },
                    { $count: "thismonth" },
                ],
                "lastmonth": [
                    {
                        "$redact": {
                            "$cond": {
                                "if": {
                                    "$eq": [{ "$month": "$createdAt" }, new Date().getMonth() == 0 ? 12 : new Date().getMonth()]
                                },
                                "then": "$$KEEP",
                                "else": "$$PRUNE"
                            }
                        }
                    },
                    { $count: "lastmonth" },
                ],
            }

        }
    ])
    const userModel = await UserModel.aggregate([
        { $group: { _id: null, user: { $sum: 1 }, total: { $sum: "$balance" } } },
    ])
    const withdrawModel = await WithdrawModel.aggregate([
        {

            $facet: {
                "success": [
                    { $match: { status: { $in: ["approve", "rejected"] } } },
                    { $count: "success" },
                ],
                "notsuccess": [
                    { $match: { status: 'wait' } },
                    { $count: "notsuccess" }
                ],
                "total": [
                    { $match: { status: { $in: ["approve"] } } },
                    {
                        $group: {
                            _id: null,
                            total: { $sum: "$amount" }
                        }
                    }
                ],
                "totalwait": [
                    { $match: { status: { $in: ["wait"] } } },
                    {
                        $group: {
                            _id: null,
                            totalwait: { $sum: "$amount" }
                        }
                    }
                ],
            }

        }
    ])
    //  { $group: { _id: "$status", user: { $sum: 1 }, balance: { $sum: "$amount" } } },
    // {

    //     $facet: {
    //         "success": [
    //             { $match: { status: { $in: ["approve", "rejected"] } } },
    //             { $count: "success" }
    //         ],
    //         "notsuccess": [
    //             { $match: { status: 'wait' } },
    //             { $count: "notsuccess" }
    //         ],
    //     }

    // }
    let m = [];
    let n = [];
    dashbordModel[0].thisyear.map((year) => {
        m.push(new Date(year.createdAt).toLocaleDateString('th-TH', { month: 'long', }))
        n.push(year.amounttotal)
    })
    console.log(withdrawModel[0].success)
    if (washingModel[0].count.length !== 0) {
        dashbord = await { 'washingtotal': washingModel[0].count[0].count }
    } else {
        dashbord = await { 'washingtotal': 0 }
    }

    if (withdrawModel[0].notsuccess.length !== 0 && withdrawModel[0].success.length !== 0 && withdrawModel[0].totalwait.length !== 0) {
        withdraw = await { "aprrove": ((withdrawModel[0].success[0].success / (withdrawModel[0].success[0].success + withdrawModel[0].notsuccess[0].notsuccess)) * 100).toFixed(1), "total": withdrawModel[0].total[0].total, "totalwait": withdrawModel[0].totalwait[0].totalwait }
    } else {
        withdraw = await { "aprrove": withdrawModel[0].success.length === 0 ? 0 : 100, "total": withdrawModel[0].total.length !== 0 ? withdrawModel[0].total[0].total : 0, "totalwait": withdrawModel[0].totalwait.length !== 0 ? withdrawModel[0].totalwait[0].totalwait : 0 }
    }
    // console.log(dashbordModel,userModel,withdrawModel)
    // const decorator = await dashbordModel.map(dashbord => DashbordDecorator.Decorator(dashbord));withdraw.toFixed(1)
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: { "dashbordModel": dashbord, "userModel": userModel[0] ? userModel[0] : { "user": 0, "total": 0 }, "withdrawModel": withdraw, "month": m, 'chart': n }
    })
})
router.post('/', async (request, response, next) => {
    console.log(request.body)
    let dashbordModel;
    dashbordModel = await DashbordModel.findOneAndUpdate({ "$expr": { "$eq": [{ "$month": "$createdAt" }, new Date().getMonth() + 1] } }, {
        $inc: { amounttotal: request.body.amounttotal },
    }, { 'new': true })
    if (dashbordModel == null) {
        dashbordModel = await DashbordModel(request.body).save();
    }
    // const dashbordModel = await DashbordModel(request.body).save()
    // const dashbordModel = await DashbordModel.find({
    //     createdAt: moment(new Date()).format("yy-MM-DD"),
    //         // $lt: "2022-06-01"

    // })
    // const dashbordModel = await DashbordModel.updateMany(
    //     {
    //         $inc: { washing: request.body.washing, amounttotal: request.body.amounttotal },
    //     });
    // const decorator = await dashbordModel.map(dashbord => DashbordDecorator.Decorator(dashbord));
    response.json({
        code: responseCode.SUCCESS,
        message: 'success',
        data: dashbordModel
    })
})

module.exports = router