
const moment = require('moment')
const constants = require('../configs/constants')
const Decorator = (item) => {

  if (!item)
    return {}

  return {
    amounttotal: item.amounttotal,
    createdAt: moment(item.createdAt).format(constants.DATETIME_FORMAT),
    updatedAt: moment(item.updatedAt).format(constants.DATETIME_FORMAT),
  }
}

module.exports = { Decorator }
