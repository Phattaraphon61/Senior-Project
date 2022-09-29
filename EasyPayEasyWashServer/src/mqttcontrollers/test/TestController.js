const responseCode = require('../../configs/responseCode')
const TestModel = require('../../models/TestModel')
const TestDecorator = require('../../decorators/TestDecorator')

const Test = async(item) => {
    const testModel = await TestModel(item).save()
    const decorator = await TestDecorator.Decorator(testModel)
    return decorator
}

module.exports = { Test }