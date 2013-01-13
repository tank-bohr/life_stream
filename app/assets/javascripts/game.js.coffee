# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

buildWorld = (rows, columns) ->
  for i in [0..rows - 1]
    $row = $('<tr class="row"/>').appendTo('#world')
    for j in [0..columns - 1]
      $("<td class=\"cell\" i=#{i} j=#{j}/>").appendTo($row)

updateWorld = (newGeneration) ->
  $('td.cell').each (index, elem) ->
    $elem = $(elem)
    $elem.removeClass('alive dead')
    [i, j] = [$elem.attr('i'), $elem.attr('j')]
    if newGeneration[i][j] > 0
      $elem.addClass('alive')
    else
      $elem.addClass('dead')

$ ->
  params = []
  $world = $('#world')
  for param in ['pattern', 'delay']
    value = $world.attr "data-#{param}"
    params.push "#{param}=#{value}" if value?
  params = params.join('&')

  source = new EventSource("/game?#{params}")
  source.addEventListener 'build', (e) ->
    data = $.parseJSON(e.data)
    buildWorld(data.rows, data.columns)
  
  source.addEventListener 'update', (e) ->
    data = $.parseJSON(e.data)
    world = data.world
    # console.log(world)
    updateWorld(world)