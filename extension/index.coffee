`
// ==UserScript==
// @name       AMap demo extension
// @namespace  http://github.com/bcho/amap-demo
// @version    0.0.1
// @description  TODO
// @match      http://www.amap.com/*
// @copyright  2014 MIT License
// @require http://cdn.staticfile.org/jquery/2.1.1-rc2/jquery.min.js
// @grant GM_xmlhttpRequest
// ==/UserScript==
`

__uuid = ->
  val = if __uuid.__seq? then __uuid.__seq + 1 else 0
  __uuid.__seq = val
  return val


class RouteResult

  routeResultIdKey: 'route-result-id'
  checkTimeOutMS: 2000
  selector: null

  inject: =>
    console.debug "Try to inject our spy..."
    $results = $ @selector

    if $results.length > 0
      # Found results, inject our spy.
      console.debug "Found results #{@selector}, inject spy."
      @injectButton $ result for result in $results

  tryInject: =>
    window.setInterval @inject, @checkTimeOutMS

  injectButton: ($result) =>
    # Already injected.
    return if $result.find('.amap-route-hook').length > 0
    
    # Generate a unique id for this result.
    resultId = __uuid()
    $result.attr(@routeResultIdKey, resultId)

    # Inject icon.
    iconTmpl = """<div title="打印"
                    class="ml15 icon_marker cursor amap-route-hook"
                    #{@routeResultIdKey}="#{resultId}">
                  </div>
               """

    $header = $result.find('.J_smsPlanToPhone')
    if not $header
      console.wan 'Fail to inject icon.'
      return
    $header.after(iconTmpl)

    # Bind click event.
    $icon = $ """[#{@routeResultIdKey}="#{resultId}"]"""
    $icon.click (e) =>
      e.preventDefault()
      e.stopPropagation()

      route = @parseRoute $result

      # TODO Sent route to printer.
      alert "From: #{route.from} To: #{route.to} Steps: #{route.steps.length}"
      console.log route


  parseRoute: ($result) ->
    console.log 'Parse route from result'


class DriveRouteResult extends RouteResult

  selector: '.route_info_div'

  parseRoute: ($result) ->
    parseRouteSteps = ($result) ->
      parseLine = ($line) ->
        $line.find('.polylineitem_details').text().trim()
      
      (parseLine $ i for i in $result.find '.polylineitem')

    route =
      from: $result.find('.J_routeFrom').text().trim()
      to: $result.find('.J_routeTo').text().trim()
      steps: parseRouteSteps $result


class BusRouteResult extends RouteResult
  
  selector: '.bus_info_div'

  parseRoute: ($result) ->
    parseRouteSteps = ($result) ->
      parseLine = ($line) ->
        $line.find('.busstep_details').text().trim()
      
      (parseLine $ i for i in $result.find '.bus_route_step')

    route =
      from: $result.find('.J_busRouteStepStart').text().trim()
      to: $result.find('.J_busRouteStepEnd').text().trim()
      steps: parseRouteSteps $result


class WalkRouteResult extends RouteResult
  
  selector: '.route_info_div'

  parseRoute: ($result) ->
    parseRouteSteps = ($result) ->
      parseLine = ($line) ->
        $line.find('.polylineitem_details').text().trim()
      
      (parseLine $ i for i in $result.find '.polylineitem')

    route =
      from: $result.find('.J_routeFrom').text().trim()
      to: $result.find('.J_routeTo').text().trim()
      steps: parseRouteSteps $result


startInject = ->
  (new DriveRouteResult).tryInject()
  (new BusRouteResult).tryInject()


main = ->
  startInject()

main()
