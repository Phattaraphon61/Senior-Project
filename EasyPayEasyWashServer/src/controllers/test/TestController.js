const express = require('express')

const Joi = require('joi')
const Validate = require('express-joi-validator')
const responseCode = require('../../configs/responseCode')

const TestModel = require('../../models/TestModel')
const TestDecorator = require('../../decorators/TestDecorator')

const router = express.Router()

router.get('/', async (request, response, next) => {
  const data = {
    _id: 'asd235$tsdf12fxz',
    name: 'test01',
    email: 'test01@gmail.com'
  }

  const decorator = await TestDecorator.Decorator(data)
  response.json({
    code: responseCode.SUCCESS,
    message: 'success',
    data: decorator
  })
})

router.post('/', async (request, response, next) => {
  console.log(request.body)
  const testModel = await TestModel(request.body).save()
  const decorator = await TestDecorator.Decorator(testModel)
  response.json({
    code: responseCode.SUCCESS,
    message: 'success',
    data: decorator
  })
})


module.exports = router