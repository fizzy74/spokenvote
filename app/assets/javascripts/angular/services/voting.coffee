VotingService = ( $modal, AlertService, SessionSettings, RelatedVoteInTreeLoader ) ->

  support: ( scope, clicked_proposal ) ->
    scope.clicked_proposal = clicked_proposal
    scope.current_user_support = null
    AlertService.clearAlerts()

    if !scope.currentUser.id?
      AlertService.setInfo 'To support proposals you need to sign in.', scope, 'main'
    else
      RelatedVoteInTreeLoader(clicked_proposal).then (relatedSupport) ->
        if relatedSupport.id?
          if relatedSupport.proposal.id == clicked_proposal.id
            scope.current_user_support = 'this_proposal'
          else
            scope.current_user_support = 'related_proposal'
        if scope.current_user_support == 'this_proposal'
          AlertService.setInfo 'Good news, it looks as if you have already supported this proposal. Further editing is not allowed at this time.', scope, 'main'
        else
          if SessionSettings.openModals.supportProposal is false
            scope.opts =
              resolve:
                $scope: ->
                  scope
#            d = $dialog.dialog(scope.opts)
            SessionSettings.openModals.supportProposal = true
            d.open('/assets/proposals/_support_modal.html', 'SupportCtrl').then (result) ->
              SessionSettings.openModals.supportProposal = d.isOpen()


  improve: ( scope, clicked_proposal ) ->
    scope.clicked_proposal = clicked_proposal
    scope.current_user_support = null
    AlertService.clearAlerts()

    if !scope.currentUser.id?
      AlertService.setInfo 'To improve proposals you need to sign in.', scope, 'main'
    else
      RelatedVoteInTreeLoader(clicked_proposal).then (relatedSupport) ->
        scope.current_user_support = 'related_proposal' if relatedSupport.id?

        if SessionSettings.openModals.improveProposal is false
          modalInstance = $modal.open
            templateUrl: '/assets/proposals/_improve_proposal_modal.html'
            controller: 'ImroveCtrl'
            scope: scope
          modalInstance.opened.then ->
            SessionSettings.openModals.improveProposal = true
          modalInstance.result.finally ->
            SessionSettings.openModals.improveProposal = false


#          scope.opts =
#            resolve:
#              $scope: ->
#                scope
##          d = $dialog.dialog(scope.opts)
#          SessionSettings.openModals.improveProposal = true
#          d.open('/assets/proposals/_improve_proposal_modal.html', 'ImroveCtrl').then (result) ->
#            SessionSettings.openModals.improveProposal = d.isOpen()


  edit: ( scope, clicked_proposal ) ->
    scope.clicked_proposal = clicked_proposal

    if !scope.currentUser.id?
      AlertService.setInfo 'To proceed you need to sign in.', scope, 'main'
    else
      if SessionSettings.openModals.editProposal is false
        modalInstance = $modal.open
          templateUrl: '/assets/proposals/_edit_proposal_modal.html'
          controller: 'EditProposalCtrl'
          scope: scope
        modalInstance.opened.then ->
          SessionSettings.openModals.editProposal = true
        modalInstance.result.finally ->
          SessionSettings.openModals.editProposal = false

  delete: (scope, clicked_proposal) ->
    scope.clicked_proposal = clicked_proposal

    if !scope.currentUser.id?
      AlertService.setInfo 'To proceed you need to sign in.', scope, 'main'
    else
      if SessionSettings.openModals.deleteProposal is false
        modalInstance = $modal.open
          templateUrl: '/assets/proposals/_delete_proposal_modal.html'
          controller: 'DeleteProposalCtrl'
          scope: scope
        modalInstance.opened.then ->
          SessionSettings.openModals.deleteProposal = true
        modalInstance.result.finally ->
          SessionSettings.openModals.deleteProposal = false

  new: (scope) ->
    if !scope.currentUser.id?
      AlertService.setInfo 'To create proposals you need to sign in.', scope, 'main'
    else
      if SessionSettings.openModals.newProposal is false
        modalInstance = $modal.open
          templateUrl: '/assets/proposals/_new_proposal_modal.html'
          controller: 'NewProposalCtrl'
          scope: scope
        modalInstance.opened.then ->
          SessionSettings.openModals.newProposal = true
        modalInstance.result.finally ->
          SessionSettings.openModals.newProposal = false

# Injects
VotingService.$inject = [ '$modal', 'AlertService', 'SessionSettings', 'RelatedVoteInTreeLoader'  ]

# Register
App.Services.factory 'VotingService', VotingService