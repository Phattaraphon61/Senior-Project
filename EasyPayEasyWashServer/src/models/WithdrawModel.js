const mongoose = require('mongoose')
const Schema = require('mongoose')

const WithdrawSchema = new mongoose.Schema(
    {
        userid: {
            type: Schema.Types.ObjectId,
            ref: 'User',
            require: true
        },
        bank: {
            type: Object,
            require: true
        },
        amount: {
            type: Number,
            require: true
        },
        status: {
            type: String,
            default: "wait",
            enum: ['wait', 'approve', 'rejected']
        },
        detail: {
            type: String,
        }
    }, { timestamps: true }
)

const WithdrawModel = mongoose.model('Withdraw', WithdrawSchema)

module.exports = WithdrawModel