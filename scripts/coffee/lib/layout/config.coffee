Joi = require 'joiful-experiments'
{object} = require 'utila'

T = Joi.Types

configSchema =

	terminalWidth: T.Number().integer().min(20).required()

module.exports = (config, defaultConfig = {}) ->

	finalConfig = object.append defaultConfig, config

	err = Joi.validate finalConfig, configSchema

	if err?

		throw Error err

	else

		return finalConfig