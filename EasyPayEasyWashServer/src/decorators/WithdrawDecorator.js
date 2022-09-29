const moment = require('moment')
const constants = require('../configs/constants')
const Decorator = (item) => {

    if (!item)
      return {}
  
    return {
      id: item._id,   
      userid: item.userid,
      bank: item.bank,
      amount: item.amount,
      status: item.status,
      detail: item.detail,
      createdAt: moment(item.createdAt).format(constants.DATETIME_FORMAT),
      updatedAt: moment(item.updatedAt).format(constants.DATETIME_FORMAT),
    }
  }
  
  module.exports = { Decorator }
  