Joi = require 'joiful-experiments'
{object} = require 'utila'

T = Joi.Types

configSchema =

	layout: T.Object()

module.exports = (config, defaultConfig = {}) ->

	finalConfig = object.append defaultConfig, config

	err = Joi.validate finalConfig, configSchema

	if err?

		throw Error err

	else

		return finalConfig