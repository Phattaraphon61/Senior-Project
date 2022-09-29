const mongoose = require('mongoose')
const constants = require('../configs/constants')   

const testSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            require: true
        },
        email: {
            type: String,
            require: true
        },
        age: {
            type: String
        }
    }
)

const TestModel = mongoose.model('Test', testSchema)

module.exports = TestModel