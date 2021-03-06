{expect} = require "chai"
utils = require "../utils"
jsdom = require 'mocha-jsdom'
cheerio = require 'cheerio'
sinon = require 'sinon'

ui_events = utils.require "common/ui_events"
# Stub out _hammer_element as not used in testing
sinon.stub(ui_events.prototype, "_hammer_element") 


describe "ui_events", ->
  jsdom()

  html = '<body><canvas></canvas></body>'
  $ = cheerio.load html

  beforeEach ->
    e = new Event "wheel",

    deltaY: 100
    deltaX: 100
    e.bokeh = {}

    @preventDefault = sinon.spy(e, "preventDefault")
    @stopPropagation = sinon.spy(e, "stopPropagation")
    @e = e

    active_scroll = {
      scroll: {
        active: true
      }
    }

    @ui_event = new ui_events({
      hit_area: $('canvas'),
      tool_manager: {
        gestures: active_scroll
      }
    })

  describe "_trigger_scroll", ->

    it "should stopPropagation & preventDefault of event if scroll gesture is active", ->

      @ui_event._trigger_event('scroll', true, @e)
      expect(@stopPropagation.callCount).to.equal 1
      expect(@preventDefault.callCount).to.equal 1

    it "should not stopPropagation & preventDefault of event if scroll gesture is not active", ->

      inactive_scroll = {
        scroll: {}
      }
      ui_event = new ui_events({
        hit_area: $('canvas'),
        tool_manager: {
          gestures: inactive_scroll
        }
      })

      ui_event._trigger_event('scroll', undefined, @e)
      expect(@stopPropagation.callCount).to.equal 0
      expect(@preventDefault.callCount).to.equal 0

  describe "_mouse_wheel", ->

    it "should not stop propagation or prevent default of event", ->
      # This is handled by _trigger function depending on tool state

      sinon.stub(@ui_event, "_bokify_jq")  # Stub out _bokify_jq as not testing it
      sinon.stub(@ui_event, "_trigger")  # Stub out _trigger as not testing it

      @ui_event._mouse_wheel(@e, {})
      expect(@stopPropagation.callCount).to.equal 0
      expect(@preventDefault.callCount).to.equal 0
