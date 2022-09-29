const mongoose = require('mongoose')
const DashbordSchema = new mongoose.Schema(
    {
        amounttotal: {
            type: Number,
        },
    },
    { timestamps: true }
)

const DashbordModel = mongoose.model('Dashbord', DashbordSchema)

module.exports = DashbordModel