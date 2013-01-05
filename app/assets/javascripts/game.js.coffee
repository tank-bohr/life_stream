# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateWorld = (newGeneration)->
  $('td.cell').each (index, elem) ->
    $elem = $(elem)
    $elem.removeClass('alive dead')
    [i, j] = [$elem.attr('i'), $elem.attr('j')]
    if newGeneration[i][j] > 0
      $elem.addClass('alive')
    else
      $elem.addClass('dead')

$ ->
  setTimeout(->
    source = new EventSource('/game')
    source.addEventListener('update', (e) ->
      data = $.parseJSON(e.data)
      world = data.world
      # console.log(world)
      updateWorld(world)
    )
  , 1)