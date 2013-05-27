services = angular.module('spokenvote.services')

SessionService = ($cookieStore, UserSessionResource, UserRegistrationResource, UserOmniauthResource) ->
  currentUser: $cookieStore.get '_spokenvote_session'

  signedIn: !!$cookieStore.get '_spokenvote_session'

  signedOut: not @signedIn

  userSession: new UserSessionResource
    email: $cookieStore.get 'spokenvote_email'
    password: null
    remember_me: true

  userOmniauth: new UserOmniauthResource
    provider: "facebook"

  userRegistration: new UserRegistrationResource
    name: null
    email: $cookieStore.get 'spokenvote_email'
    password: null
    password_confirmation: null

services.factory 'SessionService', SessionService

AlertService = ->
  callingScope: null
  alertMessage: null
  jsonResponse: null
  jsonErrors: null
  alertClass: null
  cltActionResult: null

  setCallingScope: (scope) ->
    @callingScope = scope
    console.log @callingScope

  setSuccess: (msg) ->
    @alertMessage = msg
    @alertClass = 'alert-success'

  setError: (msg) ->
    @alertMessage = msg
    @alertClass = 'alert-error'

  setJson: (json) ->
    @jsonResponse = json
    @jsonErrors = json if json > ' '

  setCtlResult: (result) ->
    @cltActionResult = result
    @alertClass = 'alert-error'

  clearAlerts: ->
    @callingScope = null
    @alertMessage = null
    @jsonResponse = null
    @jsonErrors = null
    @alertClass = null
    @cltActionResult = null

services.factory 'AlertService', AlertService

# registers an interceptor for ALL angular ajax http calls
errorHttpInterceptor = ($q, $location, $rootScope, AlertService) ->
  (promise) ->
    promise.then ((response) ->
      response
    ), (response) ->
      if response.status is 406
        AlertService.setError "Please sign in to continue."
        $rootScope.$broadcast "event:loginRequired"
      else AlertService.setError "The server was unable to process your request."  if response.status >= 400 and response.status < 500
      $q.reject response

services.factory 'errorHttpInterceptor', errorHttpInterceptor


HubSelected = ->
  group_name: "All Groups"
  id: "No id yet"

services.factory 'HubSelected', HubSelected

SpokenvoteCookies = ($cookies) ->
  $cookies.SpokenvoteSession = "Setting a value6"
  sessionCookie: $cookies.SpokenvoteSession

SpokenvoteCookies.$inject = [ '$cookies' ]
services.factory 'SpokenvoteCookies', SpokenvoteCookies
