(function() {
  var movie_app;

  angular.module("movieApp.controllers", []);

  angular.module("movieApp.directives", []);

  movie_app = angular.module("movieApp", ["ui.router", "ui.bootstrap", "restangular", "ngAnimate", "movieApp.controllers", "movieApp.directives"]);

  movie_app.config(function($httpProvider) {
    $httpProvider.defaults.headers.patch["Content-Type"] = "application/json";
    return $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content");
  });

  movie_app.config(function(RestangularProvider) {
    RestangularProvider.setBaseUrl("http://workshops.briisk.co");
    return RestangularProvider.setRequestSuffix(".json");
  });

  movie_app.config(function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise("/movies");
    return $stateProvider.state("movies", {
      url: "/movies",
      abstract: true,
      templateUrl: "templates/movies.html",
      controller: "MovieListCtrl"
    }).state("movies.list", {
      url: "",
      templateUrl: "templates/movies.list.html"
    }).state("movies.item", {
      url: "/:id",
      templateUrl: "templates/movies.item.html",
      controller: "MovieCtrl"
    });
  });

}).call(this);

(function() {
  angular.module("movieApp.controllers").controller("MovieCtrl", function($scope, Restangular, $stateParams, $state) {
    var movie;
    $scope.id = parseInt($stateParams.id);
    movie = $scope.$parent.movies.filter(function(el) {
      return el.id === $scope.id;
    });
    $scope.movie = movie[0];
    $scope.tmp = {
      current_comment: ""
    };
    $scope.user = {
      name: "Biff",
      rate: 0
    };
    $scope.addComment = function() {
      var comment;
      comment = {
        body: $scope.tmp.current_comment,
        user_name: $scope.user.name
      };
      $scope.movie.comments.push(comment);
      return $scope.tmp.current_comment = "";
    };
    $scope.isAddDisabled = function() {
      return $scope.post.$invalid;
    };
    return $scope.back = function() {
      return $state.go("movies.list");
    };
  }).controller("MovieListCtrl", function($scope, Restangular, $state) {
    $scope.movies = [];
    $scope.search = {
      title: ""
    };
    $scope.user = {
      name: "Biff",
      rate: 0
    };
    $scope.tmp = {
      current_comment: ""
    };
    $scope.isCollapsed = true;
    Restangular.all("movies").getList().then(function(movies) {
      return $scope.movies = movies;
    });
    $scope.addComment = function(movie) {
      var comment;
      comment = {
        body: $scope.tmp.current_comment,
        user_name: $scope.user.name
      };
      movie.comments.push(comment);
      return $scope.tmp.current_comment = "";
    };
    $scope.likeTitle = function(title) {
      return alert("Polubiłeś film " + title);
    };
    $scope.likeDirector = function(director) {
      return alert("Polubiłeś reżysera " + director);
    };
    return $scope.open = function(id) {
      return $state.go("movies.item", {
        id: id
      });
    };
  });

}).call(this);

(function() {
  angular.module("movieApp.directives").directive("likeSomething", function() {
    return {
      restrict: "A",
      scope: {
        whatToLike: "=",
        showLike: "&"
      },
      link: function(scope, element, attrs) {
        element.append("<i id=\"like-something\" class=\"glyphicon glyphicon-heart-empty\"></i>");
        return element.find("i#like-something").bind("click", function() {
          if (element.find("i.glyphicon").hasClass("glyphicon-heart-empty")) {
            element.find("i.glyphicon").removeClass("glyphicon-heart-empty");
            element.find("i.glyphicon").addClass("glyphicon-heart");
            element.find("i.glyphicon.glyphicon-heart").css("color", "red");
            return scope.showLike({
              whatToLike: attrs.whatToLike
            });
          } else {
            element.find("i.glyphicon").removeClass("glyphicon-heart");
            element.find("i.glyphicon").addClass("glyphicon-heart-empty");
            return element.find("i.glyphicon.glyphicon-heart-empty").css("color", "");
          }
        });
      }
    };
  }).directive("searchBox", function() {
    return {
      restrict: "EA",
      templateUrl: "templates/search_box.html"
    };
  }).directive("movieTitle", function() {
    return {
      restrict: "EA",
      templateUrl: "templates/movie_title.html"
    };
  }).directive("rateMovie", function() {
    return {
      restrict: "EA",
      templateUrl: "templates/rate_movie.html"
    };
  }).directive("activeRow", function() {
    return {
      link: function(scope, elem) {
        elem.bind("mouseenter", function() {
          return elem.addClass("active-row");
        });
        return elem.bind("mouseleave", function() {
          return elem.removeClass("active-row");
        });
      }
    };
  });

}).call(this);
