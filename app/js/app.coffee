angular.module("movieApp.controllers", [])
angular.module("movieApp.directives", [])

movie_app = angular.module("movieApp", [
  "ui.router",
  "ui.bootstrap",
  "restangular",
  "ngAnimate",
  "movieApp.controllers",
  "movieApp.directives"
])


movie_app.config ($httpProvider) ->
    $httpProvider.defaults.headers.patch["Content-Type"] = "application/json"
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content")

movie_app.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl "http://workshops.briisk.co"
  RestangularProvider.setRequestSuffix ".json"

movie_app.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/movies"
  $stateProvider.state("movies",
    url: "/movies"
    abstract: true
    templateUrl: "templates/movies.html"
    controller: "MovieListCtrl"
  ).state("movies.list",
    url: ""
    templateUrl: "templates/movies.list.html"
  ).state "movies.item",
    url: "/:id"
    templateUrl: "templates/movies.item.html"
    controller: "MovieCtrl"
