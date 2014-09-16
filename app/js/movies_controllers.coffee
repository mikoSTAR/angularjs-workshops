angular.module "movieApp.controllers"

.controller "MovieCtrl", ($scope, Restangular, $stateParams, $state) ->
  $scope.id = parseInt($stateParams.id)
  movie = $scope.$parent.movies.filter((el) ->
    el.id is $scope.id
  )
  $scope.movie = movie[0]
  $scope.tmp = current_comment: ""
  $scope.user =
    name: "Biff"
    rate: 0

  $scope.addComment = ->
    comment =
      body: $scope.tmp.current_comment
      user_name: $scope.user.name

    $scope.movie.comments.push comment
    $scope.tmp.current_comment = ""

  $scope.isAddDisabled = ->
    $scope.post.$invalid

  $scope.back = ->
    $state.go "movies.list"

.controller "MovieListCtrl", ($scope, Restangular, $state) ->
  $scope.movies = []
  $scope.search = title: ""
  $scope.user =
    name: "Biff"
    rate: 0

  $scope.tmp = current_comment: ""
  $scope.isCollapsed = true
  Restangular.all("movies").getList().then (movies) ->
    $scope.movies = movies

  $scope.addComment = (movie) ->
    comment =
      body: $scope.tmp.current_comment
      user_name: $scope.user.name

    movie.comments.push comment
    $scope.tmp.current_comment = ""

  $scope.likeTitle = (title) ->
    alert "Polubiłeś film " + title

  $scope.likeDirector = (director) ->
    alert "Polubiłeś reżysera " + director

  $scope.open = (id) ->
    $state.go "movies.item",
      id: id

