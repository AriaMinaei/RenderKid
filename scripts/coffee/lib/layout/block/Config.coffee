Joi = require 'joi'
{object} = require 'utila'

_BlockPrependor = require './blockPrependor/_BlockPrependor'
_BlockAppendor = require './blockAppendor/_BlockAppendor'
_LinePrependor = require './linePrependor/_LinePrependor'
_LineAppendor = require './lineAppendor/_LineAppendor'

_LineWrapper = require './lineWrapper/_LineWrapper'

T = Joi.Types

configSchema =

	blockPrependor: T.Object

		fn: T.Extends(_BlockPrependor).required()

		options: T.Object().required()

		.required()

	blockAppendor: T.Object

		fn: T.Extends(_BlockAppendor).required()

		options: T.Object().required()

		.required()

	linePrependor: T.Object

		fn: T.Extends(_LinePrependor).required()

		options: T.Object().required()

		.required()

	lineAppendor: T.Object

		fn: T.Extends(_LineAppendor).required()

		options: T.Object().required()

		.required()

	lineWrapper: T.Object

		fn: T.Extends(_LineWrapper).required()

		options: T.Object().required()

		.required()

	width: T.Number().integer().min(20).required()

	prefixRaw: T.String().required().emptyOk()
	suffixRaw: T.String().required().emptyOk()

module.exports = (config, defaultConfig = {}) ->

	finalConfig = object.append defaultConfig, config

	err = Joi.validate finalConfig, configSchema

	if err?

		throw Error err

	else

		return finalConfig