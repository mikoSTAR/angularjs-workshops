angular.module "movieApp.directives"

.directive "likeSomething", ->
  restrict: "A"
  scope:
    whatToLike: "="
    showLike: "&"

  link: (scope, element, attrs) ->
    element.append "<i id=\"like-something\" class=\"glyphicon glyphicon-heart-empty\"></i>"
    element.find("i#like-something").bind "click", ->
      if element.find("i.glyphicon").hasClass("glyphicon-heart-empty")
        element.find("i.glyphicon").removeClass "glyphicon-heart-empty"
        element.find("i.glyphicon").addClass "glyphicon-heart"
        element.find("i.glyphicon.glyphicon-heart").css "color", "red"
        scope.showLike whatToLike: attrs.whatToLike
      else
        element.find("i.glyphicon").removeClass "glyphicon-heart"
        element.find("i.glyphicon").addClass "glyphicon-heart-empty"
        element.find("i.glyphicon.glyphicon-heart-empty").css "color", ""


.directive "searchBox", ->
  restrict: "EA"
  templateUrl: "templates/search_box.html"


.directive "movieTitle", ->
  restrict: "EA"
  templateUrl: "templates/movie_title.html"


.directive "rateMovie", ->
  restrict: "EA"
  templateUrl: "templates/rate_movie.html"


.directive "activeRow", ->
  link: (scope, elem) ->
    elem.bind "mouseenter", ->
      elem.addClass "active-row"

    elem.bind "mouseleave", ->
      elem.removeClass "active-row"
