
const { v4: uuidv4 } = require('uuid');
const axios = require('axios').default;
import constants from '../../configs/constants'
const scbkey = constants.SCBKEY
const scbppi = constants.scbppi
const scbkeysecret = constants.SCBKEYSECRET
const genqrcode = async (item) => {
    let qr;
    let message = await item.split(',')
    let token;
    await axios({
        method: 'post',
        url: 'https://api-sandbox.partners.scb/partners/sandbox/v1/oauth/token',
        data: {
            "applicationKey": scbkey,
            "applicationSecret": scbkeysecret
        },
        headers: {
            "Content-Type": "application/json",
            "resourceOwnerId": scbkey,
            "requestUid": `${uuidv4()}`,
            "accept-language": "EN",
        }
    }).then(res => {
        const { accessToken, tokenType } = res.data.data
        token = tokenType + " " + accessToken
    }).catch(err => {
        qr = "error"
    })
    await axios({
        method: 'post',
        url: 'https://api-sandbox.partners.scb/partners/sandbox/v1/payment/qrcode/create',
        data: {
            "qrType": "PP",
            "amount": `${message[1]}`,
            "ppId": scbppi,
            "ppType": "BILLERID",
            "ref1": `${message[0]}`,
            "ref2": "EASYPAYEASYWASH",
            "ref3": "PUQ"
        },
        headers: {
            "Content-Type": "application/json",
            "authorization": token,
            "resourceOwnerId": scbkey,
            "requestUid": `${uuidv4()}`,
            "accept-language": "EN",
        }
    }).then(res => {
        qr = res.data.data.qrRawData
    }).catch(err => {
        qr = "error"
    })
    return {"id":message[0],"qr":qr};
}

module.exports = { genqrcode }