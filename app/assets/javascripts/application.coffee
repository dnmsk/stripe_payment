#= require sugarjs
#= require jquery
#= require jquery_ujs 
#= require turbolinks

#= require_self

#= require_tree ./pages
#= require_tree .

$ ->
  #Turbolinks.enableProgressBar true

bindings =
  'turbolinks:load': []
  'turbolinks:visit': []

@on = (events, body_classes..., callback) ->
  for event in events.split(' ')
    bindings[event].push
      body_classes: body_classes
      callback: callback

$(document).on 'turbolinks:visit turbolinks:load', (e) =>
  $body = $(document.body)

  for event_bindings in bindings[e.type]
    body_classes = event_bindings.body_classes

    if !body_classes.length
      event_bindings.callback()
    if Sugar.Array.some(body_classes, (v) -> document.body.className.includes(v))
      event_bindings.callback()
