const mongoose = require('mongoose')

const NotiSchema = new mongoose.Schema(
    {
        washingid: {
            type: String,
            require: true
        },
        lineid: {
            type: String,
            require: true
        },
    }
)

const NotiModel = mongoose.model('Noti', NotiSchema)

module.exports = NotiModel