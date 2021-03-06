// Generated by CoffeeScript 1.7.1
(function() {
  
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
;
  var BusRouteResult, DriveRouteResult, REMOTE_SERVER, RouteResult, WalkRouteResult, main, startInject, uploadRoute, __uuid,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  REMOTE_SERVER = 'http://127.0.0.1:5566';

  uploadRoute = function(route) {
    return $.post(REMOTE_SERVER, route);
  };

  __uuid = function() {
    var val;
    val = __uuid.__seq != null ? __uuid.__seq + 1 : 0;
    __uuid.__seq = val;
    return val;
  };

  RouteResult = (function() {
    function RouteResult() {
      this.injectButton = __bind(this.injectButton, this);
      this.tryInject = __bind(this.tryInject, this);
      this.inject = __bind(this.inject, this);
    }

    RouteResult.prototype.routeResultIdKey = 'route-result-id';

    RouteResult.prototype.checkTimeOutMS = 2000;

    RouteResult.prototype.selector = null;

    RouteResult.prototype.inject = function() {
      var $results, result, _i, _len, _results;
      console.debug("Try to inject our spy...");
      $results = $(this.selector);
      if ($results.length > 0) {
        console.debug("Found results " + this.selector + ", inject spy.");
        _results = [];
        for (_i = 0, _len = $results.length; _i < _len; _i++) {
          result = $results[_i];
          _results.push(this.injectButton($(result)));
        }
        return _results;
      }
    };

    RouteResult.prototype.tryInject = function() {
      return window.setInterval(this.inject, this.checkTimeOutMS);
    };

    RouteResult.prototype.injectButton = function($result) {
      var $header, $icon, iconTmpl, resultId;
      if ($result.find('.amap-route-hook').length > 0) {
        return;
      }
      resultId = __uuid();
      $result.attr(this.routeResultIdKey, resultId);
      iconTmpl = "<div title=\"打印\"\n  class=\"ml15 icon_marker cursor amap-route-hook\"\n  " + this.routeResultIdKey + "=\"" + resultId + "\">\n</div>";
      $header = $result.find('.J_smsPlanToPhone');
      if (!$header) {
        console.wan('Fail to inject icon.');
        return;
      }
      $header.after(iconTmpl);
      $icon = $("[" + this.routeResultIdKey + "=\"" + resultId + "\"]");
      return $icon.click((function(_this) {
        return function(e) {
          var route;
          e.preventDefault();
          e.stopPropagation();
          route = _this.parseRoute($result);
          console.log(route);
          return uploadRoute(route);
        };
      })(this));
    };

    RouteResult.prototype.parseRoute = function($result) {
      return console.log('Parse route from result');
    };

    return RouteResult;

  })();

  DriveRouteResult = (function(_super) {
    __extends(DriveRouteResult, _super);

    function DriveRouteResult() {
      return DriveRouteResult.__super__.constructor.apply(this, arguments);
    }

    DriveRouteResult.prototype.selector = '.route_info_div';

    DriveRouteResult.prototype.parseRoute = function($result) {
      var parseRouteSteps, route;
      parseRouteSteps = function($result) {
        var i, parseLine, _i, _len, _ref, _results;
        parseLine = function($line) {
          return $line.find('.polylineitem_details').text().trim();
        };
        _ref = $result.find('.polylineitem');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          _results.push(parseLine($(i)));
        }
        return _results;
      };
      return route = {
        from: $result.find('.J_routeFrom').text().trim(),
        to: $result.find('.J_routeTo').text().trim(),
        steps: parseRouteSteps($result)
      };
    };

    return DriveRouteResult;

  })(RouteResult);

  BusRouteResult = (function(_super) {
    __extends(BusRouteResult, _super);

    function BusRouteResult() {
      return BusRouteResult.__super__.constructor.apply(this, arguments);
    }

    BusRouteResult.prototype.selector = '.bus_info_div';

    BusRouteResult.prototype.parseRoute = function($result) {
      var parseRouteSteps, route;
      parseRouteSteps = function($result) {
        var i, parseLine, _i, _len, _ref, _results;
        parseLine = function($line) {
          return $line.find('.busstep_details').text().trim();
        };
        _ref = $result.find('.bus_route_step');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          _results.push(parseLine($(i)));
        }
        return _results;
      };
      return route = {
        from: $result.find('.J_busRouteStepStart').text().trim(),
        to: $result.find('.J_busRouteStepEnd').text().trim(),
        steps: parseRouteSteps($result)
      };
    };

    return BusRouteResult;

  })(RouteResult);

  WalkRouteResult = (function(_super) {
    __extends(WalkRouteResult, _super);

    function WalkRouteResult() {
      return WalkRouteResult.__super__.constructor.apply(this, arguments);
    }

    WalkRouteResult.prototype.selector = '.route_info_div';

    WalkRouteResult.prototype.parseRoute = function($result) {
      var parseRouteSteps, route;
      parseRouteSteps = function($result) {
        var i, parseLine, _i, _len, _ref, _results;
        parseLine = function($line) {
          return $line.find('.polylineitem_details').text().trim();
        };
        _ref = $result.find('.polylineitem');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          _results.push(parseLine($(i)));
        }
        return _results;
      };
      return route = {
        from: $result.find('.J_routeFrom').text().trim(),
        to: $result.find('.J_routeTo').text().trim(),
        steps: parseRouteSteps($result)
      };
    };

    return WalkRouteResult;

  })(RouteResult);

  startInject = function() {
    (new DriveRouteResult).tryInject();
    return (new BusRouteResult).tryInject();
  };

  main = function() {
    return startInject();
  };

  main();

}).call(this);
