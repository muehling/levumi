process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

module.exports = merge(environment.toWebpackConfig(), {
    mode: 'production'
})
