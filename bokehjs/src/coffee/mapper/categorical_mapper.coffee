_ = require "underscore"
Collection = require "../common/collection"
LinearMapper = require "./linear_mapper"

class CategoricalMapper extends LinearMapper.Model

  map_to_target: (x) ->
    if _.isNumber(x)
      return super(x)
    factors = @get('source_range').get('factors')
    if x.indexOf(':') >= 0
      [factor, percent] = x.split(':')
      percent = parseFloat(percent)
      return super(factors.indexOf(factor) + 0.5 + percent)
    return super(factors.indexOf(x) + 1)

  v_map_to_target: (xs) ->
    if _.isNumber(xs[0])
      return super(xs)
    factors = @get('source_range').get('factors')
    results = Array(xs.length)
    for i in [0...xs.length]
      x = xs[i]
      if x.indexOf(':') >= 0
        [factor, percent] = x.split(':')
        percent = parseFloat(percent)
        results[i] = factors.indexOf(factor) + 0.5 + percent
      else
        results[i] = factors.indexOf(x) + 1
    return super(results)

  map_from_target: (xprime, skip_cat=false) ->
    xprime = super(xprime) - 0.5
    if skip_cat
      return xprime
    factors = @get('source_range').get('factors')
    return factors[Math.floor(xprime)]

  v_map_from_target: (xprimes, skip_cat=false) ->
    x = super(xprimes)
    for i in [0...x.length]
      x[i] = x[i] - 0.5
    if skip_cat
      return x
    result = Array(x)
    factors = @get('source_range').get('factors')
    for i in [0...xprimes.length]
      result[i] = factors[Math.floor(x[i])]
    return result

class CategoricalMappers extends Collection
  model: CategoricalMapper

module.exports =
  Model: CategoricalMapper
  Collection: new CategoricalMappers()
