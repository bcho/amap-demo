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

CHECK_TIMEOUT_MS = 2000
ROUTE_RESULT_SELECTOR = '.route_info_div'
ROUTE_RESULT_ID_KEY = 'data-result-id'
ROUTE_RESULT_ICON_KEY = 'data-result-icon-id'

__uuid = ->
  val = if __uuid.__seq? then __uuid.__seq + 1 else 0
  __uuid.__seq = val
  return val


main = ->
  injectWaiter()


parseRouteSteps = ($result) ->
  parseLine = ($line) ->
    $line.find('.polylineitem_details').text().trim()
  
  (parseLine $ i for i in $result.find '.polylineitem')


parseRouteResult = ($result) ->
  route =
    from: $result.find('.J_routeFrom').text().trim()
    to: $result.find('.J_routeTo').text().trim()
    steps: parseRouteSteps $result


injectRouteResult = ($result) ->
  # Inject unique id to the result.
  resultId = __uuid()
  $result.attr(ROUTE_RESULT_ID_KEY, resultId)

  # Inject icon.
  iconTmpl = """<div title="打印"
                  class="ml15 icon_marker cursor"
                  #{ROUTE_RESULT_ICON_KEY}="#{resultId}">
                </div>
             """

  $header = $result.find('.J_smsPlanToPhone')
  if not $header
    console.warn 'Fail to inject icon.'
    return
  $header.after(iconTmpl)

  # Bind click event.
  $icon = $ """[#{ROUTE_RESULT_ICON_KEY}="#{resultId}"]"""
  $icon.click (e) ->
    e.preventDefault()
    e.stopPropagation()

    route = parseRouteResult $result

    # TODO Sent route to printer.
    alert "From: #{route.from} To: #{route.to} Steps: #{route.steps.length}"
    console.log route


injectWaiter = ->
  console.debug 'Waiting to inject spy.'
  
  $routeResults = $ ROUTE_RESULT_SELECTOR

  if $routeResults.length > 0
    # Found results, inject our spy.
    console.debug 'Found results.'
    injectRouteResult ($ result) for result in $routeResults
  else
    # Try again later.
    console.debug 'Will try again...'
    window.setTimeout injectWaiter, CHECK_TIMEOUT_MS


main()
